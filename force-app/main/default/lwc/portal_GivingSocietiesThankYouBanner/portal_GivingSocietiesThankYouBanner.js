import { api, LightningElement } from 'lwc';
import checkIfInGivingSociety from '@salesforce/apex/PORTAL_GivingSocietiesBannerController.SERVER_isConstituentInGivingSocieties';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_GivingSocietiesThankYouBanner extends LightningElement {
    @api displayTextHTML;
    @api backgroundColor;
    givingSocietyName = null;
    showText = false;
    initDone = false;
    permissionMap = {};

    bannerTextHTML = '';

    connectedCallback() {
        // check URL and see if we narrow down any giving societies
        document.documentElement.style.setProperty('--backgroundColor', this.backgroundColor);

        const urlParams = new URLSearchParams(window.location.search);

        if (urlParams.get('gsname')) {
            this.givingSocietyName = urlParams.get('gsname');
        }

        this.checkIfInGivingSocieties()
    }

    checkIfInGivingSocieties() {
        checkIfInGivingSociety({'paramMap' :
                                {'givingSocietyName' : this.givingSocietyName,
                                 'bannerText' : this.displayTextHTML}})
        .then( result => {
            console.log('R: ' + JSON.stringify(result));
            if (result == null) {
                return;
            }

            if (result['bannerText']) {
                this.bannerTextHTML = result['bannerText'];
            } else {
                this.bannerTextHTML = this.displayTextHTML;
            }

            this.showText = result['returnValue'];
            this.permissionMap = result['permissionMap'];
            this.initDone = true;
        })
        .catch( error => {
            this.showNotification('Error', error.body.message, 'error');
        });
    }

    get showBanner() {
        return this.showText && this.permissionMap.givingSocietiesBanner.display;
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        this.dispatchEvent(evt);
    }

}