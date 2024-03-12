import { LightningElement, api, wire, track } from 'lwc';
import SERVER_getPicklists from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getPicklists'
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingTributeOR extends LightningElement {
    @api componentLabel;
    @api typeLabel;
    @api tributeeLabel;
    @api notifyNameLabel;
    @api notifyAddressLabel;
    @api showNotifyName;
    @api showNotifyAddress;
    @api pageName;
    @api tributePicklistValues = [];
    @wire(MessageContext) messageContext;
    @track _tribute = {
        ucinn_ascendv2__In_Memory_Honor_First_Name_1__c: '',
        ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c: '',
        ucinn_ascendv2__Notify_First_Name_1__c: '',
        ucinn_ascendv2__Notify_Last_Name_1__c: '',
        ucinn_ascendv2__Notify_Address_Line_1_1__c: '', 
        ucinn_ascendv2__Notify_Address_Line_2_1__c: '',
        ucinn_ascendv2__Notify_City_1__c: '',
        ucinn_ascendv2__Notify_State_1__c: '',
        ucinn_ascendv2__Notify_Postal_Code_1__c: ''
    };
    _showForm = false;
    _subscription = null;
    _page = 'giving';
    _isPledgePayment = false;
    _tirbuteIsValid = true;

    connectedCallback() {
        const params = {'params': {
            'field': 'ucinn_ascendv2__Tribute_Type__c',
            'sobjectType': 'ucinn_ascendv2__Tribute__c'
        }};

        SERVER_getPicklists(params).then(res => {
            this.tributePicklistValues = res.ucinn_ascendv2__Tribute__c.ucinn_ascendv2__Tribute_Type__c;
            this.tributePicklistValues.unshift({label: 'Please select an option.', value: ''});
        }).catch(console.error);

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

    handleTributeChecked = (event) => {
        // console.log(event.currentTarget.checked);
        this._showForm = event.currentTarget.checked;
    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this._page = message.detail['page'];
            this._isPledgePayment = message.detail['isPledgePayment'];
            if (this._showForm && this._isPledgePayment) {
                this._showForm = false;
                publish(this.messageContext, onlineGivingChannel, {detail:{}, type:"tribute"});
                
                for (let eachTributeField of Object.keys(this._tribute)) {
                    this._tribute[eachTributeField] = ''; // clear all tribute input values
                }
            }
        }
    }

    get isShowComponent() {
        return this._page == this.pageName && !this._isPledgePayment;
    }

    handleChange = (event) => {
        let field = event.target.name;
        //this._tirbuteIsValid = true;
        console.log('field: ',field);
        if (field) {
            this._tribute[field] = event.currentTarget.value;
             console.log('1',this._tribute['ucinn_ascendv2__Tribute_Type_1__c'] +' 2: ',this._tribute['ucinn_ascendv2__In_Memory_Honor_First_Name_1__c'] + ' 3: ',this._tribute['ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c']);
            if(this._tribute['ucinn_ascendv2__Tribute_Type_1__c'] !== '' && (this._tribute['ucinn_ascendv2__In_Memory_Honor_First_Name_1__c'] === '' || this._tribute['ucinn_ascendv2__In_Memory_Honor_First_Name_1__c'] === undefined  || this._tribute['ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c'] === undefined || this._tribute['ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c'] === '' )) {
                console.log('false:: ',this._tirbuteIsValid);
                this._tirbuteIsValid = false;
            }else {
                this._tirbuteIsValid = true;
            }
            publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._tribute)), type:"tribute"});
            console.log('this._tirbuteIsValid: ',this._tirbuteIsValid);
            publish(this.messageContext, onlineGivingChannel, {detail:this._tirbuteIsValid, type:"tributeValid"});
        }

    }


}