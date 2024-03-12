import { LightningElement, track, api } from 'lwc';

import getCompanyDetailsByID from '@salesforce/apex/PORTAL_HEP_ApiRepository.getCompanyDetailsByID'

const STATE = {
    DETAILS: 0,
    SELECTED: 1
}

/**
 * Given a selectedCompanyId, this component is in charge of fetching information from the HEPData API
 * and rendering it for user consumption.
 *
 * Events emitted:
 *
 * onhep_company_selected
 *      Fired when the user clicks a "Select This Company" button. By default, this component will automatically
 *      switch to a minified layout.
 *      @return evt.detail A serialized JSON representation of this company. See HEPData API documentation for the
 *                          exact shape of this object; or see ascend_HEP_CompanyDetailsResult.cls
 *
 * onhep_company_deselected
 *      Fired when the user clicks the "Back" button after having clicked the "Select This Company" button.
 *      Will switch to the un-minified version of this component.
 *
 * onhep_details_back
 *      Fired when the user clicks the "Back" button without having selected this company.
 *      The container should handle navigation away from this component.
 */
export default class Portal_HepCompanyDetailsOR extends LightningElement {
    @track _company = {};
    @track _contact = {};
    @track _address = null;

    @track _onlineForm = {};
    @track _matchDetails = null;

    @track _comments = "";
    @track _procedure = "";

    _companyId;
    _loaded = false;

    @track _currentState = STATE.DETAILS;

    @api get selectedCompanyId() {
        return this._companyId;
    }

    set selectedCompanyId(companyId) {
        this._companyId = companyId;
        this.fetchData();
    }

    get hasOnlineForm() {
        return (this._onlineForm && this._onlineForm.enabled);
    }

    get hasGiftRatiosInfo() {
        return !!this._matchDetails;
    }

    get hasAddress() {
        return !!this._address;
    }

    get hasProcedure() {
        return !!this._procedure;
    }

    fetchData() {
        if (this._companyId !== null) {
            this._loaded = false;

            const params = {
                companyId: this._companyId
            };

            getCompanyDetailsByID(params)
                .then(res => {
                    console.log('res:: ',res);
                    const response = res;
                    this._company = {
                        id: response.company_id,
                        name: response.name,
                        foundationName: response.foundation_name
                    };

                    this._contact = {
                        name: response.contact,
                        phone: response.contact_phone,
                        email: response.contact_email
                    };

                    this._address = {
                        street: `${response.contact_address_line1} ${response.contact_address_line2}`,
                        city: response.contact_city,
                        state: response.contact_state,
                        zip: response.contact_zip
                    }

                    if (response.giftratios && response.giftratios.length) {
                        const ratio = response.giftratios[0];
                        this._matchDetails = {
                            min: ratio.minimum_amount_matched,
                            max: ratio.maximum_amount_matched,
                            ratioLabel: ratio.description,
                            maxPerEmployee: ratio.total_amount_per_employee
                        }
                    }

                    if (response.online_resources && response.online_resources.length) {
                        const resource = response.online_resources[0];
                        this._onlineForm = {
                            enabled: resource.online_form,
                            url: resource.online_formurl
                        }
                    }

                    this._comments = response.comments;

                    if (response.procedure) {
                        this._procedure = response.procedure.procedure_website;
                    }
                    this._loaded = true;
                })
                .catch(console.error);
        }
    }

    get isFull() {
        return this._currentState === STATE.DETAILS;
    }

    handleBack() {
        if (this._currentState === STATE.SELECTED) {
            this._currentState = STATE.DETAILS;
            this.dispatchEvent(new CustomEvent('hep_company_deselected'));
        }
        else {
            this.dispatchEvent(new CustomEvent('hep_details_back'));
        }
    }

    handleCompanySelected() {
        this._currentState = STATE.SELECTED;
        this.dispatchEvent(new CustomEvent('hep_company_selected', { detail: JSON.stringify(this._company) }));
    }
}