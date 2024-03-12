import { LightningElement, api, track } from 'lwc';
import SERVER_getContentModuleMetadata  from '@salesforce/apex/PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata';

export default class Portal_HtmlEditor extends LightningElement {
    @api pageName;
    @api moduleName;
    @api zoneName;

    @track _contentModuleMetadata;

    connectedCallback() {
        SERVER_getContentModuleMetadata({params: {pageName: this.pageName,
                                                  moduleName: this.moduleName,
                                                  zone: this.zone}}).then(result => {
            this._contentModuleMetadata = Object.assign({}, result);

            if (this._contentModuleMetadata.ctaBlocks) {
                let isOdd = true;
                let newCtaBlocks = [];
                this._contentModuleMetadata.ctaBlocks.forEach(ctaBlock => {
                    let newCtaBlock = Object.assign({}, ctaBlock);
                    if (ctaBlock.imagePosition && ctaBlock.imagePosition.toLowerCase() === 'left') {
                        newCtaBlock.class = 'grid large text-right cta-block'
                    } else if (ctaBlock.imagePosition && ctaBlock.imagePosition.toLowerCase() === 'right') {
                        newCtaBlock.class = 'grid large text-left cta-block'
                    } else {
                        newCtaBlock.class = 'grid large text-right cta-block'
                    }

                    if (isOdd) {
                        newCtaBlock.style = 'background-color: white';
                    } else {
                        newCtaBlock.style = 'background: #f7f7f7';
                    }

                    newCtaBlock.key = Date.now();

                    newCtaBlocks.push(newCtaBlock);
                    isOdd = !isOdd;
                })

                this._contentModuleMetadata.ctaBlocks = newCtaBlocks;
            }
        }).then(error => {
            console.log(error);
        })
    }
}