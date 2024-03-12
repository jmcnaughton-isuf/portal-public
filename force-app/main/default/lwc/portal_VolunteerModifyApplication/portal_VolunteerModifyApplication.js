import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createVolunteerFieldList } from 'c/portal_util_Volunteer';
import initializeVolunteerModifyModal from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerModifyModal';
import volunteerModifyApplicationSave from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_volunteerModifyApplicationSave';
import withdrawVolunteerApplication from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_withdrawVolunteerApplication';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_VolunteerModifyApplication extends LightningElement {
    @api pageName = 'Volunteers';
    @api mainSectionName = 'Volunteer Modify';
    @api volunteerShift;
    @api volunteerId;
    @api refreshParent = () => {};
    @api handleCloseModifyModal = () => {};
    @api isShowListBackButton;
    @api rowsPerPage = 10;
    @track _isRecaptchaEnabled = false;

    // parsed data from frontEndDataMap 
    @track _headerList = [];
    @track _frontEndDataMap = {};
    // response.records straight from backend
    @track _volunteerList = [];
    // data from _volunteerList, choose between interim (preferred) or constituent fields
    @track _frontEndData = [];
    // subset of frontEndData with info necessary for display only 
    @track _displayData = [];
    // is data fresh?
    @track _isFresh = false;
    // num vols to submit
    _transactionSize = 0;
    _withdrawCount = 0;

    _isShowSpinner = false;
    withdrawConst = 'withdraw';    

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_VolunteerControllerBase.volunteerModifyApplicationSave'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    connectedCallback() {
        this._isShowSpinner = true;

        initializeVolunteerModifyModal({params: {pageName: this.pageName, mainSectionName: this.mainSectionName, volunteerShiftId: this.volunteerShift.volunteerShiftId, volunteerId: this.volunteerId}})
        .then(response => {
            if (!response) {
                return;
            }
            this._transactionSize = 0; // just in case

            // createFieldList uses this
            this._frontEndDataMap = response.frontEndDataMap;

            this._displayData = [];
            this._frontEndData = [];
            let recordIndex = 0;
            for (let eachVolunteer of response.records) {
                // chooses interim or constituent info
                let volunteerFields = createVolunteerFieldList(eachVolunteer, this._frontEndDataMap);
                this._frontEndData.push(volunteerFields);
                // reduce all the data down to data needed for display
                let volunteerDisplay = volunteerFields.reduce((accumulator, field) => {
                    if (field.display) {
                        accumulator[field.label] = field.value;
                        // assume all texts fields are editable
                        if (field.fieldType === 'text' || field.fieldType === 'email') {
                            accumulator.callbackMap = accumulator.callbackMap || {};
                            accumulator.callbackMap[field.label] = this.handleInputChange(recordIndex, field.fieldId);
                        }
                    }
                    return accumulator;
                }, {});

                // manually add withdraw column and callback
                volunteerDisplay.key = eachVolunteer.Id;
                volunteerDisplay[this.withdrawConst] = {'messageMap': 
                                                                {'action': 'Withdraw',
                                                                'warning': 'Are you sure you want to withdraw?',
                                                                'cancel': 'No',
                                                                'confirm': 'Yes'},
                                                        'actionClass': 'withdraw'
                                                        };
                volunteerDisplay.callbackMap = volunteerDisplay.callbackMap || {};
                volunteerDisplay.callbackMap[this.withdrawConst] = {'handleAction': this.handleTableResize,
                                                                 'handleCancel': this.handleTableResize,
                                                                 'handleConfirm': this.handleYesWithdraw(eachVolunteer.Id)};

                this._displayData.push(volunteerDisplay);

                recordIndex = recordIndex + 1;
            }

            // Process front end data map to get column info/metadata
            let headerMap = Object.assign({}, response.frontEndDataMap);
            let headerObject = {};

            for (const sectionId in headerMap) {
                if (!headerMap[sectionId].mainSection || !headerMap[sectionId].display
                    || headerObject.hasOwnProperty(headerMap[sectionId].label)) {
                    continue;
                }

                // Display Table component needs {label, fieldId, fieldType} per column
                // fieldId can be interim or constituent - need a single unified ID
                headerObject[headerMap[sectionId].label] = {'order': headerMap[sectionId].orderNumber,
                                                            'info': {'label': headerMap[sectionId].label,
                                                                    'fieldId': headerMap[sectionId].label,
                                                                    'isRequired': headerMap[sectionId].isRequired,
                                                                    // assume all text and email fields are editable
                                                                    'fieldType': (headerMap[sectionId].fieldType === 'text' || headerMap[sectionId].fieldType === 'email') ? 'inputText' : headerMap[sectionId].fieldType,
                                                                    'inputFieldType': headerMap[sectionId].fieldType}
                                                            };
            }

            let headerList = Object.entries(headerObject).sort(([,a],[,b]) => a.order - b.order);
            let newHeaderList = [];

            headerList.forEach(arr => {
                newHeaderList.push(arr[1].info);
            })
            // add Action column for withdraw manually (order implicitly last)
            newHeaderList.push({'label': 'Actions',
                                'fieldId': this.withdrawConst,
                                'fieldType': 'confirmAction'});

            this._headerList = newHeaderList;
            this._volunteerList = response.records;

            this._isShowSpinner = false;
            this._isFresh = true;
        }).catch(error => {
            let errorMap = JSON.parse(error.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        });
    }

    get plural() {
        return this._frontEndData.length !== 1 ? 's' : '';
    }

    get invalidRecord() {
        return !this._isShowSpinner && this._frontEndData.length === 0;
    }

    handleInputChange = (index, fieldId) => {
        // update data structures w user input
        return (event) => {
            let value = event.target.value;
            this._frontEndData[index].forEach(fieldMap => {
                if (fieldMap.id === fieldId && fieldMap.value !== value) {
                    fieldMap.value = value;
                }
            });
        }
    }

    handleCloseModal(action) {
        this.resetData();
        if (this._withdrawCount > 0) {
            this.handleCloseModifyModal("refreshList");
        }
        else {
            this.handleCloseModifyModal(action);
        }
    }

    handleTableResize = () => {
        let table = this.template.querySelector('c-portal_-table');
        table.equalHeight(true, true);
    }

    handleYesWithdraw = (key) => {
        return () => {
            this._isShowSpinner = true;

            withdrawVolunteerApplication({params: {volunteerId: key}})
            .then(() => {
                ++this._withdrawCount;
                this.refreshParent();
                this._isShowSpinner = false;
                // stay on modify page if vols still remain
                if (this._volunteerList && this._volunteerList.length > 1) {
                    this.volunteerId = ''; // idk why this instance var is a thing
                    this.resetData();
                    this.connectedCallback();
                } else {
                    this.handleCloseModal('refreshList');
                }
                
                const event = new ShowToastEvent({
                    title: 'Save Success!',
                    message: 'You have successfully withdrawn your volunteer application.',
                    variant:"success",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            });
        };
    }

    handleVolunteerModifySave = () => {
        if (this.areInputFieldsValid() !== true) {
            return;
        }

        this._transactionSize = this._frontEndData.length;
        if (this._transactionSize === 0) {
            return;
        }

        this._isShowSpinner = true;
        submitForm(this, this.submissionLogic, (error) => {
            console.log(error);
            this._isShowSpinner = false;
        });
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        for (let eachFieldList of this._frontEndData) {
            // convert list of objects to single object (Map<Object, Object>) for backend
            // syntax (x, y) uses the comma operator fyi
            let fieldListObject = eachFieldList.reduce((obj, item) => (obj[item.id] = item.value, obj), {});
            let volunteerApplicationId = fieldListObject.Id;
            let interimId = fieldListObject.interimId;
            delete fieldListObject.interimId;
            delete fieldListObject.Id;

            const params = {pageName: this.pageName, 
                            mainSectionName: this.mainSectionName, 
                            volunteerId: volunteerApplicationId, 
                            interimId: interimId, 
                            volunteerBioInfoMap: fieldListObject,
                            recaptchaToken: recaptchaToken}

            callApexFunction(this, volunteerModifyApplicationSave, params, () => {
                --this._transactionSize;
                if (this._transactionSize === 0) {
                    this.refreshParent();
                    this._isShowSpinner = false;
                    // when on calendar, return to calendar shifts page
                    if (this.isShowListBackButton) {
                        this.handleCloseModal('showCalendarShifts');
                    } else {
                        this.handleCloseModal();
                    }
                    
                    const event = new ShowToastEvent({
                        title: 'Save Success!',
                        message: 'You have successfully saved your volunteer application.',
                        variant:"success",
                        mode:"sticky"
                    });
                    this.dispatchEvent(event);
                }
            }, (error) => {
                console.log(error);
                --this._transactionSize;
                if (this._transactionSize === 0) {
                    this._isShowSpinner = false;
                }
                errorRecaptchaCallback();
            });
        }
    }

    handleBackClickToCalendar() {
        this.handleCloseModal('showCalendarShifts');
    }

    resetData() {
        this._volunteerList = [];
        this._frontEndDataMap = {};
        this._isShowSpinner = false;
        this._frontEndData = [];
        this._displayData = [];
        this._headerList = [];
        this._isFresh = false;
        this._transactionSize = 0;
    }

    areInputFieldsValid() {
        let table = this.template.querySelector('c-portal_-table');
        let valid = true;
        if (table) {
            valid = table.checkValidity();
            if (!valid) {
                table.reportValidity();
            }
        }
        return valid;
    }
}