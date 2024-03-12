import { LightningElement, track, api, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getParticipationsMapInSession from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_getParticipationsMapInSession';
import eventPaymentCheckout from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_eventPaymentCheckout';
import handleUniquePaymentSession from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_handleUniquePaymentSession';
import handlePaymentPageExit from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_handlePaymentPageExit';
import isChargeCreditCard from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_isChargeCreditCard';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { publish, MessageContext } from 'lightning/messageService';
import recaptchaChannel from '@salesforce/messageChannel/recaptchaChannel__c';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_EventPaymentForm extends LightningElement {
    // design attributes
    @api addressRequired;
    @api emailTemplateDeveloperName;
    @api pageName = 'Event Payment Form';
    @api paymentMethod;
    @api apiKeyCMDDeveloperName; // mdt name
    @api secretKeyCMDDevelopername;
    @api externalGatewayName;
    
    @track _isRecaptchaEnabled = true;
    @track eventList;
    @track ticketList;
    @track confirmedEventList;
    @track totalPrice;
    @track registrantInformation;
    @track disablePaymentForm = false;
    @track showSpinner = false;
    @track showConfirmation = false;
    @track _showPaymentsPage = true;
    _isProcessing = false;

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_ShoppingCartControllerBase.eventPaymentCheckout'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    @wire(MessageContext) messageContext;

    cookieId;
    sessionExpirationDate;
    expirationBufferIncrementInSeconds = 10; // to sync frontend timer with backend after apex controller adds a buffer

    currentStatus = 'Pending Payment';
    previousStatus = 'In Shopping Cart';

    // ------------payment stuff------------
    @track showCreditCardComponent = false;
    _amount = 0;
    _billingInformation = {};
    _giftType = 'event';

    get amountString() {
        return this._amount.toString();
    }

    get isNonZeroAmount() {
        if (this._amount > 0) {
            return true;
        }

        return false;
    }

    get isDisplayRecaptchaForFreeTickets() {
        return this._isRecaptchaEnabled && !this.isNonZeroAmount;
    }

    get isShowRegistrationSubmitMessage() {
        // if it is touchnet, do not show message since there is no submit button
        return this.paymentMethod !== 'TouchNet';
    }

    get nextPageButtonText() {
        return this.isNonZeroAmount ? 'Next' : 'Submit';
    }

    get additionalMetadata() {
        if (this.paymentMethod === 'Stripe Payment Element') {
            return {
                params: {
                    sessionId: this.sessionId,
                    amount: this._amount,
                    registrantInformation: this.registrantInformation,
                    pageName: this.pageName
                }
            };
        }
    }

    get paymentOrigin() {
        if (this.paymentMethod === "TouchNet") {
            return 'eventsTicketName';
        } else {
            return 'eventsPaymentElement'
        }
    }

    connectedCallback() {
        this.showSpinner = true;

        this.cookieId = this.getCookie('PORTAL_EVENT_SHOPPING_CART_ID');

        handleUniquePaymentSession({params: {cookieId: this.cookieId}})
        .then(result => {
            if (result) {
                window.addEventListener('pagehide', this.onPageHideHandler.bind(this));
                return;
            }

            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'There was an issue getting your payment information.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this._showPaymentsPage = false;
        })

        if (this.cookieId) {
            let eventToTicketsMap = new Map();
            let ticketMapping = new Map();
            let totalTicketPrices = 0.0;

            let firstName = '';
            let lastName = '';
            let email = '';
            let addressLine1 = '';
            let addressLine2 = '';
            let city = '';
            let state = '';
            let country = '';
            let postalCode = '';

            getParticipationsMapInSession({params: {cookieId: this.cookieId,
                                                    currentStatus: this.currentStatus}})
            .then(res => {
                if (res.participationList && res.participationList.length > 0) {  // valid session exists with participations
                    res.participationList.forEach(participation => {
                        totalTicketPrices = totalTicketPrices + participation.ticketCost;

                        // build event -> ticket mapping
                        if (!eventToTicketsMap.has(participation.eventId)) {
                            let obj = { 'Name': participation.eventName,
                                        'Event_Actual_Start_Date_Time__c': participation.eventStartDateTime,
                                        'Event_Actual_End_Date_Time__c' : participation.eventEndDateTime,
                                        'Time_Zone__c': participation.eventTimeZone,
                                        }
                            eventToTicketsMap.set(participation.eventId, obj);
                        }

                        // build ticket mapping
                        if (participation.ticketList) {
                            participation.ticketList.forEach(ticket => {
                                let groupedTicketName = participation.eventName + ' - ' + ticket.ticketType;

                                if (ticketMapping.has(groupedTicketName)) {
                                    let groupedTicketInfo = ticketMapping.get(groupedTicketName);

                                    let quantity = ticket.numberOfTickets + groupedTicketInfo.quantity;
                                    let price = (ticket.numberOfTickets * ticket.pricePerTicket) + groupedTicketInfo.price;
                                    let priceString = '$' + price.toFixed(2);

                                    let obj = { 'event': participation.eventName,
                                                'name': ticket.ticketType,
                                                'quantity': quantity,
                                                'price': price,
                                                'priceString': priceString}

                                    ticketMapping.set(groupedTicketName, obj);

                                } else {
                                    let quantity = ticket.numberOfTickets;
                                    let price = ticket.numberOfTickets * ticket.pricePerTicket;
                                    let priceString = '$' + price.toFixed(2);

                                    let obj = { 'event': participation.eventName,
                                                'name': ticket.ticketType,
                                                'quantity':ticket.numberOfTickets,
                                                'price': price,
                                                'priceString': priceString}

                                    ticketMapping.set(groupedTicketName, obj);
                                }
                            });
                        }
                    });

                    // get primary participation information
                    if (res.primaryParticipation) {
                        if (res.primaryParticipation.firstName) {
                            firstName = res.primaryParticipation.firstName;
                        }

                        if (res.primaryParticipation.lastName) {
                            lastName = res.primaryParticipation.lastName;
                        }

                        if (res.primaryParticipation.email) {
                            email = res.primaryParticipation.email;
                        }

                        if (res.primaryParticipation.addressLine1) {
                            addressLine1 = res.primaryParticipation.addressLine1;
                        }

                        if (res.primaryParticipation.addressLine2) {
                            addressLine2 = res.primaryParticipation.addressLine2;
                        }

                        if (res.primaryParticipation.addressCity) {
                            city = res.primaryParticipation.addressCity;
                        }

                        if (res.primaryParticipation.addressCity) {
                            city = res.primaryParticipation.addressCity;
                        }

                        if (res.primaryParticipation.addressState) {
                            state = res.primaryParticipation.addressState;
                        }

                        if (res.primaryParticipation.addressCountry) {
                            country = res.primaryParticipation.addressCountry;
                        }

                        if (res.primaryParticipation.addressPostalCode) {
                            postalCode = res.primaryParticipation.addressPostalCode;
                        }
                    }

                    this.ticketList = Array.from(ticketMapping, ([name, info]) => ({name, info}));
                    this.eventList = Array.from(eventToTicketsMap, ([eventId, ticketsForEvent]) => ({eventId, ticketsForEvent}));
                    this.totalPrice = '$' + totalTicketPrices.toFixed(2);
                    this._amount = parseFloat(totalTicketPrices.toFixed(2));

                    if (this._amount - totalTicketPrices > 0) {
                        this._amount = this._amount + .01;
                    }

                    this.sessionExpirationDate = res.expirationDate;
                    this.sessionId = res.sessionId;

                    this.registrantInformation = {
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        addressLine1: addressLine1,
                        addressLine2: addressLine2,
                        city: city,
                        state: state,
                        country: country,
                        postalCode: postalCode
                    }

                    this.showSpinner = false;
                } else {  // if empty, send back to shopping cart
                    window.location.href = './shopping-cart';
                }
            }).catch(e => {
                let errorMap = JSON.parse(e.body.message);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: errorMap.message,
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);

            });
        }
    }

    onPageHideHandler() {
        handlePaymentPageExit({params: {
            cookieId: this.cookieId
        }})
        .then().catch(e => {
            let errorMap = JSON.parse(e.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        });
    }

    validateRegistrantInformation() {
        if (this._isProcessing) {
            return;
        }
        this._isProcessing = true;

        // make sure all fields are filled out
        if (!this.isPaymentFormValid()) {
            this._isProcessing = false;
            publish(this.messageContext, recaptchaChannel, {type: "recaptcha-v2-reset"});
            return;
        }

        // validate amount just in case they change on front end
        isChargeCreditCard({params: {cookieId: this.cookieId,
                                        currentStatus: this.currentStatus,
                                        amount: this._amount
                                    }})
        .then((res) => {
            let expirationDate = new Date(this.sessionExpirationDate);
            expirationDate?.setSeconds(expirationDate.getSeconds() + this.expirationBufferIncrementInSeconds);
            this.sessionExpirationDate = expirationDate?.toISOString();
            // if valid amount, then show credit card component
            if (res) {
                this.createStripeBillingInformation();
                this._isProcessing = false;
                this.showCreditCardComponent = true;
            } else {  // if amount is zero, do not show credit card form
                this.showSpinner = true;
                submitForm(this, this.submissionLogicForZeroCostEvent, (error) => {
                    this._isProcessing = false;
                    this.showSpinner = false;
                    console.log(error);
                });
            }
        }).catch(e => {
            let errorMap = JSON.parse(e.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            publish(this.messageContext, recaptchaChannel, {type: "recaptcha-v2-reset"});
            this._isProcessing = false;
        });
    }    
    
    submissionLogicForZeroCostEvent = (recaptchaToken) => {
        const params = {cookieId: this.cookieId,
                        registrantInformation: this.registrantInformation,
                        developerName: this.emailTemplateDeveloperName,
                        chargeId: null,
                        amount: 0,
                        paymentMethod: this.paymentMethod,
                        recaptchaToken: recaptchaToken};

        callApexFunction(this, eventPaymentCheckout, params, () => {
            this._isProcessing = false;
            this.showConfirmation = true;
            this.showSpinner = false;
        }, (error) => {
            this._isProcessing = false;
            this.showSpinner = false;
            console.log(error);
            publish(this.messageContext, recaptchaChannel, {type: "recaptcha-v2-reset"});
        });
    }

    createStripeBillingInformation() {
        this._billingInformation['address'] = {};
        this._billingInformation['address']['city'] = this.registrantInformation.city;
        this._billingInformation['address']['line1'] = this.registrantInformation.addressLine1;
        this._billingInformation['address']['line2'] = this.registrantInformation.addressLine2;
        this._billingInformation['address']['postal_code'] = this.registrantInformation.postalCode;
        this._billingInformation['address']['state'] = this.registrantInformation.state;
        this._billingInformation['address']['country'] = this.registrantInformation.country;
        this._billingInformation['email'] = this.registrantInformation.email;

        if (this.paymentMethod == 'Cybersource') {
            this._billingInformation['firstName'] = this.registrantInformation.firstName;
            this._billingInformation['lastName'] = this.registrantInformation.lastName;
        }

        let name = this.registrantInformation.firstName + ' ' + this.registrantInformation.lastName;
        this._billingInformation['name'] = name;
    }

    handleRegistrantPaymentInput = (event) => {
        let value = event.target.value;
        let fieldName = event.target.name;

        this.registrantInformation[fieldName] = value;
    }

    handleDisablePayment() {
        this.showCreditCardComponent = false;
        this.disablePaymentForm = true;
    }

    handleCancel() {
        window.history.go(-1);
    }

    handlePaymentConfirmation = (params) =>  {
        if (this._isProcessing) {
            return;
        }
        this._isProcessing = true;

        this.showSpinner = true;
        eventPaymentCheckout({params: { cookieId: this.cookieId,
                                        registrantInformation: this.registrantInformation,
                                        developerName: this.emailTemplateDeveloperName,
                                        pageName: this.pageName,
                                        paymentId: params?.paymentId,
                                        additionalPaymentDataMap: params?.additionalPaymentDataMap,
                                        amount: this._amount,
                                        externalGatewayName: this.externalGatewayName,
                                        stripeBillingInformation: this._billingInformation,
                                        paymentMethod: this.paymentMethod,
                                        recaptchaToken: params?.recaptchaToken}})
        .then(() => {
            this.showSpinner = false;
            this.showConfirmation = true;
            this.handleDisablePayment();
        }).catch(e => {
            console.log(e);
            this.showSpinner = false;
            let errorMap = JSON.parse(e.body.message);

            // in case of error, reset recaptcha v2
            publish(this.messageContext, recaptchaChannel, {type: "recaptcha-v2-reset"});

            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this._isProcessing = false;
        });
    }

    isPaymentFormValid() {
        let eventPaymentForm = this.template.querySelector('c-portal_-event-payment-form');
        this.showPaymentForm = eventPaymentForm.checkInputValidity();
        return this.showPaymentForm;
    }

    getCookie(name) {
        let cookies = document.cookie.split(';');
        let cookieValue;

        cookies.forEach(cookie => {
            cookie = cookie.trim();
            if (cookie.indexOf(name) == 0) {
                cookieValue = cookie.substring(name.length + 1, cookie.length);
            }
        });

        return cookieValue;
    }

    handlePreviousButtonClick = (params) => {
        this.showCreditCardComponent = false;
    }
}