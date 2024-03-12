import { api, LightningElement } from 'lwc';
import getGivingSocietyDetail from '@salesforce/apex/PORTAL_GivingSocietiesDetailPage.SERVER_getGivingSocietyDetailPage';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_GivingSocietiesDetailPage extends LightningElement {

    @api givingPageURL;
    @api givingLinkText;

    givingSocietyData = {};
    permissionMap = {}
    initDone = false
    showLevels = false
    givingSocietyName = null;

    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        this.givingSocietyName = urlParams.get('gsname');
        this.getGivingSocietyDetailPage();
    }

    getGivingSocietyDetailPage() {
        getGivingSocietyDetail({'paramMap' : {'givingSocietyName' : this.givingSocietyName}})
        .then(result => {

            if (result['records']) {
                this.givingSocietyData = result['records'][0];
            }

            this.permissionMap = result['permissionMap'];
            this.initDone = true;

            this.showLevels = (this.permissionMap.membershipLevels.display && this.givingSocietyData.ucinn_ascendv2__Membership_Levels_Giving_Society__r.length > 0);
        })
        .catch(error => {
            try {
                console.log(error);
                let errorMap = JSON.parse(error.body.message);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: errorMap.message,
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            } catch (e) {
                return;
            }
        })
    }

    get showGivingLink() {
        return this.givingPageURL && this.givingLinkText;
    }

    givingButtonClicked() {
        window.open(this.givingPageURL,'_blank');
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