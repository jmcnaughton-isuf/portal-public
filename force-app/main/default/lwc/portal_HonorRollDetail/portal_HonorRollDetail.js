import { LightningElement, api, track } from 'lwc';
import getHonorRollNameDetails from '@salesforce/apex/PORTAL_LWC_HonorRollController.SERVER_getHonorRollNameDetails';

export default class Portal_HonorRollDetail extends LightningElement {
    @api honorRollYear;
    @api displayHonorRollDetail;
    @api handleHonorRollNameClick = () => {};

    @api get record() {
        return _honorRollRecord;
    }

    set record(data) {
        if (data) {
            this.handleCloseDialog();
            this._honorRollRecord = data;
        }
    }

    @track honorRollNameDetails = [];

    _honorRollRecord;


    viewHonorRollNameDetails = (event) => {
        let contactId = event.currentTarget.dataset.contactidvalue;
        let jointContactId = event.currentTarget.dataset.jointcontactidvalue;

        getHonorRollNameDetails({params: {contactId : contactId, jointContactId: jointContactId, fiscalYear: this.honorRollYear}})
        .then(res => {
            if (res) {
                this.honorRollNameDetails = res;
                this.displayHonorRollDetail = true;
            }
        }).catch(e => {
            console.log(e);
        });
    }

    handleCloseDialog = () => {
        this.displayHonorRollDetail = false;
    }
}