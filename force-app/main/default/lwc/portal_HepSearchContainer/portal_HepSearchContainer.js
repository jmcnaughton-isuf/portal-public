import { LightningElement, track, api } from 'lwc';

const STATE = {
    SEARCH: 0,
    DETAILS: 1
}

/**
 * HepSearchContainer is an example component tying together the hepCompanySearch and hepCompanyDetails components.
 *
 * To use this component, a parent or container component should listen for the following events:
 *
 * @fires HepSearchContainer#hep_company_selected
 *
 * @fires HepSearchContainer#hep_company_deselected
 */
export default class Portal_HepSearchContainer extends LightningElement {
    @track _currentState;

    _lastQuery = "";
    _selectedCompanyId;
    @api matchingCompanyLabel;


    constructor() {
        super();
        this._currentState = STATE.SEARCH;
    }

    handleSearchExecuted(evt) {
        this._lastQuery = evt.detail;
    }

    handlePickerSelection(evt) {
        this._currentState = STATE.DETAILS;
        this._selectedCompanyId = evt.detail;
    }

    handleCompanySelected(evt) {
        /**
         * Fired when a user reaches the end of the HepSearchContainer's workflow, selecting a company.
         *
         * @event HepSearchContainer#hep_company_selected
         * @type {CustomEvent}
         * @property {String} id
         * @property {String} name
         * @property {String} foundationName
         */
        this.dispatchEvent(new CustomEvent('hep_company_selected', { detail: evt.detail }));
        this._currentState = STATE.SEARCH;
        this._lastQuery = "";
    }

    handleCompanyDeselected(evt) {
        /**
         * Fired when a user clicks the BACK button after reaching the end of this workflow.
         * Should be used to clear any information collected from HepSearchContainer#hep_company_selected
         * since the user has indicated that they have changed their mind.
         *
         * @event HepSearchContainer#hep_company_deselected
         * @type {CustomEvent}
         */
        this.dispatchEvent(new CustomEvent('hep_company_deselected'));
    }

    handleBack() {
        if (this._currentState === STATE.DETAILS) {
            this._currentState = STATE.SEARCH;
            this._selectedCompanyId = null;
        }
    }

    get stateIsSearch() {
        return this._currentState === STATE.SEARCH;
    }

    get stateIsDetails() {
        return this._currentState === STATE.DETAILS || this._currentState === STATE.CONFIRMED;
    }

    get stateIsConfirmed() {
        return this._currentState === STATE.CONFIRMED;
    }
}