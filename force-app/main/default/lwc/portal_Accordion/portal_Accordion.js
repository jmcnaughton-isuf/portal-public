import { LightningElement, api, track } from 'lwc';
import SERVER_getContentModuleMetadata  from '@salesforce/apex/PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata';

export default class Portal_Accordian extends LightningElement {
    @api pageName;
    @api moduleName;
    @api zoneName;

    @track _contentModuleMetadata;

    connectedCallback() {
        SERVER_getContentModuleMetadata({params: {pageName: this.pageName,
                                                  moduleName: this.moduleName,
                                                  zone: this.zone}}).then(result => {
            this._contentModuleMetadata = Object.assign({}, result);
            let newItems = [];

            this._contentModuleMetadata.items.forEach(item => {
                item = Object.assign({}, item);
                if (item.isOpen === 'true') {
                    item.class = 'accordion-item active';
                } else {
                    item.isOpen = false;
                    item.class = 'accordion-item';
                }
                newItems.push(item);
            });

            this._contentModuleMetadata.items = newItems;
        }).catch(error => {
            console.log(error);
        })

    }

    handleClick(event) {
        let index = event.target.dataset.index;

        let accordionItem = this._contentModuleMetadata.items[index];
        
        if (accordionItem.isOpen) {
            accordionItem.isOpen = false;
            accordionItem.class = 'accordion-item';
        } else {
            accordionItem.isOpen = true;
            accordionItem.class = 'accordion-item active';
        }
    }
}