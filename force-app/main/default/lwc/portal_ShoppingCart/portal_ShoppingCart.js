import { LightningElement, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getParticipationsMapInSession from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_getParticipationsMapInSession';
import deleteRegistrationForEvent from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_deleteRegistrationForEvent';
import modifyRegistrationStatusAndExtendExpirationDate from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_modifyRegistrationStatusAndExtendExpirationDate';

export default class Portal_ShoppingCart extends LightningElement {
    @track itemsInShoppingCart;
    @track eventList;
    @track totalPrice;
    @track disableButtons = false;
    @track showSpinner = true;

    cookieId;
    isValidSession;
    sessionExpirationDate;

    currentStatus = 'In Shopping Cart';
    nextStatus = 'Pending Payment';
    showModificationButtons = true;

    connectedCallback() {
        this.cookieId = this.getCookie('PORTAL_EVENT_SHOPPING_CART_ID');

        if (this.cookieId) {
            this.showSpinner = true;
            let eventListingsMap = new Map();
            let totalTicketPrices = 0.0;

            getParticipationsMapInSession({params: {cookieId: this.cookieId,
                                                    currentStatus: this.currentStatus}})
            .then(res => {
                if (res.participationList && res.participationList.length > 0) {  // valid session exists with participations
                    res.participationList.forEach(participation => {
                        totalTicketPrices = totalTicketPrices + participation.ticketCost;

                        // If event name is already in map, then append ticket to ticket list for that event
                        if (eventListingsMap.has(participation.eventName)) {
                            let participationsForOneEvent = eventListingsMap.get(participation.eventName);
                            participationsForOneEvent.push(participation);
                            eventListingsMap.set(participation.eventName, participationsForOneEvent);
                        } else {  // if event name not inside in map, then we create new map entry
                            let participationsForOneEvent = [];
                            participationsForOneEvent.push(participation);

                            eventListingsMap.set(participation.eventName, participationsForOneEvent);
                        }

                        if (participation.ticketList) {
                            participation.ticketList.forEach(ticket => {
                                ticket['pricePerTicketString'] = '$' + ticket.pricePerTicket.toFixed(2);
                            })
                            participation.ticketList = Array.from(participation.ticketList);
                        }
                    });

                    this.eventList = Array.from(eventListingsMap, ([eventName, participationsPerEvent]) => ({eventName, participationsPerEvent}));
                    this.totalPrice = '$' + totalTicketPrices.toFixed(2);
                    this.sessionExpirationDate = res.expirationDate;
                    this.itemsInShoppingCart = true;
                } else {  // not a valid session meaning no tickets
                    this.itemsInShoppingCart = false;
                }
                this.showSpinner = false;
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

    handleDeleteRegistrationForEvent = (primaryParticipationId) => {
        this.showSpinner = true;
        deleteRegistrationForEvent({params: {primaryParticipation: primaryParticipationId}})
        .then(() => {
            this.connectedCallback();
        })
        .catch(e => {
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

    handleEventModification = (eventId, primaryParticipationId) => {
        window.location.href = './event-registration?recordId='
                                + eventId
                                + '&participationId='
                                + primaryParticipationId;
    }

    handleCheckoutButton = () => {
        modifyRegistrationStatusAndExtendExpirationDate({params: {
            cookieId: this.cookieId,
            currentStatus: this.currentStatus,
            nextStatus: this.nextStatus
        }})
        .then(() => {
            window.location.href = './event-payment-form';
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

    handleDisableButtons () {
        this.disableButtons = true;
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
}