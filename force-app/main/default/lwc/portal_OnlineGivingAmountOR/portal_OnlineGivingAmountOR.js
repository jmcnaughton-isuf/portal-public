import { LightningElement, api, track, wire } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingAmountOR extends LightningElement {

    @api componentLabel;
    @api defaultGivingAmounts;
    @api selectedButtonColor;
    @api baseButtonColor;
    @api pageName;
    @api textColor;
    @api maxAmount;

    @wire(MessageContext) messageContext;
    _defaultGivingAmountList = [];
    _defaultSelectedAmount = 0;
    _amount = 0;
    @track amountToDisplay = '';
    _colorSet = false;
    _size = 4;
    _subscription = null;
    _page = 'giving';
    _isPledgePayment = false;
    _isValidPledge = false;
    @track _showOther = false;
    @track showAmountSelected = true;
    @track firstTimeFund = true;

    @api handleAmountShow () {
        this._showOther = false;
        if (!this.firstTimeFund) {
            this._amount = 0;
            this.amountToDisplay = 0;
            //this._showOther = false;
            this.setMultiColor(this._amount);
        } else {
            this.amountToDisplay = '';
        }
    }
    get amount() {
        return this._amount;
    }

    get headerStyle() {
        return 'margin-bottom: .5em; color:' + this.textColor + ';';
    }

    get selectedTypeColorStyle() {
        if (!this.selectedButtonColor) {
            return '';
        }

        return 'background-color: ' + this.selectedButtonColor;// + '; border: 1px solid ' + this.selectedButtonColor;
    }

    get nonSelectedTypeColorStyle() {
        if (!this.baseButtonColor) {
            return '';
        }

        return 'background-color: ' + this.baseButtonColor + '; border: none; ';// + this.selectedButtonColor;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
        if (this.defaultGivingAmounts) {
            for (let amount of this.defaultGivingAmounts.split(',')) {
                this._defaultGivingAmountList.push({"amount":  parseFloat(amount).toFixed(2), "label":"$" + amount});
            }
            //this._amount = parseFloat(this.defaultGivingAmounts.split(',')[0]).toFixed(2);
            this._amount = this._defaultSelectedAmount;
            this._size = Math.floor(12/(this.defaultGivingAmounts.split(',').length + 2));
        }
        var vars = {};

        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });
        if (vars['amt'] && parseFloat(vars['amt']).toFixed(2) > 0) {
            this._amount = parseFloat(vars['amt']).toFixed(2);
            let otherAmount = true;
            if (this.defaultGivingAmounts) {
                for (let amount of this.defaultGivingAmounts.split(',')) {
                    if (parseFloat(amount).toFixed(2) == this._amount) {
                        otherAmount = false;
                    }
                }
            }
            this._showOther = otherAmount;
        }
        publish(this.messageContext, onlineGivingChannel, {detail: this._amount, type:"amount"});
    }

    disconnectedCallback() {
        unsubscribe(this._subscription);
        this._subscription = null;
    }
    

    renderedCallback() {
        this.setMultiColor();
        console.log('re-render',this._amount);
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                onlineGivingChannel,
                (message) => this.handleMessage(message),
            );
        }
    }

    handleAmountClick(event) {
        let amount = event.currentTarget.getAttribute('data-amount');
        console.log('Amount OR::: '+amount);
        if (amount == 'Other') {
            this._showOther = true;
        } else {
            this._amount = event.currentTarget.getAttribute('data-amount');
            //this.amountToDisplay = this._amount;
            try {
                const selectedEvent = new CustomEvent("amountchanged", {
                    detail: amount
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
                publish(this.messageContext, onlineGivingChannel, {detail: this._amount, type:"amount"});
            } catch (error) {
                console.log(error);
            }
            this._showOther = false;
        }
        this.setMultiColor(amount);
        //this.setColor(this.amountToDisplay);
        //this.checkValidation();
    }

    setMultiColor = (hoveredAmount) => {
        console.log('Color Multi Set:: '+hoveredAmount);
        if (this.template.querySelectorAll('.grid-item label') && this.template.querySelectorAll('.grid-item label').length > 0) {
            this.template.querySelectorAll('.grid-item label').forEach(element => {
                // First Time It should default to plain color
                let buttonAmount = element.getAttribute('data-amount');
                console.log('FC Limit ',buttonAmount+' THis.amount',this._amount, ' amountToDisplay: ',this.amountToDisplay,' Other',this._showOther);
                if(this.firstTimeFund && ((buttonAmount == this._amount && !this._showOther) || (this._showOther && buttonAmount == 'Other'))) {
                    console.log('FC',buttonAmount);
                    element.querySelector('span').style = 'background-color: #C8102E;';//this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: #FFF !important;';// + this.baseButtonColor;
                } else if(!this.firstTimeFund && ((buttonAmount == hoveredAmount && !this._showOther) || (this._showOther && buttonAmount == 'Other' && this._amount == hoveredAmount && this.amountToDisplay > 0))) {
                    element.querySelector('span').style = 'background-color: #C8102E;';//this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: #FFF !important;';// + this.baseButtonColor;
                    console.log('FC 2');
                }
                else {
                    element.querySelector('span').style = this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.selectedButtonColor;
                    console.log('FC 3',buttonAmount);
                }
                /*if ((buttonAmount == hoveredAmount && !this._showOther) ||  (this._showOther && buttonAmount == 'Other') || (hoveredAmount && buttonAmount == hoveredAmount) || (this.firstTimeFund && this._amount == buttonAmount)) {
                    element.querySelector('span').style = 'background-color: #C8102E;';//this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: #FFF !important;';// + this.baseButtonColor;
                }  else {
                    element.querySelector('span').style = this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.selectedButtonColor;
                }*/
            });
            return true;
        }
        return false;
    }

    setColor = (hoveredAmount) => {
        console.log('Color Set:: '+hoveredAmount);
        if (this.template.querySelectorAll('.grid-item label') && this.template.querySelectorAll('.grid-item label').length > 0) {
            this.template.querySelectorAll('.grid-item label').forEach(element => {
                let buttonAmount = element.getAttribute('data-amount');
                if ((buttonAmount == hoveredAmount && buttonAmount == this._amount && !this._showOther) ||  (this._showOther && buttonAmount == 'Other') || (hoveredAmount && buttonAmount == hoveredAmount)) {
                    element.querySelector('span').style = 'background-color: #C8102E;';//this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: #FFF !important;';// + this.baseButtonColor;
                }  else {
                    element.querySelector('span').style = this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.selectedButtonColor;
                }
            });
            return true;
        }
        //element.querySelector('span').style = this.nonSelectedTypeColorStyle;//'background-color: rgb(200, 16, 46); border: 1px solid rgb(200, 16, 46);';
        //element.querySelector('span a').style = '';//'color: ' + this.selectedButtonColor + '; background-color: ' + this.selectedButtonColor;
        return false;
    }

    updateGivingAmount(event) {
        if (this.checkValidation()) {
            this._amount = event.currentTarget.value;
            //this.amountToDisplay = this._amount;
            if (this._defaultGivingAmountList.length > 0) {
                let showOther = true;
                this._defaultGivingAmountList.forEach(amount => {
                    if (amount.amount == this._amount) {
                        showOther = false;
                    }
                });
                this._showOther = showOther;
            }
            this.setMultiColor(this._amount);

            publish(this.messageContext, onlineGivingChannel, {detail: this._amount, type:"amount"});
        }
    }

    onChangeAmount(event) {
        //console.log('Amount Changed:  Earlier Amount: '+this._amount +' IF Other:: '+this._showOther);
        let amount = event.currentTarget.value;
        publish(this.messageContext, onlineGivingChannel, {detail: amount, type:"amount"});
        if (this._defaultGivingAmountList.length > 0) {
            let showOther = true;
            this._defaultGivingAmountList.forEach(amount => {
                if (amount.amount == amount) {
                    showOther = false;
                }
            });
            this._showOther = showOther;
        }
        //console.log('Amount From Data-amount:: '+amount + 'target value:: '+event.currentTarget.value);
        try {
            //console.log('event Show Other Amount Publish');
            const selectedEvent = new CustomEvent("amountchanged", {
                detail: amount
            });
            this.dispatchEvent(selectedEvent);
            publish(this.messageContext, onlineGivingChannel, {detail: this._amount, type:"amount"});
        } catch (error) {
            console.log(error);
        }
        this.checkValidation();
        this.displayFieldErrors();
        this.setMultiColor(amount);
    }

    checkValidation() {
        let valid = true;
        if (this.template.querySelectorAll('input') && this.template.querySelectorAll('input').length > 0) {
            let elements = this.template.querySelectorAll('input');
            for (let index = 0; index < elements.length; index++) {
                elements[index].reportValidity();
                valid = valid && elements[index].checkValidity()
            }
        }


        /*if (this.maxAmount && this._amount > this.maxAmount) {
           // console.log('Else :: ',this.maxAmount +' amount: ', this._amount);
            valid = false;
        }*/
        //console.log('Amount Validity Amount::: '+valid);
        publish(this.messageContext, onlineGivingChannel, {detail: valid, type:"amountValidity"});
        return valid;
    }

    handleMessage (message) {
        if (message.type == 'data-change') {
            this.firstTimeFund = message.detail['firstTimeFund'];
            if (message.detail['amount'] && this._amount != message.detail['amount']) {
               // this.changeAmount(message.detail['amount']);
            }
            this._page = message.detail['page'];
            this._isPledgePayment = message.detail['isPledgePayment'];
            this._isValidPledge = message.detail['isValidPledge'];
        }
        /*if (message.type == 'data-change') {
            let isChange = message.detail['firstTimeFund'];
            this.firstTimeFund = message.detail['firstTimeFund'];
            if(isChange) {
                this.showAmountSelected = false;
            }

            if (this._amount != message.detail['amount'] && message.detail['amount']) {
                this._amount = parseFloat(message.detail['amount']).toFixed(2);
                if (this._defaultGivingAmountList.length > 0) {
                    let showOther = true;
                    this._defaultGivingAmountList.forEach(amount => {
                        if (amount.amount == this._amount) {
                            showOther = false;
                        }
                    });
                    this._showOther = showOther;
                    //console.log('SHow Others in handle messages:: '+this._showOther)
                }
                this.checkValidation();
                this.displayFieldErrors();
                publish(this.messageContext, onlineGivingChannel, {detail:this._amount, type:"amount"});
                this.setColor();
            }
            this._page = message.detail['page'];
        }*/

        if (message.type == 'reset-amount') {
            publish(this.messageContext, onlineGivingChannel, {detail:this._defaultSelectedAmount, type:"amount"});
            this.changeAmount(this._defaultSelectedAmount);
        }

        if (message.type == 'display-field-errors') {
            this.displayFieldErrors();
        }

    }

    changeAmount(newAmount) {
        this._amount = parseFloat(newAmount).toFixed(2);
        if (this._defaultGivingAmountList.length > 0) {
            let showOther = true;
            this._defaultGivingAmountList.forEach(amount => {
                if (amount.amount == this._amount) {
                    showOther = false;
                }
            });
            this._showOther = showOther;
        }
        this.checkValidation();
        this.displayFieldErrors();
        publish(this.messageContext, onlineGivingChannel, {detail:this._amount, type:"amount"});
        //this.setColor();
    }

    get isShowComponent() {
        return this._page == this.pageName;
    }

    displayFieldErrors() {
        if (this.template.querySelectorAll('input') && this.template.querySelectorAll('input').length > 0) {
            let elements = this.template.querySelectorAll('input');
            for (let index = 0; index < elements.length; index++) {
                elements[index].reportValidity();
            }
        }
    }

    handleAmountEnter(hoveredAmount) {
        //this.setColor(hoveredAmount.target.dataset.amount);
    }

    handleAmountLeave() {
        //this.setColor();
    } 
}