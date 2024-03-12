import { LightningElement, track, api } from 'lwc';

import getCompaniesByName from '@salesforce/apex/PORTAL_HEP_ApiRepository.getCompaniesByName';

const columns = [
    { label: "Name", fieldName: "name" },
    { label: "ID", fieldName: "company_id" },
    { label: "Parent Name", fieldName: "parent_name" },
    { label: "Subsidiary Name", fieldName: "subsidiary_name" },
    { label: "City", fieldName: "city" },
    { label: "State", fieldName: "state" },
]

export default class Portal_HepCompanyPicker extends LightningElement {
    _columns = columns;
    @track _companies = [];
    @api currentQuery;

    _loaded = true;

    get companyNumber() {
        if (this._companies) {
            return this._companies.length;
        } else {
            return 0;
        }
    }


    onCompanyClick(event) {
        this.dispatchEvent(new CustomEvent('hep_companypicked', { detail: event.currentTarget.dataset.id }))
    }

    @api fetchCompanies(query) {
        this._loaded = false;

        const params = {
            name: query
        }

        getCompaniesByName(params)
            .then(res => {
                this._companies = res.results;
            })
            .catch(e => {
                console.error(`Error searching for companies: ${JSON.stringify(e)}`);
            })
            .finally(_ => {
                this._loaded = true;
            });
    }
}