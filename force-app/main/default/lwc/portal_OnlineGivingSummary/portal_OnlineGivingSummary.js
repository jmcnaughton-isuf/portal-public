import { LightningElement, api, wire, track } from 'lwc';
import { subscribe, unsubscribe, MessageContext, publish} from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingSummary extends LightningElement {
    @api componentLabel;
    @api designationLabel;
    @api amountLabel;
    @api amountTotalLabel;
    @api pageName;
    @api textColor;
    @wire(MessageContext) messageContext;
    _subscription = null;
    _totalAmount;
    _designationList = [];
    _shouldCheckValid = false;
    _page = 'giving';
    _isPledgePayment = false;
    _isValidPledge = false;

    get showDesignations() {
        return this._designationList.length > 0;
    }

    get isShowComponent() {
        let isGivingPage = this._page == this.pageName;
        if (this._isPledgePayment) {
            return isGivingPage && this._isValidPledge;
        }

        return isGivingPage;
    }

    get isShowDesignationDeleteButton() {
        return !this._isPledgePayment;
    }

    get headerStyle() {
        return 'color: ' + this.textColor + ';';
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
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

    renderedCallback() {
        if (this._shouldCheckValid) {
            //defer checking validation on changing designations to rendered callback since this waits until reactivity is done processing for the change.
            //ensures that the queryselector will find the input fields and happens as soon as possible from component finishing
            this._shouldCheckValid = false;
            this.checkValidation();
        }
    }

    handleMessage(message) {
        if (message.type == "data-change") {
            this._page = message.detail['page'];
            this._isPledgePayment = message.detail['isPledgePayment'];
            this._isValidPledge = message.detail['isValidPledge'];
            let amount = parseFloat(message.detail['amount']).toFixed(2);
            let designations  = message.detail['designationList'];
            if (!designations) {
                designations = [];
            }
            let designationList = [];
            let isDesignationChange = designations.length != this._designationList.length;
            if (!isDesignationChange && designations.length > 0) {
                let currentDesignationIdDict = {};

                for (let currentDesignation of this._designationList) {
                    currentDesignationIdDict[currentDesignation.Id] = {isPresent: true, amount: currentDesignation.amount};
                }

                for (let newDesignation of designations) {
                    let currentDesignation = currentDesignationIdDict[newDesignation.Id];
                    let newDesignationAmount = parseFloat(newDesignation.amountDueForInstallments);
                    if (!currentDesignation?.isPresent || (!isNaN(newDesignationAmount) && currentDesignation?.amount !== newDesignationAmount.toFixed(2))) {
                        isDesignationChange = true;
                    }
                }
            }

            if (amount && (amount != this._totalAmount || isDesignationChange)) {
                this._totalAmount = amount;

                if (designations.length > 0) {
                    // designation amounts are either set in backend, or frontend evenly distributes the user-inputted amount
                    let amountFromInstallments = 0;
                    let amountPerDesignation = undefined;

                    if (designations[0].amountDueForInstallments === undefined) {
                        amountPerDesignation = (this._totalAmount/(designations.length)).toFixed(2);

                        while (amountPerDesignation*designations.length > this._totalAmount) {
                            amountPerDesignation = (amountPerDesignation - 0.01).toFixed(2); //need to decrement down if the remainder would have been negative
                        }
                    }

                    for (let index = 0; index < designations.length; index++) {
                        let designation = designations[index];

                        let designationAmount = amountPerDesignation;
                        if (designationAmount === undefined) {
                            amountFromInstallments += designation.amountDueForInstallments;
                            designationAmount = parseFloat(designation.amountDueForInstallments).toFixed(2);
                        }

                        let newDesignation = {"Name": designation.Name, 
                                              "Id": designation.Id, 
                                              "value": designation.value ? designation.value : '', 
                                              'externalSystemId': designation.externalSystemId, 
                                              "amount": designationAmount,
                                              'minimumGiftAmount':designation.minimumGiftAmount, 
                                              'minimumErrorMessage': 'Amount must be at least $' + designation.minimumGiftAmount + ' for this designation.', 
                                              "nonGiftAmount": designation.defaultNonGiftAmount, showOther: designation.Id == 'Other'};

                        if (designation.defaultNonGiftAmount 
                            && designation.defaultNonGiftAmount > designation.minimumGiftAmount) {
                            newDesignation.minimumGiftAmount = designation.defaultNonGiftAmount;
                        }

                        designationList.push(newDesignation);
                    }

                    if (amountPerDesignation !== undefined && amountPerDesignation*designations.length != this._totalAmount) {
                        let remainder = (this._totalAmount - (amountPerDesignation*designations.length)).toFixed(2);
                        designationList[0].amount = (parseFloat(designationList[0].amount) + parseFloat(remainder)).toFixed(2);
                    }

                    this._designationList = [...designationList];

                    if (amountPerDesignation === undefined && amountFromInstallments) {
                        // if amountFromInstallments is incorrect for whatever reason, then another LWC will publish the correct amount right after this publish
                        this._totalAmount = amountFromInstallments.toFixed(2);
                        publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._totalAmount)), type:"totalAmount"});
                    }

                    publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(designationList)), type:"designationWithAmount"});

                    this._shouldCheckValid = true;
                } else {
                    //no designations after change
                    this._designationList = [...designationList];

                    publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(designationList)), type:"designationWithAmount"});

                    this._shouldCheckValid = true;
                }
            }
        }
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
        publish(this.messageContext, onlineGivingChannel, {detail: valid, type:"designationValidity"});
    }

    handleAmountChange(event) {
        let index = event.currentTarget.getAttribute('data-index');
        let amount = event.currentTarget.value;
        this._designationList[index].amount = amount;
        publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._designationList)), type:"designationWithAmount"});
        let totalAmount = 0;
        this._designationList.forEach(designation => {
            designation.amount = parseFloat(designation.amount).toFixed(2);
            totalAmount = (parseFloat(totalAmount) + parseFloat(designation.amount)).toFixed(2);
        });
        if (totalAmount != this._totalAmount) {
            this._totalAmount = totalAmount;
            publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._totalAmount)), type:"totalAmount"});
        }

        this.checkValidation();
    }

    deleteDesignation(event) {
        let index = event.currentTarget.getAttribute('data-index');
        let id = event.currentTarget.getAttribute('data-id');
        this._designationList.splice(index, 1);
        if (this._totalAmount && this._designationList.length > 0) {
            let amountPerDesignation = (this._totalAmount/(this._designationList.length)).toFixed(2);
            this._designationList.forEach(designation => {
                designation.amount = amountPerDesignation;
            });
            if (amountPerDesignation*this._designationList.length != this._totalAmount) {
                let remainder = (this._totalAmount - (amountPerDesignation*this._designationList.length)).toFixed(2);
                this._designationList[0].amount = (parseFloat(this._designationList[0].amount) + parseFloat(remainder)).toFixed(2);
            }

        }
        this._designationList = JSON.parse(JSON.stringify(this._designationList));
        //publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(id)), type:"deleteDesignation"});
        publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._designationList)), type:"designationWithAmount"});

        this._shouldCheckValid = true;
    }

    handleOtherDesignationInput = (event) => {
        let value = event.target.value;

        for (let eachDesignation of this._designationList) {
            if (eachDesignation.Id === 'Other') {
                eachDesignation.value = value;
            }
        }

        this.checkValidation();

        publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._designationList)), type:"designationWithAmount"});
    }
}