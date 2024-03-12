import { LightningElement, api, track } from 'lwc';
import SERVER_getContentModuleMetadata  from '@salesforce/apex/PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata';

export default class Portal_HeaderCTABlock extends LightningElement {
    @api pageName;
    @api moduleName;
    @api zoneName;

    @track _contentModuleMetadata;

    connectedCallback() {
        SERVER_getContentModuleMetadata({params: {pageName: this.pageName,
                                                  moduleName: this.moduleName,
                                                  zone: this.zone}}).then(result => {
            this._contentModuleMetadata = result;
        }).catch(error => {
            console.log(error);
        })
    }
}