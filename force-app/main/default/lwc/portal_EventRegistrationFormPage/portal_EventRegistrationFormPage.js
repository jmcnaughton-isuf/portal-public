import { LightningElement, api, track } from 'lwc';

export default class Portal_EventRegistrationFormPage extends LightningElement {
    @api registrantList;

    @api handleAdditionalInfoChange = () => {};

    @track _fieldsToDisplay;

    @api
    get currentIndex() {
        return this._currentIndex;
    }

    set currentIndex(value) {
        this._currentIndex = value;
        let resultList = [];

        if (!this.registrantList || !value) {
            return;
        }

        this.registrantList.forEach(registrant => {
            let registrantFieldMap = {};
            registrantFieldMap.name = registrant.firstName + ' ' + registrant.lastName;
            if (registrant.additionalInfoList) {
                let additionalInfoList = [];
                registrant.additionalInfoList.forEach(additionalInfo => {
                    if (additionalInfo.formField.pageNumber === value) {
                        additionalInfoList.push(additionalInfo);
                    }
                })

                registrantFieldMap.additionalInfoList = additionalInfoList;
            }

            if (registrantFieldMap.additionalInfoList && registrantFieldMap.additionalInfoList.length > 0) {
                registrantFieldMap.isShowRegistrant = true;
            }

            registrantFieldMap.key = registrant.firstName + registrant.lastName + Date.now();

            resultList.push(registrantFieldMap);
        })

        this._fieldsToDisplay = resultList;
    }

    @track _currentIndex;

    @api checkInputValidity() {
        let customFormFieldInputs = this.template.querySelectorAll('c-portal_-Custom-Form-Field');
        let validity = true;

        if (customFormFieldInputs) {
            for (const customFormFieldInput of customFormFieldInputs) {
                if (customFormFieldInput.checkValidity() === false) {
                    if (validity === true) {
                        customFormFieldInput.reportValidity();
                        validity = false;
                    }
                }
            }
        }

        if (validity === false) {
            return false;
        }

        return true;
    }
}