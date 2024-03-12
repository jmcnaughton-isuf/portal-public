import { LightningElement, api, track } from 'lwc';
import SERVER_getContactInfo from '@salesforce/apex/PORTAL_LWC_DirectoryProfileController.SERVER_getContactInfo'
import directoryProfileHeaderUrl from '@salesforce/resourceUrl/PORTAL_DirectoryProfileHeader';
export default class Portal_DirectoryProfileWrapper extends LightningElement {
    @api notReceivingMessageHelperText = 'This constituent is not receiving messages';
    @api notSendingMessageHelperText = 'You are not receiving messages';
    @api noSelfMessagingHelperText = 'You cannot send messages to yourself';

    @track _callbackDone = false;

    @track informationMap;
    @track _informationMap;
    @track _openModal = false;
    @track _contactId = '';
    @track _name;
    @track _directoryProfileHeader = directoryProfileHeaderUrl;

    get imageStyle() {
        return "display: inline; margin: 0 auto; height: 100%; width: auto; position: static; top: auto; left: auto; min-width: 0; opacity: 1;"
    }

    get isSendMessageButtonDisabled() {
        return this._sendMessageButtonState !== 'receiving';
    }

    get sendMessageButtonClass() {

        if (this.isSendMessageButtonDisabled) {
            return 'button tertiary light disabled';
        }

        return 'button tertiary light'
    }

    get sendMessageText() {
        if (this._sendMessageButtonState === 'currentUserNotReceiving') {
            return this.notSendingMessageHelperText;
        } else if (this._sendMessageButtonState === 'notReceiving') {
            return this.notReceivingMessageHelperText;
        } else if (this._sendMessageButtonState === 'noSelfMessaging') {
            return this.noSelfMessagingHelperText;
        }

        return '';
    }

    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        let recordId = urlParams.get('recordId');

        this._contactId = recordId;

        SERVER_getContactInfo({params: {contactId: recordId}}).then(res => {
            this.informationMap = JSON.parse(JSON.stringify(res));
            this._informationMap = Object.assign({}, this.informationMap);

            this._name = this.getRecordValue('firstName') + ' ' + this.getRecordValue('lastName')
            this._sendMessageButtonState = res.sendMessageButtonState;

            this._callbackDone = true;
        }).catch(e => {
            console.log(e);
        });

    }

    getRecordValue (field)  {
        let mainSection = this.informationMap.frontEndData[field].mainSection;
        let subSection = this.informationMap.frontEndData[field].subSection;
        let fieldName = this.informationMap.frontEndData[field].fieldName;
        let filterValue = this.informationMap.frontEndData[field].filterValue;
        let filterField = this.informationMap.frontEndData[field].filterField;
        let isPicklist = this.informationMap.frontEndData[field].isPicklist;
        let stagingRecordFieldName = this.informationMap.frontEndData[field].stagingRecordFieldName;
        if (!subSection) {
            subSection = 'records';
        }

        try {
            if (!isPicklist) {
                if (stagingRecordFieldName == 'ucinn_ascendv2__Significant_Other_First_Name__c' || stagingRecordFieldName == 'ucinn_ascendv2__Significant_Other_Last_Name__c') {
                    if (this._spousalInterim && this._spousalInterim[stagingRecordFieldName]) {
                        if (this._spousalInterim[stagingRecordFieldName] == 'isDeleted') {
                            return '';
                        }
                        return this._spousalInterim[stagingRecordFieldName];
                    }
                } else {
                    if (this._interim && this._interim[stagingRecordFieldName]) {
                        if (this._interim[stagingRecordFieldName] == 'isDeleted') {
                            return '';
                        }
                        return this._interim[stagingRecordFieldName];
                    }

                }

                if (filterValue) {
                    for (let record of this.informationMap['records'][mainSection][subSection]) {
                        if (record[filterField] == filterValue) {
                            if (fieldName.includes('.')) {
                                let fields = fieldName.split('.');
                                return record[fields[0]][fields[1]]
                            }
                            return record[fieldName];
                        }
                    }
                } else {
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        return this.informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]
                    }
                    return this.informationMap['records'][mainSection][subSection][0][fieldName];
                }


            } else {
                for (let picklistValue of this.informationMap.picklists[field]) {
                    if (this._interim  && this._interim[stagingRecordFieldName]) {
                        if (picklistValue.value == this._interim[stagingRecordFieldName]) {
                            return picklistValue.label;
                        }
                    } else {

                        if (filterValue) {
                            for (let record of this.informationMap['records'][mainSection][subSection]) {
                                if (record[filterField] == filterValue) {
                                    if (fieldName.includes('.')) {
                                        let fields = fieldName.split('.');
                                        if (picklistValue.value == record[fields[0]][fields[1]]) {
                                            return picklistValue.label;
                                        }
                                    }
                                    if (picklistValue.value == record[fieldName]) {
                                        return picklistValue.label;
                                    }
                                }
                            }
                        } else {
                            if (fieldName.includes('.')) {
                                let fields = fieldName.split('.');
                                if (picklistValue.value ==  this.informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]) {
                                    return picklistValue.label;
                                }
                            }
                            if (picklistValue.value == this.informationMap['records'][mainSection][subSection][0][fieldName]) {
                                return picklistValue.label;
                            }
                        }
                    }

                }
           }
        } catch (e) {
            console.log(e);
        }
        return "";
    }

    handleMessageClick() {
        this._openModal = true;
    }

    closeModal = () => {
        this._openModal = false;
    }
}