import { LightningElement } from 'lwc';
import getDonorStoryDetail from '@salesforce/apex/PORTAL_DonorStoryDetailController.SERVER_getDonorStoryDetail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_DonorStoriesDetailPage extends LightningElement {

    donorStoryName;
    donorStoryInfo = {};
    permissionMap = {};
    initDone = false;

    connectedCallback() {

        const urlParams = new URLSearchParams(window.location.search);

        if (urlParams.get('dsname')) {
            this.donorStoryName = urlParams.get('dsname');
        }

        this.getDonorStoryDetailInfo();
    }

    getDonorStoryDetailInfo() {
        getDonorStoryDetail({'paramMap' : {'donorStoryName' : this.donorStoryName}})
        .then(result => {
            let records = result['records'];

            if (records) {
                this.donorStoryInfo = records[0];
            }

            this.permissionMap = result['permissionMap'];
            this.initDone = true;
        })
        .catch(error => {
            this.showNotification('Error', error.body.message, 'error');
        });
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