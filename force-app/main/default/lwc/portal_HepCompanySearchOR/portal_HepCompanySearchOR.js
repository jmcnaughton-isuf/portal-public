import { LightningElement, api } from 'lwc';


const debounce = (lambda, delay) => {
    let timeout;

    return function () {
        const call = () => lambda.apply(this, arguments);
        clearTimeout(timeout);
        timeout = setTimeout(call, delay);
    }
}

const DEBOUNCER_DELAY_MS = 500;

/**
 * This component includes a searchbar that's wired to the HEPData API. It features automatic
 * searching when the user types, and populates a list with the results of the API searches.
 * To use this component, a container should listen for the following events:
 *
 * onhep_companypicked
 *      Fired when the user clicks on a company after a search.
 *      @return evt.detail The ID associated with this company.
 *
 * onhep_searchexecuted
 *      Fired whenever this component actually executes a search request.
 *      You can use this to cache the query made and repopulate this searchbar
 *      in case the user navigates away.
 *      @return evt.detail The last query made by this component
 */
export default class Portal_HepCompanySearchOR extends LightningElement {
    @api query = "";
    @api matchingCompanyLabel;

    search = debounce((query) => {
        this.dispatchEvent(new CustomEvent('hep_searchexecuted', { detail: query }))
        this.template.querySelector('c-portal_-Hep-Company-Picker-o-r').fetchCompanies(query);
    }, DEBOUNCER_DELAY_MS);

    handleTextChange(evt) {
        this.search(evt.target.value);
    }

    handleCompanyPicked(evt) {
        // bubble this event up another level
        this.dispatchEvent(new CustomEvent('hep_companypicked', evt))
    }

    connectedCallback() {
        if (!!this.query) {
            this.search(this.query);
        }
    }
}