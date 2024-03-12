import { LightningElement, api, track } from 'lwc';
import SERVER_getContentModuleMetadata  from '@salesforce/apex/PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata';

export default class Portal_Dashboard extends LightningElement {
    @api pageName;
    @api moduleName;
    @api iconsPerRow = 5;
    @api buttonsPerRow = 4;
    @api zoneName;

    @track _contentModuleMetadata;

    get buttonLayoutSize() {
        if (this.buttonsPerRow) {
            return 12/this.buttonsPerRow
        }

        return 3;
    }

    get iconListClass() {
        return 'list col-' + this.iconsPerRow + ' bottom-border';
    }

    get buttonListClass() {
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