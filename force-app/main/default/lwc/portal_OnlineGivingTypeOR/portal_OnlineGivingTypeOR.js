import { LightningElement, api, wire, track } from 'lwc';
import SERVER_getPicklists from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getPicklists'
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import SERVER_getPledgeData from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getPledgeData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import isguest from '@salesforce/user/isGuest';
export default class Portal_OnlineGivingTypeOR extends LightningElement {
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
    @api numberOfPaymentsLabel;
    @api pledgeFrequencyLabel;
    @api pledgeStartDateLabel
    @api recurringFrequencyLabel;
    @api recurringStartDateLabel;
    @api recurringEndDateLabel;
    @api minNumberOfPayments;
    @api maxNumberOfPayments;
    @api defaultMaxNumberOfPayments = "[{\"label\": \"annual\", \"value\": \"24\"},{\"label\": \"monthly\", \"value\": \"60\"}]";
    @api frequencyOptions;
    @api pageName;
    @api textColor;
    @track _maxNumberOfPayments;
    @track _frequency;
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
    @track _numberOfInstallments;
    _pledgeStartDate;
    _recurringFrequency;
    _recurringStartDate;
    _pledgeIdList = [];
    _pledgeDesignationMap = {};
    _recurringEndDate;
    _pledgePaymentInfoList = [];
    _clearList = true;
    _lookupLabelSet = true;
    _hadPledgeSelected = false;
    _minimumStartDate;
    _minimumEndDate;
    _isGuestUser = isguest;
    _defaultMaxInstallmentsList = [];


    get pledgePicklist() {
        return this._pledgePicklistOptions;
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
        this._maxNumberOfPayments = this.maxNumberOfPayments;
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

        let tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        this._minimumStartDate = tomorrow.toISOString().split('T')[0];

        // ensure minimum end date is strictly after minimum start date
        let dayAfterTomorrow = new Date();
        dayAfterTomorrow.setDate(dayAfterTomorrow.getDate() + 2);
        this._minimumEndDate = dayAfterTomorrow.toISOString().split('T')[0];

        // default start date
        let todaysDate = new Date();

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
                this._pledgeStartDate =  todaysDate.toISOString().split('T')[0];
                publish(this.messageContext, onlineGivingChannel, {detail:this._pledgeStartDate, type: 'pledgeStartDate'});
                //console.log('this.frequencyOptions:: ',this.frequencyOptions);
                this.frequencyOptions = [{'label':'Annual', 'value':'Annual'},{'label':'Semi-Annual', 'value':'Semi-Annual'},{'label':'Quarterly', 'value':'Quarterly'},{'label':'Monthly', 'value':'Monthly'}];
            }
        }).catch(console.error);
        SERVER_getPledgeData({}).then(res => {
            let pledgePicklistOptions = [{'label':'Please select an option', 'value':''}];
            for (let pledgeInfo of res) {
                let pledgeExternalSystemId = pledgeInfo.externalSystemId;
                let pledgeAmount = '$' + parseFloat(pledgeInfo.totalPledgeAmount).toFixed(2);
                let pledgeDesignationName;
                for (let designationDetail of pledgeInfo.pledgeDesignationList) {
                    if (!pledgeDesignationName) {
                        pledgeDesignationName = designationDetail.Name;
                    } else {
                        pledgeDesignationName = pledgeDesignationName + ', ' + designationDetail.Name;
                    }
                }

                let pledgeLabel = pledgeExternalSystemId + ' - ' + pledgeDesignationName + ' - ' + pledgeAmount;
                pledgePicklistOptions.push({'label':pledgeLabel, 'value':pledgeExternalSystemId});

                this.formatPaymentInfo(pledgeInfo);
            }
            this._pledgePaymentInfoList = res;
            this._pledgePicklistOptions = pledgePicklistOptions;
            let giftType = 'gift';
            if (this._giftType == this._multiPaymentLabel) {
                giftType = 'pledge';
            } else if (this._giftType == this._recurringGiftLabel) {
                giftType = 'recurring';
            }
            publish(this.messageContext, onlineGivingChannel, {detail:giftType, type:"giftType"});
        }).catch(console.error);
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
        //console.log('SetColor:: '+hoveredGiftType);
        if (this.template.querySelectorAll('.entry-form .grid-item label') && this.template.querySelectorAll('.entry-form .grid-item label').length > 0) {
            this.template.querySelectorAll('.entry-form .grid-item label').forEach(element => {

                let gifttype = element.getAttribute('data-gifttype');
                //console.log('Set Color Type: '+gifttype +' this.Type: '+this._giftType);
                if (gifttype == this._giftType) {
                    element.querySelector('span').style = this.selectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: #FFF !important;';
                }
                else if (gifttype == hoveredGiftType) {
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
       // console.log('Radio Button Color'+this.template.querySelectorAll('[data-inputtype="radio"]'));
        if (this.template.querySelectorAll('[data-inputtype="radio"]') && this.template.querySelectorAll('[data-inputtype="radio"]').length > 0) {
            this.template.querySelectorAll('[data-inputtype="radio"]').forEach(element => {
                //console.log('Radio Button Inside:: '+element.value + 'checked: '+element.checked);
                //console.log('Radio Button raBtn:: '+this._radioButtonOption);
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
        let currentNumber;
        if (!dataId) {
            dataId = event.currentTarget.name
        }
        console.log('Frequency Input: '+dataId);
        if (dataId == 'pledgeFrequency') {
            this._pledgeFrequency = event.currentTarget.value;
            if(this._pledgeFrequency === 'Annual') {
                this.maxNumberOfPayments = 5;
            } else if (this._pledgeFrequency === 'Semi-Annual'){
                this.maxNumberOfPayments = 10;
            }else if(this._pledgeFrequency === 'Quarterly'){
                this.maxNumberOfPayments = 20;
            }else if(this._pledgeFrequency === 'Monthly'){
                this.maxNumberOfPayments = 60;
            }
            this._numberOfInstallments = null;
        } else if (dataId == 'pledgeStartDate') {
            this._pledgeStartDate = event.currentTarget.value;
        } else if (dataId == 'installments') {
            this._numberOfInstallments = event.currentTarget.value;
            currentNumber = event.currentTarget.value;
            console.log('Installment Input: '+this._numberOfInstallments);
            if(this._pledgeFrequency === 'Annual' && this._numberOfInstallments >= 5){
                this.maxNumberOfPayments = 5;
            }else if(this._pledgeFrequency === 'Semi-Annual' && this._numberOfInstallments >= 10){
                this.maxNumberOfPayments = 10;
            }else if(this._pledgeFrequency === 'Quarterly' && this._numberOfInstallments >= 20){
                this.maxNumberOfPayments = 20;
            }else if(this._pledgeFrequency === 'Monthly' && this._numberOfInstallments >= 60){
                this.maxNumberOfPayments = 60;
            }
            //console.log('this.maxNumberOfPayments '+this._numberOfInstallments +' > '+this.maxNumberOfPayments);
            publish(this.messageContext, onlineGivingChannel, {detail: this.isNumberOfInstallmentsValid(this._numberOfInstallments), type:"isInstallmentsValid"});
            /*if(this._numberOfInstallments > this.maxNumberOfPayments) {
                console.log('Error Validitiy before refresh:: ');
                if (this.template.querySelector('[data-id="installments"]')) {
                    this.template.querySelector('[data-id="installments"]').setCustomValidity( 'Frequency ' + this._pledgeFrequency +': must be less than ' +this.maxNumberOfPayments+' Installments' + ' This: '+this._numberOfInstallments + 'Custom:'+currentNumber);
                    this.template.querySelector('[data-id="installments"]').reportValidity();
                }
            }*/
        } else if (dataId == 'recurringFrequency') {
            this._recurringFrequency = event.currentTarget.value;
        } else if (dataId == 'recurringStartDate') {
            this._recurringStartDate = event.currentTarget.value;
        } else if (dataId == 'recurringEndDate') {
            this._recurringEndDate = event.currentTarget.value;

        }
        event.target.reportValidity();
        publish(this.messageContext, onlineGivingChannel, {detail:event.currentTarget.value, type: dataId});
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
                this._pledgeId = pledgeInfo.externalSystemId;
                this._hadPledgeSelected = true;
                this.formatPaymentInfo(pledgeInfo);

                // console.log('validate pledge -> designationList: '+JSON.stringify(pledgeInfo.pledgeDesignationList));

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
            if (this._pledgeId == pledge.externalSystemId) {
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
            return false;
        }

        if (this.minNumberOfPayments && numberOfInstallments < this.minNumberOfPayments) {
            return false;
        }

        if (this.maxNumberOfPayments && numberOfInstallments > this.maxNumberOfPayments) {
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
}