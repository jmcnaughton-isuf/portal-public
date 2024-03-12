import { LightningElement, api, track } from 'lwc';
import { ComponentLogic, ComponentLogicBuilder } from './portal_FileDownloadHelper';
export * from './portal_FileDownloadHelper';

export default class Portal_FileDownload extends LightningElement {
    @api title;
    @api componentName;

    componentLogic = undefined;

    @track isShowSpinner = true;
    @track isShowTable = false;
    @track records = undefined;

    connectedCallback() {
        this.setup();
    }

    setup() {
        this.componentLogic = new ComponentLogicBuilder()
            .buildLightningElement(this)
            .buildComponentName(this.componentName)
            .build();
        this.componentLogic.getComponentData();
    }

    get isShowComponent() {
        return this.isShowSpinner || this.isShowTable;
    }

    get columnMappings() {
        return this.componentLogic.columnMappings;
    }
}