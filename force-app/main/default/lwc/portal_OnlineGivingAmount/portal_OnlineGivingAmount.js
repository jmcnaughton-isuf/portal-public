import { LightningElement, api, track, wire } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingAmount extends LightningElement {

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
    _colorSet = false;
    _size = 4;
    _subscription = null;
    _page = 'giving';
    _isPledgePayment = false;
    _isValidPledge = false;
    @track _showOther = false;

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

        return 'background-color: ' + this.selectedButtonColor + '; border: 1px solid ' + this.selectedButtonColor;
    }

    get nonSelectedTypeColorStyle() {
        if (!this.baseButtonColor) {
            return '';
        }

        return 'background-color: ' + this.baseButtonColor + '; border: 1px solid #eeeeee';
    }

    get flexgridClass() {
        if (!this._defaultGivingAmountList || this._defaultGivingAmountList.length === 0) {
            return 'flex-grid';
        }

        if (this._defaultGivingAmountList.length >= 4) {
            return 'flex-grid-5';
        }

        return 'flex-grid-' + (this._defaultGivingAmountList.length + 1);
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
        if (this.defaultGivingAmounts) {
            for (let amount of this.defaultGivingAmounts.split(',')) {
                this._defaultGivingAmountList.push({"amount":  parseFloat(amount).toFixed(2), "label":"$" + amount});
            }
            this._defaultSelectedAmount = parseFloat(this.defaultGivingAmounts.split(',')[0]).toFixed(2);
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
        this.setColor();
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
        if (amount == 'Other') {
            this._showOther = true;
        } else {
            this._amount = event.currentTarget.getAttribute('data-amount');
            try {
                publish(this.messageContext, onlineGivingChannel, {detail: this._amount, type:"amount"});
            } catch (error) {
                console.log(error);
            }
            this._showOther = false;
        }
        this.setColor();
        this.checkValidation();
    }

    setColor = (hoveredAmount) => {
        if (this.template.querySelectorAll('.grid-item label') && this.template.querySelectorAll('.grid-item label').length > 0) {
            this.template.querySelectorAll('.grid-item label').forEach(element => {
                let buttonAmount = element.getAttribute('data-amount');
                if ((buttonAmount == this._amount && !this._showOther)
                        || (this._showOther && buttonAmount == 'Other')
                        || (hoveredAmount && buttonAmount == hoveredAmount)) {
                    element.querySelector('span').style = this.selectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.baseButtonColor;
                } else {
                    element.querySelector('span').style = this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.selectedButtonColor;
                }
            });
            return true;
        }

        return false;
    }

    handleAmountChange(event) {
        if (this.checkValidation(event.currentTarget.value)) {
            this._amount = event.currentTarget.value;
            if (this._defaultGivingAmountList.length > 0) {
                let showOther = true;
                this._defaultGivingAmountList.forEach(amount => {
                    if (amount.amount == this._amount) {
                        showOther = false;
                    }
                });
                this._showOther = showOther;
            }
            this.setColor();

            publish(this.messageContext, onlineGivingChannel, {detail: this._amount, type:"amount"});
        }
    }

    handleAmountInput(event) {
        this.checkValidation();
        this.displayFieldErrors();
    }

    checkValidation(newAmount) {
        let amount = newAmount !== undefined ? newAmount : this._amount;
        let isValid = amount > 0 && (!this.maxAmount || amount <= parseFloat(this.maxAmount));

        if (this.template.querySelectorAll('input') && this.template.querySelectorAll('input').length > 0) {
            let elements = this.template.querySelectorAll('input');
            for (let index = 0; index < elements.length; index++) {
                elements[index].reportValidity();
            }
        }

        publish(this.messageContext, onlineGivingChannel, {detail: isValid, type:"amountValidity"});
        return isValid;
    }

    handleMessage (message) {
        if (message.type == 'data-change') {
            if (message.detail['amount'] && this._amount != message.detail['amount']) {
                this.setAmount(message.detail['amount']);
            }
            this._page = message.detail['page'];
            this._isPledgePayment = message.detail['isPledgePayment'];
            this._isValidPledge = message.detail['isValidPledge'];
        }
        if (message.type == 'reset-amount') {
            publish(this.messageContext, onlineGivingChannel, {detail:this._defaultSelectedAmount, type:"amount"});
            this.setAmount(this._defaultSelectedAmount);
        }
        if (message.type == 'display-field-errors') {
            this.displayFieldErrors();
        }

    }

    setAmount(newAmount) {
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
        this.setColor();
    }

    get isShowComponent() {
        let isGivingPage = this._page == this.pageName;
        if (this._isPledgePayment) {
            return isGivingPage && this._isValidPledge;
        }

        return isGivingPage;
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
        this.setColor(hoveredAmount.target.dataset.amount);
    }

    handleAmountLeave() {
        this.setColor();
    }
}