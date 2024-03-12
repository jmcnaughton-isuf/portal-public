import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import basePath from '@salesforce/community/basePath';
import initEventRegistration  from '@salesforce/apex/PORTAL_LWC_EventRegistrationController.SERVER_initEventRegistration';
import getPromoCodeDiscount from '@salesforce/apex/PORTAL_LWC_EventRegistrationController.SERVER_getPromoCodeDiscount';
import registerParticipants  from '@salesforce/apex/PORTAL_LWC_EventRegistrationController.SERVER_registerParticipants';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { getRelativeUrl } from 'c/portal_util_Urls';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_EventRegistrationWrapper extends LightningElement {
    @api emailTemplateDeveloperName = 'Portal_Event_Confirmation';

    @track _isRecaptchaEnabled = false;
    @track _ticketTypeList;
    @track _ticketAvailabilityMap;
    @track _registrantList;
    @track _registrantIndex = 0;
    @track _hasContact;
    @track _hasPromoCodes;
    @track _isGuestRegistrationModifiable;
    @track _isWalkIn = false;

    @track _listing;
    @track _formattedEvent;
    @track _isShowSpinner;
    @track _registrationTemplate;
    @track _registrationPageList;
    @track _promoCode = '';
    @track _customFormFields;
    @track _currentPageIndex = 0;
    @track _totalNumberOfPages = 0;
    @track _ticketTypeIdForWaitlist;
    @track _waitlistMax;
    @track _showWaitlistModal;
    @track _waitlistEntryId;
    @track _showWaitlistDeleteConfirmation;
    @track _isShowEventConfirmation = false;
    @track _ticketTypesWithTicketsInCart = [];
    @track _isTermsAndConditionsChecked = false;

    @track _paymentMethod = "Cash";
    @track _paymentOptions = [{label: "Cash", value: "Cash"},
                              {label: "Credit Card - Onsite", value: "Credit Card - Onsite"},
                              {label: "Credit Card - Online", value: "Credit Card - Online"},
                              {label: "Free", value: "Free"}];

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_EventRegistrationControllerBase.registerParticipants'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    get hasMultipleRegistrants() {
        return this._registrantList && this._registrantList.length > 1;
    }

    get isShowAddGuest() {
        if (!this._listing || this._listing.Number_of_Guests__c === 0 || (!this.hasTicketTypesForSale() && !this._listing.Is_Non_Ticketed_Event__c)) {
            return false;
        }

        if (!this._listing.Number_of_Guests__c) {
            return true;
        }

        return this._registrantList && this._listing.Number_of_Guests__c >= this._registrantList.length
    }

    get isShowTickets() {
        return this._listing && !this._listing.Is_Non_Ticketed_Event__c;
    }

    get isLastPage() {
        return this._currentPageIndex === this._totalNumberOfPages;
    }

    get isShowNextPageButton() {
        return this._currentPageIndex !== this._totalNumberOfPages;
    }

    get isShowPreviousPageButton() {
        return this._currentPageIndex !== 0;
    }

    get isShowRegistration() {
        return !this._isShowEventConfirmation && this._listing
    }

    get registrantListToDisplay() {
        let resultList = [...this._registrantList];

        resultList[this._registrantIndex] = Object.assign({}, resultList[this._registrantIndex]);
        resultList[this._registrantIndex].isCurrentRegistrant = true;

        return resultList;
    }

    get currentRegistrant() {
        if (!this._registrantList) {
            return {};
        }

        return this._registrantList[this._registrantIndex];
    }

    get primaryRegistrant() {
        if (!this._registrantList) {
            return {};
        }

        return this._registrantList[0];
    }

    get eventList() {
        if (!this._formattedEvent) {
            return [];
        }

        return [{ticketsForEvent: this._listing}];
    }

    get isRegisterButtonDisabled() {
        if (this._registrationTemplate && this._registrationTemplate.Has_Terms_and_Conditions__c && this._isTermsAndConditionsChecked != true) {
            return true;
        }

        return false;
    }

    get isDisplayRecaptchaForNonTicketedEvent() {
        return this._isRecaptchaEnabled && this._listing.Is_Non_Ticketed_Event__c;
    }

    connectedCallback() {
        let searchParams = new URLSearchParams(window.location.search);
        let recordId = searchParams.get('recordId');
        let participationId = searchParams.get('participationId');
        let walkIn = searchParams.get('walkIn');
        let removeEntry = searchParams.get('removeEntry');
        this._waitlistEntryId = searchParams.get('waitlistEntryId');

        if (removeEntry === 'true' && this._waitlistEntryId) {
            this._showWaitlistDeleteConfirmation = true;
            return;
        }

        if (walkIn === 'true') {
            this._isWalkIn = true;
        }

        this._isShowSpinner = true;

        initEventRegistration({params: {listingId: recordId, primaryParticipationId: participationId, isWalkIn: this._isWalkIn, waitlistEntryId: this._waitlistEntryId}}).then(result => {
            this._listing = result.listingRecord;
            this._registrationTemplate = result.registrationTemplate;
            this._customFormFields = result.customFormFields;
            this._hasContact = result.contact != null;
            this._hasPromoCodes = result.hasPromoCodes;
            this._ticketAvailabilityMap = result.ticketAvailability;
            this._ticketTypesWithTicketsInCart = result.ticketTypesWithTicketsInCart;
            this._isWalkIn = result.isWalkIn;

            if (result.registrationTemplate && result.registrationTemplate.ucinn_portal_Registration_Pages__r) {
                this._totalNumberOfPages = result.registrationTemplate.ucinn_portal_Registration_Pages__r.length;
            }

            if (this._listing) {
                this._ticketTypeList = this.getParsedTicketTypeList(result.ticketTypeList);
                this.handleTicketTypeSoldOut();
            }

            this._formattedEvent = result.formattedEvent;

            if (result.ticketDiscountMap) {
                this.applyTicketDiscounts(result.ticketDiscountMap);
            }

            this.parseOrgSettings(result.orgSettings);

            if (result.registrantList) {
                this._registrantList = this.initializeRegistrantList(result.registrantList);
                if (this._hasContact) {
                    this._contactRegistrant = Object.assign({}, this.currentRegistrant);
                }
            } else {
                let currentRegistrant = this.createNewRegistrant(0);
                this._registrantList = [currentRegistrant];
            }
            this._isShowSpinner = false;
        }).catch(e => {
            console.log(e);
            this._isShowSpinner = false;
            let errorMap = JSON.parse(e.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        })
    }

    createNewRegistrant(index) {
        let registrant = {// fields corresponding to EventRegistrant POJO
                          firstName: '',
                          lastName: '',
                          email: '',
                          nameTag: '',
                          isSendConfirmation: false,
                          isDisplayOnLookWhosComingList: this._listing?.Is_Display_Look_Who_s_Coming__c ? true : false,
                          degreeAndYear: '',
                          employer: '',
                          phone: '',
                          street1: '',
                          street2: '',
                          city: '',
                          state: '',
                          country: '',
                          postalCode: '',
                          hasInterim: true,
                          // front end fields only
                          isRemovable: index !== 0};

        let ticketList = this.createTicketList();
        let additionalInfoList = this.createAdditionalInfoList();

        registrant.ticketList = ticketList;
        registrant.additionalInfoList = additionalInfoList

        this.parseAdditionalInfoForRegistrant(registrant, index);

        return registrant;
    }

    getParsedTicketTypeList(ticketTypeList) {
        let resultList = [];

        if (ticketTypeList) {
            ticketTypeList.forEach(ticketType => {
                let newTicketType = {};

                newTicketType.name = ticketType.Name;
                newTicketType.id = ticketType.Id;
                newTicketType.originalPrice = ticketType.Price__c;
                newTicketType.price = ticketType.Price__c;
                newTicketType.maxTickets = ticketType.Max_Tickets_Per_Registrant__c;
                newTicketType.description = ticketType.Description__c;
                if (this.isTicketTypeNotForSale(ticketType) && !this._isWalkIn) {
                    newTicketType.isNotForSale = true;
                }

                resultList.push(newTicketType);
            })
        }

        return resultList;
    }

    createTicketList() {
        let resultList = [];

        if (this._ticketTypeList) {
            this._ticketTypeList.forEach(ticketType => {
                let blankTicket = this.createBlankTicket(ticketType);

                if (this._listing.Is_Non_Ticketed_Event__c) {
                    blankTicket.quantity = '1';
                    blankTicket.isSelected = true;
                }

                resultList.push(blankTicket);
            });
        }

        return resultList;
    }

    createAdditionalInfoList() {
        let resultList = [];

        if (this._customFormFields) {
            this._customFormFields.forEach(formField => {
                let additionalInfo = this.createNewAdditionalInfo(formField);
                    resultList.push(additionalInfo);
            })
        }

        return resultList;
    }

    createBlankTicket(ticketType) {
        let ticket = {ticketType: ticketType,
                      ticketTypeId: ticketType.id,
                      ticketTypeName: ticketType.name,
                      quantity: '',
                      purchasedQuantity: 0,
                      min: 0,
                      max: ticketType.maxTickets,
                      price: ticketType.originalPrice};

        if (ticketType.isNotForSale) {
            ticket.isHidden = true;
        }

        return ticket;
    }

    createNewAdditionalInfo(formField) {
        let additionalInfo = {label: formField.label,
                              name: formField.name,
                              value: formField.type === 'Multi-Picklist' ? formField.multiPicklistDefaultValues : formField.defaultValue,
                              customFormFieldId: formField.Id,
                              pageNumber: formField.pageNumber,
                              formField: formField,
                              key: formField.label + Date.now()}

        return additionalInfo;
    }

    handleRegistrantInput = (event) => {
        let value = event.target.value;
        let fieldName = event.target.name;

        if (event.target.type === 'checkbox') {
            value = event.target.checked;
        }

        this.currentRegistrant[fieldName] = value;
    }

    handleTicketInput = (event) => {
        // value is the inputted number as a string
        let value = event.currentTarget.value;
        let ticketTypeId = event.currentTarget.name;
        
        this.currentRegistrant.ticketList.forEach(ticket => {
            if (ticket.ticketTypeId === ticketTypeId) {
                ticket.quantity = value;
            }
        })

        this.validateTicketInput(event, ticketTypeId, value);
    }

    validateTicketInput(event, ticketTypeId, quantity) {
        if (!event.currentTarget.checkValidity()) {
            event.currentTarget.reportValidity();
            return false;
        }

        let totalQuantity = 0;
        let ticketTypeQuantity = 0;
        let maxRegistrantQuantity = 0;

        this._registrantList.forEach(registrant => {
            let ticketsForRegistrant = 0;
            registrant.ticketList.forEach(ticket => {
                let thisQuantity = ticket.quantity;

                if (this.currentRegistrant === registrant && ticket.ticketTypeId === ticketTypeId) {
                    thisQuantity = quantity
                }

                if (!thisQuantity) {
                    thisQuantity = 0;
                } else {
                    thisQuantity = parseInt(thisQuantity, 10);
                }

                ticketsForRegistrant = ticketsForRegistrant + thisQuantity;

                if (ticket.quantityInPossession) {
                    thisQuantity = thisQuantity - ticket.quantityInPossession;
                }

                totalQuantity = totalQuantity + thisQuantity;

                if (ticket.ticketTypeId === ticketTypeId) {
                    ticketTypeQuantity = ticketTypeQuantity + thisQuantity;
                }
            })

            if (maxRegistrantQuantity < ticketsForRegistrant) {
                maxRegistrantQuantity = ticketsForRegistrant;
            }
        })

        if (this._listing.Is_Guest_Registration_Info_Required__c && maxRegistrantQuantity > 1) {
            event.currentTarget.setCustomValidity('Only one ticket is allowed per registrant.');
            event.currentTarget.reportValidity();
            return false;
        }

        if (this._ticketAvailabilityMap.totalTickets < totalQuantity || this._ticketAvailabilityMap[ticketTypeId] < ticketTypeQuantity) {
            event.currentTarget.setCustomValidity('There are not enough tickets currently available.');
            event.currentTarget.reportValidity();
            return false;
        }

        return true;
    }

    handleTicketCheckbox = (event) => {
        let index = event.target.dataset.index;
        let value = event.target.checked;

        if (value) {
            let quantityInPossession = this.currentRegistrant.ticketList[index].quantityInPossession;
            this.currentRegistrant.ticketList[index].quantity = quantityInPossession ? quantityInPossession.toString() : '1';
        } else {
            this.currentRegistrant.ticketList[index].quantity = '0';
        }

        this.currentRegistrant.ticketList[index].isSelected = value;

        if (this._customFormFields) {
            this._customFormFields.forEach(formField => {
                if (formField.ticketTypeId === this.currentRegistrant.ticketList[index].ticketTypeId) {
                    for (let additionalInfoIndex = 0; additionalInfoIndex < this.currentRegistrant.additionalInfoList.length; additionalInfoIndex++) {
                        let additionalInfo = this.currentRegistrant.additionalInfoList[additionalInfoIndex];

                        if (additionalInfo.customFormFieldId === formField.Id && !value) {
                            this.currentRegistrant.additionalInfoList.splice(additionalInfoIndex, 1);
                            return;
                        }

                        if (value && (additionalInfo.pageNumber > formField.pageNumber || (additionalInfo.pageNumber === formField.pageNumber && additionalInfo.formField.fieldOrder > formField.fieldOrder))) {
                            this.currentRegistrant.additionalInfoList.splice(additionalInfoIndex, 0, this.createNewAdditionalInfo(formField));
                            return;
                        }

                        if (value && additionalInfoIndex === this.currentRegistrant.additionalInfoList.length - 1) {
                            this.currentRegistrant.additionalInfoList.push(this.createNewAdditionalInfo(formField));
                            return;
                        }
                    }

                    if (this.currentRegistrant.additionalInfoList.length == 0) {
                        this.currentRegistrant.additionalInfoList.push(this.createNewAdditionalInfo(formField));
                    }
                }
            });
        }

        if (this._listing.Is_Guest_Registration_Info_Required__c && !this.isRegistrantHasMultipleTickets()) {
            let registrantForm = this.template.querySelector('c-portal_-event-registrant-form');
            registrantForm.resetInputValidity();
        }
    }

    isRegistrantHasMultipleTickets() {
        let ticketsForRegistrant = 0;
        this.currentRegistrant.ticketList.forEach(ticket => {
            let thisQuantity = ticket.quantity;

            if (!thisQuantity) {
                thisQuantity = 0;
            } else {
                thisQuantity = parseInt(thisQuantity, 10);
            }

            ticketsForRegistrant = ticketsForRegistrant + thisQuantity;
        })

        return ticketsForRegistrant > 1;
    }

    handleRegisterClick() {
        if (!this.isRegistrationValid()) {
            return;
        }

        submitForm(this, this.submissionLogic, (error) => {
            console.log(error);
        });
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        let registrantList = this.parseRegistrantList();

        let sessionId = this.getCookie('PORTAL_EVENT_SHOPPING_CART_ID');

        if (!sessionId) {
            sessionId = this.setCookie('PORTAL_EVENT_SHOPPING_CART_ID');
        }

        this._isShowSpinner = true;

        const params = {listingId: this._listing.Id,
                                       sessionId: sessionId,
                                       registrantList: registrantList,
                                       isWalkIn: this._isWalkIn,
                                       waitlistEntryId: this._waitlistEntryId,
                                       paymentMethod: this._paymentMethod,
                                       interimSourceUrl: getRelativeUrl(),
                                       emailTemplateDeveloperName: this.emailTemplateDeveloperName,
                                       recaptchaToken: recaptchaToken};

        callApexFunction(this, registerParticipants, params, (result) => {
            this._isShowSpinner = false;
            let redirectUrl = basePath + '/shopping-cart';

            if (this._listing.Is_Non_Ticketed_Event__c && this._isWalkIn) {
                redirectUrl = basePath + '/event-management?name=' + encodeURIComponent(this._listing.Name);
            } else if (this._listing.Is_Non_Ticketed_Event__c || !this.hasTicketsPurchased()) {
                redirectUrl = basePath + '/event-confirmation?sessionId=' + result.sessionId;
            } else if (this._registrantList[0].participationStatus === 'Registered'
                    || result.existingPrimaryParticipationStatus === 'Registered' // if _registrantList became stale, result may have a different status
                    || (this._isWalkIn && this._paymentMethod === 'Credit Card - Online')
                    || this._waitlistEntryId) {
                redirectUrl = basePath + '/event-payment-form';
            } else if (this._isWalkIn) {
                redirectUrl = basePath + '/event-management?name=' + encodeURIComponent(this._listing.Name);
            }
            window.location.href = redirectUrl;
        }, (error) => {
            this._isShowSpinner = false;
            console.log(error);
            errorRecaptchaCallback();
        });
    }

    handleRegistrantClick(event) {
        let registrantIndex = event.target.dataset.index;

        if (!this.isRegistrationValid()) {
            return;
        }

        this._registrantIndex = parseInt(registrantIndex);
    }

    handleAddGuest() {
        if (!this.isRegistrationValid()) {
            return;
        }

        let newGuest = this.createNewRegistrant(this._registrantList.length);

        this._registrantList.push(newGuest);
        this._registrantIndex = this._registrantList.length - 1;
    }

    handleRemoveGuest = (event) => {
        let indexToRemove = parseInt(event.currentTarget.dataset.index);

        if (this._registrantIndex >= this._registrantList.length - 1) {
            this._registrantIndex = this._registrantList.length - 2;
        } else if (indexToRemove < this._registrantIndex) {
            --this._registrantIndex;
        }

        this._registrantList.splice(indexToRemove, 1); 

        let registrantForm = this.template.querySelector('c-portal_-event-registrant-form');
        registrantForm.resetInputValidity();
    }

    handlePreviousPage() {
        if (this._currentPageIndex > 0) {
            this._currentPageIndex = this._currentPageIndex - 1;
        }
    }

    handleNextPage() {
        if (this._currentPageIndex === 0 && !this.isRegistrationValid()) {
            return;
        }

        if (this._currentPageIndex < this._totalNumberOfPages) {
            this._currentPageIndex = this._currentPageIndex + 1;
        }
    }

    handlePromoCodeChange = (event) => {
        this._promoCode = event.target.value;
    }

    handleApplyPromoCode = () => {
        this._isShowSpinner = true;
        getPromoCodeDiscount({params: {listingId: this._listing.Id, promoCode: this._promoCode}}).then((result) => {
            this._isShowSpinner = false;
            if (!result.ticketTypeId) {
                const event = new ShowToastEvent({
                                title: 'Error!',
                                message: 'The ticket discount could not be found.',
                                variant:"error",
                                mode:"sticky"
                            });
                            this.dispatchEvent(event);
                return;
            }

            if (this._ticketTypeList) {
                this._ticketTypeList.forEach(ticketType => {
                    if (ticketType.id === result.ticketTypeId) {
                        if (ticketType.discountedPrice != undefined && ticketType.discountedPrice != null && ticketType.discountedPrice < result.discountedPrice) {
                            const event = new ShowToastEvent({
                                message: 'The discount was not applied since a larger discount is already applied!',
                                variant:"info",
                                mode:"sticky"
                            });
                            this.dispatchEvent(event);
                            return;
                        }

                        ticketType.discountedPrice = result.discountedPrice;
                        ticketType.price = result.discountedPrice;
                        ticketType.ticketDiscountId = result.ticketDiscountId;
                        ticketType.isDiscounted = true;
                        //TODO: see if we can remove
                        ticketType.promoCode = this._promoCode;
                        const event = new ShowToastEvent({
                            title: 'Success!',
                            message: 'Your discount has been applied!',
                            variant:"success",
                            mode:"sticky"
                        });
                        this.dispatchEvent(event);
                        return;
                    }
                })
            }
        }).catch(e => {
            this._isShowSpinner = false;
            let errorMap = JSON.parse(e.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        })
    }

    handleAdditionalInfoChange = (event, label) => {
        let index = event.target.dataset.index;
        let value = event.target.value;

        if (index === undefined) {
            index = event.target.name;
        }

        let registrantToChange = this._registrantList[index];

        registrantToChange.additionalInfoList.forEach(additionalInfo => {
            if (additionalInfo.formField.label === label) {
                if (additionalInfo.formField.type === 'Checkbox') {
                    value = event.target.checked;
                }

                additionalInfo.value = value;
            }
        })
    }

    handlePaymentMethodChange = (event) => {
        this._paymentMethod = event.target.value;
    }

    handleCloseWaitlistModal = () => {
        this._ticketTypeIdForWaitlist = '';
        this._showWaitlistModal = false;
    }

    parseRegistrantList() {
        let resultList = [];

        this._registrantList.forEach(registrant => {
            let newRegistrant = Object.assign({}, registrant);

            if (registrant.ticketList) {
                let newTicketList = []
                registrant.ticketList.forEach(ticket => {
                    let newTicket = Object.assign({}, ticket);
                    if (!newTicket.quantity || parseInt(newTicket.quantity, 10) === 0 || !newTicket.isSelected) {
                        return;
                    }

                    if (newTicket.ticketType) {
                        newTicket.price = newTicket.ticketType.price;
                        newTicket.ticketDiscountId = newTicket.ticketType.ticketDiscountId;
                        newTicket.promoCode = newTicket.ticketType.promoCode;
                    }

                    if (newTicket.purchasedQuantity) {
                        newTicket.quantity = newTicket.quantity - newTicket.purchasedQuantity;
                        newTicket.quantity = newTicket.quantity.toString();
                    }

                    newTicketList.push(newTicket);
                })

                newRegistrant.ticketList = newTicketList;
            }

            if (registrant.additionalInfoList) {
                let newAdditionalInfoList = [];
                // Convert all the values into strings
                registrant.additionalInfoList.forEach(additionalInfo => {
                    let newAdditionalInfo = Object.assign({}, additionalInfo);
                    if (newAdditionalInfo.formField.type === 'Checkbox' && newAdditionalInfo.value !== undefined) {
                        newAdditionalInfo.value = newAdditionalInfo.value.toString();
                    } else if (newAdditionalInfo.formField.type === 'Multi-Picklist' && newAdditionalInfo.value) {
                        newAdditionalInfo.value = newAdditionalInfo.value.join(';');
                    }

                    newAdditionalInfoList.push(newAdditionalInfo);
                })

                newRegistrant.additionalInfoList = newAdditionalInfoList;
            }

            resultList.push(newRegistrant);
        })

        if (this._hasContact && this.isContactInfoChanged()) {
            resultList[0].hasInterim = true;

            if (this._registrantList[0].firstName !== this._contactRegistrant.firstName
                    || this._registrantList[0].lastName !== this._contactRegistrant.lastName) {
                resultList[0].contactId = '';
            }
        }

        return resultList;
    }

    isContactInfoChanged() {
        let primaryRegistrant = this._registrantList[0];

        if (!this._contactRegistrant || !primaryRegistrant) {
            return false;
        }

        if (primaryRegistrant.firstName !== this._contactRegistrant.firstName
                || primaryRegistrant.lastName !== this._contactRegistrant.lastName
                || primaryRegistrant.email !== this._contactRegistrant.email
                || primaryRegistrant.phone !== this._contactRegistrant.phone
                || primaryRegistrant.employer !== this._contactRegistrant.employer
                || primaryRegistrant.street1 !== this._contactRegistrant.street1
                || primaryRegistrant.street2 !== this._contactRegistrant.street2
                || primaryRegistrant.city !== this._contactRegistrant.city
                || primaryRegistrant.state !== this._contactRegistrant.state
                || primaryRegistrant.country !== this._contactRegistrant.country
                || primaryRegistrant.postalCode !== this._contactRegistrant.postalCode) {
            return true;
        }

        return false;
    }

    initializeRegistrantList(registrantList) {
        let resultList = [];

        let ticketTypeIdToTicketTypeMap = {};
        let formFieldIdToFormField = {};

        if (this._ticketTypeList) {
            this._ticketTypeList.forEach(ticketType => {
                ticketTypeIdToTicketTypeMap[ticketType.id] = ticketType;
            })
        }

        if (this._customFormFields) {
            this._customFormFields.forEach(formField => {
                formFieldIdToFormField[formField.Id] = formField;
            })
        }

        registrantList.forEach(registrant => {
            let newRegistrant = Object.assign(this.createNewRegistrant(resultList.length), registrant);

            if (!newRegistrant.interimId && newRegistrant.contactId) {
                newRegistrant.hasInterim = false;
            }

            newRegistrant.ticketList = this.createTicketList();

            if (registrant.ticketList) {
                let ticketTypeIdToTicketMap = {};
                registrant.ticketList.forEach(ticket => {
                    let newTicket = Object.assign({}, ticket);
                    newTicket.isHidden = false;

                    if (newTicket.ticketTypeId && ticketTypeIdToTicketTypeMap[newTicket.ticketTypeId]) {
                        newTicket.ticketType = ticketTypeIdToTicketTypeMap[newTicket.ticketTypeId];

                        if (newTicket.price < newTicket.ticketType.price) {
                            newTicket.ticketType.discountedPrice = newTicket.price;
                            newTicket.ticketType.price = newTicket.price;
                            newTicket.ticketType.ticketDiscountId = newTicket.ticketDiscountId
                        }

                        if (newTicket.purchasedQuantity) {
                            newTicket.quantity = newTicket.quantity + newTicket.purchasedQuantity;
                            newTicket.min = newTicket.purchasedQuantity;
                            // cannot delete a guest that the user has already purchased tickets for
                            newRegistrant.isRemovable = false;
                        } else {
                            newTicket.min = 0;
                        }

                        newTicket.quantityInPossession = newTicket.quantity;

                        if (newTicket.quantity && newTicket.ticketType.maxTickets) {
                            newTicket.max = newTicket.quantity + newTicket.ticketType.maxTickets;
                        }

                        newTicket.quantity = newTicket.quantity.toString();

                        if (newTicket.quantity) {
                            newTicket.isSelected = true;
                        }
                    }

                    ticketTypeIdToTicketMap[newTicket.ticketTypeId] = newTicket;
                })

                for (let ticketIndex = 0; ticketIndex < newRegistrant.ticketList.length; ticketIndex++) {
                    let ticket = newRegistrant.ticketList[ticketIndex];

                    if (ticketTypeIdToTicketMap[ticket.ticketTypeId]) {
                        newRegistrant.ticketList[ticketIndex] = ticketTypeIdToTicketMap[ticket.ticketTypeId];
                    }
                }
            }

            if (registrant.additionalInfoList) {
                newRegistrant.additionalInfoList = [];

                registrant.additionalInfoList.forEach(additionalInfo => {
                    let newAdditionalInfo = Object.assign({}, additionalInfo);

                    if (newAdditionalInfo.customFormFieldId) {
                        newAdditionalInfo.formField = formFieldIdToFormField[newAdditionalInfo.customFormFieldId];
                    }

                    if (newAdditionalInfo.formField.type === 'Checkbox') {
                        newAdditionalInfo.value = newAdditionalInfo.value === 'true';
                    } else if (newAdditionalInfo.formField.type === 'Multi-Picklist') {
                        let valueString = newAdditionalInfo.value;
                        newAdditionalInfo.value = [];

                        if (valueString) {
                            newAdditionalInfo.value = valueString.split(';');
                        }
                    }
                    newAdditionalInfo.key = formFieldIdToFormField[newAdditionalInfo.customFormFieldId].name + Date.now();

                    newRegistrant.additionalInfoList.push(newAdditionalInfo);
                })
            }

            resultList.push(newRegistrant);
        })

        return resultList;
    }
    
    getCookie(name) {
        let cookies = document.cookie.split(';');
        let cookieValue;

        cookies.forEach(cookie => {
            cookie = cookie.trim();
            if (cookie.indexOf(name) === 0) {
                cookieValue = cookie.substring(name.length + 1, cookie.length);
            }
        });

        return cookieValue

    }

    setCookie(name) {
        let expDate = new Date();
        expDate.setTime(expDate.getTime() + (1 * 24 * 60 * 60 * 1000));
        let expires = 'expires=' + expDate.toUTCString();
        let value = window.crypto.getRandomValues(new Uint32Array(10)).join() + Date.now();

        document.cookie = name + '=' + value + ';' + expires + ';path=/';

        return value;
    }
    
    // each registrant needs to have >= 1 ticket total and satisfy each ticket's min constraint
    isCurrentTicketAmountsValid() {
        let errorMessage = '';

        this._registrantList.forEach((eachRegistrant, index) => {
            if (errorMessage) {
                return;
            }

            let registrantTotalTickets = 0;
            let registrantName = `${eachRegistrant.firstName} ${eachRegistrant.lastName}`.trim() || eachRegistrant.nameTag || `Registrant ${index + 1}`; 

            for (const eachTicket of eachRegistrant.ticketList) {
                if (eachTicket.isHidden || !eachTicket.isSelected) {
                    continue;
                }

                let ticketQuantity = eachTicket.quantity ? parseInt(eachTicket.quantity, 10) : 0;
                if (ticketQuantity < eachTicket.min) {
                    let ticketName = eachTicket.ticketTypeName || eachTicket.ticketType.name;
                    // remove ending 'ticket' or 'tickets' to prevent grammatical weirdness
                    ticketName = ticketName.trim().replace(/\s*tickets?$/i, '') + ' ticket(s)';
                    errorMessage = `${registrantName} should have at least ${eachTicket.min} ${ticketName}`;
                    return;
                }
    
                registrantTotalTickets += ticketQuantity;
            }

            if (registrantTotalTickets == 0) {
                errorMessage = `${registrantName} should have at least 1 ticket`;
                return;
            }
        });

        if (errorMessage) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message: errorMessage,
                variant: "error",
                mode: "sticky"
            }));
            return false;
        }

        return true;
    }

    isRegistrationValid() {
        let hasValidInputs = true;
        if (this._currentPageIndex == 0) {
            let registrantForm = this.template.querySelector('c-portal_-event-registrant-form');
            hasValidInputs = registrantForm.checkInputValidity();
        } else {
            let registrationFormPage = this.template.querySelector('c-portal_-event-registration-form-page');
            hasValidInputs = registrationFormPage.checkInputValidity();
        }

        return hasValidInputs && this.isCurrentTicketAmountsValid();
    }

    handleTicketTypeSoldOut() {
        if (!this._ticketAvailabilityMap || !this._ticketTypeList) {
            return;
        }

        this._ticketTypeList.forEach(ticketType => {
            if ((this._ticketAvailabilityMap[ticketType.id] <= 0 && !this._ticketTypesWithTicketsInCart.includes(ticketType.id))
            || (this._ticketAvailabilityMap.totalTickets <= 0 && this._ticketTypesWithTicketsInCart.length === 0)) {
                ticketType.isSoldOut = true;
                ticketType.isWaitlist = true;
            }

            if (ticketType.isNotForSale) {
                ticketType.isWaitlist = false;
                ticketType.isSoldOut = true;
            }
        });
    }

    isTicketTypeNotForSale(ticketType) {
        if ((ticketType.Sales_Start_Date_Time__c && Date.parse(ticketType.Sales_Start_Date_Time__c) > Date.now())
                || (ticketType.Sales_End_Date_Time__c && Date.parse(ticketType.Sales_End_Date_Time__c) < Date.now())) {
            return true;
        }

        return false;
    }

    handleWaitlistClick = (event) => {
        let ticketTypeId = event.target.dataset.id;
        this._ticketTypeIdForWaitlist = ticketTypeId;

        for (let eachTicketType of this._ticketTypeList) {
            if (eachTicketType.id !== ticketTypeId) {
                continue;
            }

            if (this._listing.Number_of_Guests__c != null
                    && this._listing.Number_of_Guests__c != undefined
                    && eachTicketType.maxTickets) {
                this._waitlistMax = (this._listing.Number_of_Guests__c + 1) * eachTicketType.maxTickets;
                break;
            }
        }

        this._showWaitlistModal = true;
    }

    applyTicketDiscounts(ticketDiscountMap) {
        if (!this._ticketTypeList) {
            return;
        }

        this._ticketTypeList.forEach(ticketType => {
            if (ticketDiscountMap[ticketType.id]) {
                let discountedPriceMap = ticketDiscountMap[ticketType.id];

                if (ticketType.price > discountedPriceMap.discountPrice) {
                    ticketType.discountedPrice = discountedPriceMap.discountPrice;
                    ticketType.price = discountedPriceMap.discountPrice;
                    ticketType.ticketDiscountId = discountedPriceMap.ticketDiscountId;
                    ticketType.isDiscounted = true;
                }
            }
        })
    }

    parseOrgSettings(orgSettings) {
        if (!orgSettings) {
            return;
        }

        orgSettings.forEach(setting => {
            if (setting.DeveloperName === 'Is_Event_Guest_Registration_Modifiable') {
                this._isGuestRegistrationModifiable = setting.Value__c === 'true';
            }
        })
    }

    parseAdditionalInfoForRegistrant(registrant, registrantIndex) {
        if (!registrant || !registrant.additionalInfoList) {
            return;
        }

        let newAdditionalInfoList = [];

        registrant.additionalInfoList.forEach(additionalInfo => {
            if (!additionalInfo.formField.ticketTypeId
                    && (additionalInfo.formField.isDisplayToGuests || registrantIndex === 0)) {
                newAdditionalInfoList.push(additionalInfo);
            }
        })

        registrant.additionalInfoList = newAdditionalInfoList;
    }

    hasTicketsPurchased() {
        for (let registrant of this._registrantList) {
            if (registrant.ticketList) {
                for (let ticket of registrant.ticketList) {
                    if (!ticket.quantity) {
                        continue;
                    }

                    let quantity = ticket.quantity;

                    if (ticket.purchasedQuantity) {
                        quantity = quantity - ticket.purchasedQuantity;
                    }

                    if (quantity > 0) {
                        return true;
                    }
                }
            }
        }

        return false;
    }

    handleTermsAndConditions = (event) => {
        this._isTermsAndConditionsChecked = event.target.checked;
    }

    hasTicketTypesForSale() {
        if (!this._ticketTypeList) {
            return false;
        }

        for (let eachTicketType of this._ticketTypeList) {
            if (!eachTicketType.isNotForSale && !eachTicketType.isSoldOut) {
                return true;
            }
        }

        return false;
    }
}