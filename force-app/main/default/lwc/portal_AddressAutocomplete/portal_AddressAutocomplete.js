import { LightningElement, track, api } from 'lwc';
import getAutocompleteSuggestions from '@salesforce/apex/PORTAL_LWC_AddressServiceHubController.SERVER_getAutocompleteSuggestions';
import { callApexFunction } from 'c/portal_util_ApexCallout';

export default class Portal_AddressAutocomplete extends LightningElement {
    @api handleSelection = () => {};
    @api handleInput = () => {};
    @api required = false;
    @api value = '';
    @api country = '';
    @api name = '';

    @track isHideOptionsAfterSelection = false;
    @track isShowSpinner = false;

    _addressMap;
    _recentInputString = '';

    // If this getter's return value is an object of form {label, value}, the lookup LWC will set the input string without doing a lookup
    get inputValue() {
        if (typeof(this.value) === 'string' && this.value !== '') {
            this.value = {'label': this.value, 'value': this.value};
        }
        return this.value;
    }

    @api
    checkValidity() {
        return this.template.querySelector('c-portal_-lookup').checkValidity();
    }
    
    @api
    reportValidity() {
        this.template.querySelector('c-portal_-lookup').reportValidity();
    }

    handleChange = (inputValue) => {
        this._recentInputString = inputValue;
        this.handleInput(this.name, inputValue);
    }

    getAddressSuggestions = (inputValue, selection) => {
        // params keys match PORTAL_AddressServiceInterface.AutocompleteQuery field names
        let params = {'searchInput': inputValue};
        if (selection) {
            params.searchSelection = selection;
        }
        if (this.country) {
            params.country = this.country;
        }

        this.isShowSpinner = true;
        return callApexFunction(this, getAutocompleteSuggestions, params, (result) => {
            let suggestions = this.handleSuggestions(result);
            this.isShowSpinner = false;
            return suggestions;
        }, () => {
            this.isShowSpinner = false;
        });
    }

    // result has type List<PORTAL_AutocompleteAddressWrapper>
    handleSuggestions = (result) => {
        let addressList = [];
        this._addressMap = {};
        for (let eachAddressWrapper of result) {
            let id = eachAddressWrapper.id;
            let label = eachAddressWrapper.label;
            addressList.push({'label': label, 'value': id});     
            this._addressMap[id] = eachAddressWrapper;           
        }

        return addressList;
    }

    handleLookupSelection = async (selectedValue) => {
        let addressWrapper = this._addressMap[selectedValue.value];
        let lookupElement = this.template.querySelector('c-portal_-lookup');

        // ambiguous selection, needs another callout (US Smarty Streets)
        if (addressWrapper.numberOfSimilarEntries > 1) {
            let selected = `${addressWrapper.streetLine1} ${addressWrapper.streetLine2} (${addressWrapper.numberOfSimilarEntries}) ${addressWrapper.city} ${addressWrapper.state} ${addressWrapper.postalCode}`;
            let newAddressList = await this.getAddressSuggestions(this._recentInputString, selected);

            lookupElement.setFocusOnInput();
            this.isHideOptionsAfterSelection = false;
            selectedValue.label = `${addressWrapper.streetLine1} ${addressWrapper.streetLine2}`;
            this.value = selectedValue;
            return newAddressList;
        }
        // unambiguous selection, inform parent LWC of selection 
        else {
            this.isHideOptionsAfterSelection = true;
            let newValue = this.handleSelection(addressWrapper, this.name);
            this.value = newValue ? newValue : selectedValue;
        }
    }
}