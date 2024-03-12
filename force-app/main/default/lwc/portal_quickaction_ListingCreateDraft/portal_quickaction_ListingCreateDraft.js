import { LightningElement, api, wire } from 'lwc';
import SERVER_createDraft from '@salesforce/apex/PORTAL_ListingCreateDraftController.SERVER_createDraft';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import STATUS_FIELD from '@salesforce/schema/ucinn_portal_Listing__c.Status__c';
import {redirectToNewRecordId, displayErrorAlert} from 'c/portal_Util_Listing';

const RECORD_FIELDS = [STATUS_FIELD];
const STATUS_IS_DRAFT_ERROR_MESSAGE = 'This Listing is already a draft. You cannot make a draft from a draft.'

export default class Portal_Quickaction_ListingCreateDraftTemp extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId',  fields: RECORD_FIELDS })
    wiredGetRecordInfo({ data, error }) {
        if (data) {
            console.log('wiredGetRecordInfo found some data!');
            console.log(data);

            let statusValue = getFieldValue(data, STATUS_FIELD);

            if (statusValue && statusValue === 'Draft') {
                alert(STATUS_IS_DRAFT_ERROR_MESSAGE);
            }
            else {
                SERVER_createDraft({ params : {masterRecordId: this.recordId} }).then(response => {
                    redirectToNewRecordId(response);
                }).catch(error => {
                    displayErrorAlert(error);
                });
            }
        }

        else if (error) {
            console.log('wiredGetRecordInfo found and error :(');
            console.log(error);
            alert(reduceErrors(error));
        }
    }


}