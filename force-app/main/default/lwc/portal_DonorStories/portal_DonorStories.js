import { api, LightningElement } from 'lwc';
import getDonorStories from '@salesforce/apex/PORTAL_DonorStoriesController.SERVER_getDonorStories';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_DonorStories extends LightningElement {

    donorStories = [];
    permissionMap = {};
    initDone = false;
    @api numOfItemsToShow;
    @api donorStoryDetailPage;
    givingSocietyName = null;


    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);

        if (urlParams.get('gsname')) {
            this.givingSocietyName = urlParams.get('gsname');
        }

        this.getDonorStories();
    }

    getDonorStories() {
        getDonorStories({'paramMap' : {'numOfItemsToShow' : this.numOfItemsToShow, 'givingSocietyName' : this.givingSocietyName,
                                        'givingSocietyDetailPageURL' : this.donorStoryDetailPage}})
        .then( result => {
            this.donorStories = result['records'];
            this.permissionMap = result['permissionMap'];
            this.initDone = true;
        })
        .catch( error => {
            this.showNotification('Error', error.body.message, 'error');
        });
    }

    get showDonorStories() {
        return this.initDone && this.donorStories.length > 0;
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