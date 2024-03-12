import { LightningElement, api, wire, track } from 'lwc';
import SERVER_getPicklists from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getPicklists'
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import SERVER_getPledgeData from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getPledgeData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import isguest from '@salesforce/user/isGuest';
export default class Portal_OnlineGivingType extends LightningElement {
    @api componentLabel;
    @api defaultGiftTypeLabels;
    @api baseButtonColor;
    @api selectedButtonColor;
    @api showOneTime;
    @api showMultiPayment;
    @api showRecurring;
    @api showRecurringEndDate;
    @api showPledgePayment;
    @api pledgePaymentOneTimeGiftLabel;
    @api pledgePaymentLabel;
    @api pledgeIdLabel;
    @api pledgeLabel;
    // api vars can't be default true, but this needs to be true for upgrade backwards compatibility, so add !! before this var in this file
    @api isCreatePledgeSubscription = 'true';
    @api numberOfPaymentsLabel;
    @api pledgeFrequencyLabel;
    @api pledgeStartDateLabel
    @api recurringFrequencyLabel;
    @api recurringStartDateLabel;
    @api recurringEndDateLabel;
    @api minNumberOfPayments;
    @api maxNumberOfPayments;
    @api frequencyOptions;
    @api pageName;
    @api pageSectionName;
    @api textColor;
    @api recurringHelpText;
    @api pledgeHelpText;
    @wire(MessageContext) messageContext;
    @track _pledgePicklistOptions = [];
    @track _pledgeIdInputText = "";
    _giftType = "gift";
    _oneTimeGiftLabel;
    _multiPaymentLabel;
    _recurringGiftLabel;
    _radioButtonOption = 'onetime';
    _pledgeId = "";
    _page = 'giving';
    _subscription = null;
    _pledgeFrequency;
    _numberOfInstallments;
    _pledgeStartDate;
    _recurringFrequency;
    _recurringStartDate;
    _recurringEndDate;
    _pledgePaymentInfoList = [];
    _clearList = true;
    _lookupLabelSet = true;
    _hadPledgeSelected = false;
    _maximumDate = "4000-12-31";
    _isGuestUser = isguest;
    _showSpinner = true;
    

    get pledgePicklist() {
        return this._pledgePicklistOptions;
    }

    get minimumPledgeStartDate() {
        if (!!this.isCreatePledgeSubscription) {
            let tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            return this.formatDate(tomorrow);
        }

        return this.formatDate(new Date());
    }

    get maximumPledgeStartDate() {
        return !!this.isCreatePledgeSubscription ? this._maximumDate : this.formatDate(new Date());
    }

    get isDisablePledgeStartDate() {
        return this.minimumPledgeStartDate === this.maximumPledgeStartDate
    }

    get minimumRecurringStartDate() {
        let tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        return this.formatDate(tomorrow);
    }

    get minimumRecurringEndDate() {
        let startDate = new Date(this._recurringStartDate + 'T00:00:00');
        if (!this._recurringStartDate) {
            startDate = new Date();
            startDate.setDate(startDate.getDate() + 1);
        }

        switch (this._recurringFrequency) {
            case 'Annual':
                startDate.setFullYear(startDate.getFullYear() + 1);
                break;
            case 'Semi-Annual':
                startDate.setMonth(startDate.getMonth() + 6);
                break;
            case 'Quarterly':
                startDate.setMonth(startDate.getMonth() + 3);
                break;
            case 'Monthly':
                startDate.setMonth(startDate.getMonth() + 1);
                break;
            case 'Bi-Weekly':
                startDate.setDate(startDate.getDate() + 14);
                break;
            case 'Weekly':
                startDate.setDate(startDate.getDate() + 7);
                break;
            default:
                // Error case treated as Annual
                startDate.setFullYear(startDate.getFullYear() + 1);
                break;
        }

        return this.formatDate(startDate);
    }

    get isShowRadioButton() {
        return this.showPledgePayment && this._giftType == this._oneTimeGiftLabel;
    }

    get isMultiPayment() {
        return this._giftType == this._multiPaymentLabel;
    }

    get isRecurringGift() {
        return this._giftType == this._recurringGiftLabel;
    }

    get isShowPledgeId() {
        return this.showPledgePayment && this._radioButtonOption == 'pledgepayment';
    }

    get showComponent() {
        return this._page == this.pageName;
    }

    get textColorStyle() {
        if (!this.textColor) {
            return '';
        }

        return 'color: ' + this.textColor;
    }

    get selectedTypeColorStyle() {
        if (!this.selectedButtonColor) {
            return '';
        }

        return 'background-color: ' + this.selectedButtonColor + '; border: 1px solid ' + this.selectedButtonColor;
    }

    get nonSelectedTypeColorStyle() {
        if (!this.baseButtonColor) {
            return '';
        }

        return 'background-color: ' + this.baseButtonColor;
    }

    get recurringGiftContainerClass() {
        return "flex-grid-" + (this.showRecurringEndDate ? '3' : '2');
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
        if (this.defaultGiftTypeLabels) {
            let giftTypeLabelList = this.defaultGiftTypeLabels.split(',');
            this._giftType = giftTypeLabelList[0];
            this._oneTimeGiftLabel = giftTypeLabelList[0];
            this._multiPaymentLabel = giftTypeLabelList[1];
            this._recurringGiftLabel = giftTypeLabelList[2];
        }

        let vars = {};
        let parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });
        if (vars['type']) {
            this._giftType = vars['type'];
        }
        let giftType = 'gift';
        if (this._giftType == this._multiPaymentLabel) {
            giftType = 'pledge';
        } else if (this._giftType == this._recurringGiftLabel) {
            giftType = 'recurring';
        }

        publish(this.messageContext, onlineGivingChannel, {detail:giftType, type:"giftType"});

        const params = {'params':{
            'field': 'ucinn_ascendv2__Frequency__c',
            'sobjectType': 'Opportunity'
        }}
        SERVER_getPicklists(params).then(res => {
            this.frequencyOptions = res.Opportunity.ucinn_ascendv2__Frequency__c;
            if (this.frequencyOptions[0] != null) {
                this._pledgeFrequency = this.frequencyOptions[0].value;
                publish(this.messageContext, onlineGivingChannel, {detail:this._pledgeFrequency, type: 'pledgeFrequency'});
                this._recurringFrequency = this.frequencyOptions[0].value;
                publish(this.messageContext, onlineGivingChannel, {detail:this._recurringFrequency, type: 'recurringFrequency'});
            }
        }).catch(console.error);
        SERVER_getPledgeData({'params': {'pageName': this.pageSectionName}}).then(res => {
            let pledgePicklistOptions = [{'label':'Please select an option', 'value':''}];
            for (let pledgeInfo of res) {
                let pledgeIdentifier = pledgeInfo.pledgeIdentifier;
                let pledgeAmount = '$' + parseFloat(pledgeInfo.totalPledgeAmount).toFixed(2);
                let pledgeDesignationName;
                for (let designationDetail of pledgeInfo.pledgeDesignationList) {
                    if (!pledgeDesignationName) {
                        pledgeDesignationName = designationDetail.Name;
                    } else {
                        pledgeDesignationName = pledgeDesignationName + ', ' + designationDetail.Name;
                    }
                }

                let pledgeLabel = pledgeIdentifier + ' - ' + pledgeDesignationName + ' - ' + pledgeAmount;
                pledgePicklistOptions.push({'label':pledgeLabel, 'value':pledgeIdentifier});

                this.formatPaymentInfo(pledgeInfo);
            }
            this._pledgePaymentInfoList = res;
            this._pledgePicklistOptions = pledgePicklistOptions;
        }).catch(console.error).finally(() => {
            this._showSpinner = false;
        });
    }

    disconnectedCallback() {
        unsubscribe(this._subscription);
        this._subscription = null;
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                onlineGivingChannel,
                (message) => this.handleMessage(message)
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this._page = message.detail['page'];
        }
        if (message.type == 'display-field-errors') {
            this.displayFieldErrors();
        }
    }

    renderedCallback() {
        publish(this.messageContext, onlineGivingChannel, {detail: !!this.isCreatePledgeSubscription, type: 'isCreatePledgeSubscription'});
        this.setColor();
        this.setRadioButton();
    }

    handleGiftTypeClick(event) {
        let prevGiftType = this._giftType;
        this._giftType = event.currentTarget.getAttribute('data-gifttype');

        if (prevGiftType == this._giftType) {
            // if user clicks tab that is already active, nothing happens
            return;
        }

        let giftType = 'gift';
        if (this._giftType == this._multiPaymentLabel) {
            giftType = 'pledge';
            if (this.isDisablePledgeStartDate) {
                // timeout needed to delay validity check until the <input> appears
                setTimeout(() => {this.setValue('pledgeStartDate', this.minimumPledgeStartDate, undefined);});
            }
        } else if (this._giftType == this._recurringGiftLabel) {
            giftType = 'recurring';
        }
        publish(this.messageContext, onlineGivingChannel, {detail:giftType, type:"giftType"});
        this.setColor();

        if (giftType != 'gift') {
            this._pledgeId = ''; //clear out pledge lookup
            this.clearGuestUserInput();
            publish(this.messageContext, onlineGivingChannel, {detail: false, type: "isPledgePayment"});
        } else {
            this._radioButtonOption = 'onetime';
            this.setRadioButton();
        }

        if(this._hadPledgeSelected && giftType != 'gift') {
            //had a pledge Id selected and tabbed away
            this.clearPledgeDesignations(); // sets this._hadPledgeSelected to false
            this.resetPledgeAmount();
            publish(this.messageContext, onlineGivingChannel, {detail: this._hadPledgeSelected, type: "isValidPledge"});
        }
    }

    setColor = (hoveredGiftType) => {
        if (this.template.querySelectorAll('.entry-form .grid-item label') && this.template.querySelectorAll('.entry-form .grid-item label').length > 0) {
            this.template.querySelectorAll('.entry-form .grid-item label').forEach(element => {
                let gifttype = element.getAttribute('data-gifttype');
                if (gifttype == this._giftType || gifttype == hoveredGiftType) {
                    element.querySelector('span').style = this.selectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.baseButtonColor 
                } else {
                    element.querySelector('span').style = this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.selectedButtonColor 
                }
            });
            return true;
        }

        return false;

    }

    handleRadioButtonSelection(event) {
        if (event.currentTarget.checked == true) {
            this._radioButtonOption = event.currentTarget.value;
            this._pledgeId = ''; //clear out pledge lookup
            this.clearGuestUserInput();

            if (this._hadPledgeSelected) {
                this.clearPledgeDesignations(); // sets this._hadPledgeSelected to false
                this.resetPledgeAmount();

                publish(this.messageContext, onlineGivingChannel, {detail: this._hadPledgeSelected, type: "isValidPledge"});
            }
        }
        this.setRadioButton();
        publish(this.messageContext, onlineGivingChannel, {detail: this.isShowPledgeId, type: "isPledgePayment"});
    }

    setRadioButton() {
        if (this.template.querySelectorAll('[data-inputtype="radio"]') && this.template.querySelectorAll('[data-inputtype="radio"]').length > 0) {
            this.template.querySelectorAll('[data-inputtype="radio"]').forEach(element => {
                if (element.value != this._radioButtonOption) {
                    element.checked = false;
                } else {
                    element.checked = true;
                }
            });
        }
    }

    clearGuestUserInput() {
        if (this._isGuestUser) {
            this._pledgeIdInputText = '';
            return;
        }
    }

    handleChange = (event) => {
        let dataId = event.currentTarget.getAttribute('data-id');

        if (!dataId) {
            dataId = event.currentTarget.name
        }

        this.setValue(dataId, event.currentTarget.value, event);
    }

    // event may be undefined
    setValue = (dataId, newValue, event) => {
        if (dataId == 'pledgeFrequency') {
            this._pledgeFrequency = newValue;
        } else if (dataId == 'pledgeStartDate') {
            this._pledgeStartDate = newValue;
            publish(this.messageContext, onlineGivingChannel, {detail: this.isPledgeStartDateValid(), type: 'isPledgeStartDateValid'});
        } else if (dataId == 'installments') {
            this._numberOfInstallments = newValue;

            publish(this.messageContext, onlineGivingChannel, {detail: this.isNumberOfInstallmentsValid(this._numberOfInstallments), type:"isInstallmentsValid"});
        } else if (dataId == 'recurringFrequency') {
            this._recurringFrequency = newValue;
            // wait to calculate validity until after end date max can update on HTML
            setTimeout(() => publish(this.messageContext, onlineGivingChannel, {detail: this.isRecurringDatesValid(), type: 'isRecurringDatesValid'}));
        } else if (dataId == 'recurringStartDate') {
            this._recurringStartDate = newValue;
            setTimeout(() => publish(this.messageContext, onlineGivingChannel, {detail: this.isRecurringDatesValid(), type: 'isRecurringDatesValid'}));
        } else if (dataId == 'recurringEndDate') {
            this._recurringEndDate = newValue;
            publish(this.messageContext, onlineGivingChannel, {detail: this.isRecurringDatesValid(), type: 'isRecurringDatesValid'});
        }

        event?.target.reportValidity();
        publish(this.messageContext, onlineGivingChannel, {detail:newValue, type: dataId});
    }

    clearPledgeDesignations() {
        this._hadPledgeSelected = false;
        publish(this.messageContext, onlineGivingChannel, {detail:'', type: 'pledgeId'});
        publish(this.messageContext, onlineGivingChannel, {detail : [], type:"designation"});
    }

    resetPledgeAmount() {
        publish(this.messageContext, onlineGivingChannel, {detail: 'true', type: "resetSelectedAmount"});
    }

    // handleLookupChange = (value) => {
    //     if (this._lookupLabelSet) {
    //         this._clearList = true;
    //         this._lookupLabelSet = false;
    //     } else {
    //         this._clearList = false;
    //     }
    //     if (this._hadPledgeSelected && this._pledgeId != value) {
    //         this.clearPledgeDesignations();
    //     }

    //     this._pledgeId = value;
       
    // }

    // handleLookup = (option) => {
    //     if (option && option.value) {
    //         this._pledgeId = option.value;
    //         this._hadPledgeSelected = true;

    //         publish(this.messageContext, onlineGivingChannel, {detail:this._pledgeId, type: 'pledgeId'});
    //         publish(this.messageContext, onlineGivingChannel, {detail : this._pledgeDesignationMap[this._pledgeId], type:"designation"});
    //     }
    //     this._clearList = true;
    //     this._lookupLabelSet = true;
    // }

    handleInputTextChange = (event) => {
        this._pledgeIdInputText = event.target.value;
    }

    handleValidatePledge = () => {
        SERVER_getPledgeData({params:{'pledgeId': this._pledgeIdInputText}}).then(result => {
            let pledgeInfo = result[0];
            if (pledgeInfo) {
                this.showNotification('Pledge found successfully', '', 'success');
                this._pledgeId = pledgeInfo.pledgeIdentifier;
                this._hadPledgeSelected = true;
                this.formatPaymentInfo(pledgeInfo);

                publish(this.messageContext, onlineGivingChannel, {detail: this._pledgeId, type: 'pledgeId'});
                publish(this.messageContext, onlineGivingChannel, {detail: pledgeInfo.pledgeDesignationList, type: "designation"});
                publish(this.messageContext, onlineGivingChannel, {detail: pledgeInfo.totalDueAmount, type: "amount"});
                publish(this.messageContext, onlineGivingChannel, {detail: pledgeInfo, type: 'pledgePaymentInfo'});
            } else {
                this.showNotification('Pledge not found.', 'Please enter a valid Pledge Id or select a different payment option.', 'error');
                if (this._hadPledgeSelected) {
                    this._pledgeId = '';
                    this.clearPledgeDesignations(); // sets this._hadPledgeSelected to false
                    this.resetPledgeAmount();
                }
            }

            publish(this.messageContext, onlineGivingChannel, {detail: this._hadPledgeSelected, type: "isValidPledge"});
        }).catch(console.error);
    }

    formatPaymentInfo(pledgeInfo) {
        pledgeInfo.pastDueAmount = parseFloat(pledgeInfo.pastDueAmount).toFixed(2);
        pledgeInfo.currentDueAmount = parseFloat(pledgeInfo.currentDueAmount).toFixed(2);
        pledgeInfo.totalDueAmount = parseFloat(pledgeInfo.totalDueAmount).toFixed(2);
        pledgeInfo.totalPledgeAmount = parseFloat(pledgeInfo.totalPledgeAmount).toFixed(2);
        pledgeInfo.amountPaidToDate = parseFloat(pledgeInfo.amountPaidToDate).toFixed(2);
    }

    handlePledgePicklistChange = (event) => {
        this._pledgeId = event.target.value;
        if (this._pledgeId) {
            this._hadPledgeSelected = true;
            let pledge = this.getSelectedPledgeInfo();

            publish(this.messageContext, onlineGivingChannel, {detail: this._pledgeId, type: 'pledgeId'});
            publish(this.messageContext, onlineGivingChannel, {detail: pledge.pledgeDesignationList, type: "designation"});
            publish(this.messageContext, onlineGivingChannel, {detail: pledge.totalDueAmount, type: "amount"});
            publish(this.messageContext, onlineGivingChannel, {detail: pledge, type: "pledgePaymentInfo"});
        } else {
            this.clearPledgeDesignations(); // sets this._hadPledgeSelected to false
            this.resetPledgeAmount();
        }

        publish(this.messageContext, onlineGivingChannel, {detail: this._hadPledgeSelected, type: "isValidPledge"});
    }

    getSelectedPledgeInfo() {
        for (let pledge of this._pledgePaymentInfoList) {
            if (this._pledgeId == pledge.pledgeIdentifier) {
                return pledge;
            }
        }
    }

    displayFieldErrors() {
        if (this.template.querySelectorAll('input') && this.template.querySelectorAll('input').length > 0) {
            let elements = this.template.querySelectorAll('input');
            for (let index = 0; index < elements.length; index++) {
                elements[index].reportValidity();
                return;
            }
        }
    }

    handleGiftTypeEnter(hoveredGiftType) {
        this.setColor(hoveredGiftType.target.dataset.gifttype);
    }

    handleGiftTypeLeave() {
        this.setColor();
    }

    isNumberOfInstallmentsValid(numberOfInstallments) {
        if (!numberOfInstallments) {
            return false;;
        }

        if (this.minNumberOfPayments && numberOfInstallments < this.minNumberOfPayments) {
            return false;
        }

        if (this.maxNumberOfPayments && numberOfInstallments > this.maxNumberOfPayments) {
            return false;
        }

        return true;
    }

    isPledgeStartDateValid() {
        let startDateInput = this.template.querySelector('input[data-id="pledgeStartDate"]');
        if (!startDateInput || !startDateInput.reportValidity()) {
            return false;
        }

        return true;
    }

    isRecurringDatesValid() {
        let startDateInput = this.template.querySelector('input[data-id="recurringStartDate"]');
        let endDateInput = this.template.querySelector('input[data-id="recurringEndDate"]');

        if (!startDateInput || !startDateInput.reportValidity()) {
            return false;
        }
        
        if (endDateInput && !endDateInput.reportValidity()) {
            return false;
        }

        return true;
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'sticky'
        });

        this.dispatchEvent(evt);
    }

    // given Date object, return yyyy-mm-dd
    formatDate(date) {
        let year = date.getFullYear().toString();
        let month = (date.getMonth() + 1).toString().padStart(2, '0');
        let dayOfMonth = date.getDate().toString().padStart(2, '0');
        
        return `${year}-${month}-${dayOfMonth}`;
    }
}