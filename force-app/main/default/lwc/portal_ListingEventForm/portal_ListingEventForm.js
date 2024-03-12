import { LightningElement } from 'lwc';

import experienceBuilderId from '@salesforce/community/Id';
import basePath from '@salesforce/community/basePath';


export default class Portal_ListingEventForm extends LightningElement {
    connectedCallback() {
        console.log(experienceBuilderId);
        console.log(basePath);
    }
}