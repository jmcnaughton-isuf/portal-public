import { LightningElement, api, wire, track } from 'lwc';
import getContentModuleTemplateList from '@salesforce/apex/PORTAL_LWC_EditContentModuleController.SERVER_getContentModuleTemplateList';
import getContentModule from '@salesforce/apex/PORTAL_LWC_EditContentModuleController.SERVER_getContentModuleByRecordId';
import saveContentModule from '@salesforce/apex/PORTAL_LWC_EditContentModuleController.SERVER_saveContentModule';

export default class Portal_quickaction_EditContentModuleMetadata extends LightningElement {
    @api recordId;

    @track _showSpinner = false;
    @track _renderComponent = false;
    @track _templateList = [{label: "Select an LWC", value: ""}];
    @track _templateToMetadataMap = {};

    @track _metadataToDisplay;

    @track _template;
    @track _metadata;
    @track _metadataCopy;

    @wire(getContentModuleTemplateList)
    setContentModuleList({error, data}) {
        if (error) {
            let errorMap = JSON.parse(error);
            alert(errorMap.message);
            console.log(errorMap.error);
        }

        if (data) {
            data.forEach(template => {
                let newTemplate = {};

                newTemplate.label = template.LWC_Name__c;
                newTemplate.value = template.LWC_Name__c;

                this._templateList.push(newTemplate);

                let metadata = JSON.parse(template.Metadata_Template__c);

                this._templateToMetadataMap[template.LWC_Name__c] = metadata;

                getContentModule({params: {recordId: this.recordId}}).then(result => {
                    this._template = result.Related_LWC__c;
                    this.populateMetadata(result.Content_Module_Metadata__c);
                    this._renderComponent = true;
                })
            })
        }
    }

    populateMetadata(metadataString) {
        try {
            this._metadataToDisplay = this._templateToMetadataMap[this._template];
            this._metadata = JSON.parse(metadataString)
        } catch (e) {
            this._metadata = this._metadataToDisplay
        }
        this._metadataCopy = this._metadata;
    }

    handleTemplateChange = (event) => {
        this._template = event.target.value;
        this._metadataToDisplay = this._templateToMetadataMap[this._template];
        this._metadata = this._metadataToDisplay;
        this._metadataCopy = this._metadataToDisplay;
    }

    handleMetadataChange = (metadata) => {
        this._metadataCopy = metadata;
    }

    handleSave() {
        this._showSpinner = true;

        // TODO: change error handling
        saveContentModule({params: {contentModuleMetadata: JSON.stringify(this._metadataCopy),
                                    lwcName: this._template,
                                    recordId: this.recordId}}).then((result) => {
            if (result === 'SUCCESS') {
                location.reload();
            } else {
                alert(result);
            }
        });
    }

    handleCancel() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA)
    }
}