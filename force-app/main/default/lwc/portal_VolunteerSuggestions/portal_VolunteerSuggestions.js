import { LightningElement, api, wire, track } from 'lwc';
import getVolunteerSuggestions from '@salesforce/apex/PORTAL_LWC_VolunteerSuggestions.SERVER_getVolunteerSuggestions';

export default class Portal_VolunteerSuggestions extends LightningElement {
    @api recordId;

    @track _volunteerSuggestions;


    get getVolunteerSuggestionsParams() {
        return {recordId: this.recordId};
    }

    @wire(getVolunteerSuggestions, {params: '$getVolunteerSuggestionsParams'})
    wiredVolunteerSuggestions({data, error}) {
        if (data) {
            let volunteerSuggestions = [];

            for (let volunteer of data) {
                let volunteerCopy = Object.assign({}, volunteer);

                volunteerCopy.contactLink = '/lightning/r/Contact/' + volunteerCopy.Id + '/view';
                volunteerSuggestions.push(volunteerCopy);
            }

            this._volunteerSuggestions = volunteerSuggestions;
        }

        if (error) {
            alert(error);
        }
    }
}