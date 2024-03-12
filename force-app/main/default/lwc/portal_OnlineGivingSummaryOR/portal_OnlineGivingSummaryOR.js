import { LightningElement, api, wire, track } from 'lwc';
import { subscribe, unsubscribe, MessageContext, publish} from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingSummaryOR extends LightningElement {
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
    _isFirstTimeFund = true;

    refreshComponent(event){
        window.location.reload();
    }
    get showDesignations() {
        //console.log(' Show Designation :: '+this._isFirstTimeFund);
        let returnValue = this._designationList.length > 0;
        if(returnValue === true && this._isFirstTimeFund === false){
            returnValue = true;
        }else{
            returnValue = false;
        }
        //console.log(' Show Designation returnValue :: '+returnValue);
        return returnValue;//this._designationList.length > 0;
    }

    get isShowComponent() {
        return this._page == this.pageName;
    }

    get headerStyle() {
        return 'color: ' + this.textColor + ';';
    }
    get designationChanged(){
       // console.log(' Change Event:: '+this._isFirstTimeFund);
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
            let amount = parseFloat(message.detail['amount']).toFixed(2);
            let isChange = message.detail['firstTimeFund'];
            this._isFirstTimeFund = isChange;
            //console.log('firstFund:: '+isChange + 'Change Fund:: '+this._isFirstTimeFund);
            let designations  = message.detail['designationList'];
            if (!designations) {
                designations = [];
            }
            let designationList = [];
            let isDesignationChange = designations.length != this._designationList.length;
            if (!isDesignationChange && designations.length > 0) {
                let currentDesignationIdDict = {};

                for (let currentDesignation of this._designationList) {
                    currentDesignationIdDict[currentDesignation.Id] = true;
                }

                for (let newDesignation of designations) {
                    if (!currentDesignationIdDict[newDesignation.Id]) {
                        isDesignationChange = true;
                    }
                }
            }

            //console.log('amount:: '+amount + '_totalAmount Fund:: '+this._totalAmount + 'isDesignationChange: '+isDesignationChange);
            if (amount && (amount != this._totalAmount || isDesignationChange)) {
                this._totalAmount = amount;
                if (designations.length > 0) {
                    let totalAmt = 0;
                    for (let index = 0; index < designations.length; index++) {
                        let designation = designations[index];
                        let newDesignation = {"Name":designation.Name, "Id":designation.Id,"value": designation.value, 'ucinn_ascendv2__External_System_ID__c': designation.ucinn_ascendv2__External_System_ID__c, "amount": designation.amount, 'ucinn_ascendv2__Minimum_Gift_Amount__c':designation.ucinn_ascendv2__Minimum_Gift_Amount__c, 'minimumErrorMessage': 'Amount must be at least $' + designation.ucinn_ascendv2__Minimum_Gift_Amount__c + ' for this designation.', "nonGiftAmount": designation.nonGiftAmount, showOther: designation.Id == 'Other'};
                        if (designation.nonGiftAmount
                            && designation.nonGiftAmount > designation.ucinn_ascendv2__Minimum_Gift_Amount__c) {
                            newDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c = designation.nonGiftAmount;
                        }
                        totalAmt = (parseFloat(totalAmt) + parseFloat(designation.amount)).toFixed(2);
                        this._isFirstTimeFund = designation.firstTimeFund;
                        designationList.push(newDesignation);
                    }
                    this._designationList = [...designationList];
                    publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(designationList)), type:"designationWithAmount"});
                    //console.log(' Summary List:: '+JSON.stringify(this._designationList) +' totalAmt:::: '+totalAmt + '   :this_totalamount:: '+this._totalAmount + ' FirstTimeFund:: '+this._isFirstTimeFund);
                    if (totalAmt != this._totalAmount) {
                        this._totalAmount = totalAmt;
                        publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._totalAmount)), type:"totalAmount"});
                    }
                    //this._totalAmount = totalAmt;
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
            let amountPerDesignation = 0;
            this._designationList.forEach(designation => {
                amountPerDesignation = (parseFloat(amountPerDesignation) + parseFloat(designation.amount)).toFixed(2);
            });
            this._totalAmount = amountPerDesignation;
        } else {
            //this._isFirstTimeFund = true;
            //publish(this.messageContext, onlineGivingChannel, {detail : this._isFirstTimeFund, type:"firstTimeFund"});
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

       // console.log(JSON.stringify(this._designationList));

        publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._designationList)), type:"designationWithAmount"});
    }
}