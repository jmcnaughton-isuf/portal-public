import { LightningElement, api, track } from 'lwc';
import SERVER_getContentModuleMetadata  from '@salesforce/apex/PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata';

export default class Portal_Quotation extends LightningElement {
    @api pageName;
    @api moduleName;
    @api buttonsPerRow = 5;
    @api zoneName;

    @track _contentModuleMetadata;

    get listClass() {
       return 'list col-' + this.buttonsPerRow;
    }

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