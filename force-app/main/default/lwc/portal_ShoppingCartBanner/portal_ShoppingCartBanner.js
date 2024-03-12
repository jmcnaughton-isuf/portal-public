import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import checkForTicketsInShoppingCart from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_checkForTicketsInShoppingCart';

export default class Portal_ShoppingCartBanner extends LightningElement {
    @track showBanner = false;
    @track sessionExpirationDate;
    @track _bannerText = 'There are tickets in your shopping cart!';

    connectedCallback() {
        this.cookieId = this.getCookie('PORTAL_EVENT_SHOPPING_CART_ID');

        if (this.cookieId) {
            checkForTicketsInShoppingCart({params: {cookieId : this.cookieId}})
            .then(res => {
                if (res.valid && !window.location.pathname.includes('shopping-cart') && !window.location.pathname.includes('event-payment-form')) {
                    this.sessionExpirationDate = res.expirationDate;
                    this.showBanner = true;
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

    handleExpiration = () => {
        this._bannerText = '';

        let banner = this.template.querySelector('.banner.hide-on-phone');
        banner.classList.toggle('currently-expired');
    }

    handleNavigateToShoppingCart () {
        window.location.href = './shopping-cart';
    }

    handleCloseBanner () {
        this.showBanner = false;
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