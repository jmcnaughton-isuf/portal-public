import { LightningElement, api, track } from 'lwc';
import SERVER_getContentModuleMetadata  from '@salesforce/apex/PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata';

export default class Portal_LargeIconCTABlock extends LightningElement {
    @api pageName;
    @api moduleName;
    @api iconsPerRow = 4;
    @api iconSize = '232px';
    @api zoneName;

    @track _contentModuleMetadata;

    get listClass() {
        return 'list col-' + this.iconsPerRow;
    }

    get iconStyle() {
        return 'height: ' + this.iconSize;
    }

    connectedCallback() {
        SERVER_getContentModuleMetadata({params: {pageName: this.pageName,
                                                  moduleName: this.moduleName,
                                                  zone: this.zone}}).then(result => {
            console.log(JSON.stringify(result));
            this._contentModuleMetadata = result;
        }).catch(error => {
            console.log(error);
        })
    }
}