import { LightningElement, api, track } from 'lwc';
import { ComponentLogic, ComponentLogicBuilder } from './portal_MyClassNotesHelper';
export * from './portal_MyClassNotesHelper';

export default class Portal_MyClassNotes extends LightningElement {
    @track _isShowSpinner = false;
    @track _isDisplay = false;
    @track _isDataLoaded = false;

    @track componentLogic = undefined;
    @track componentAttributes = {};

    get sectionConfiguration() {
        return this.componentAttributes.sectionConfiguration || {};
    }

    get recordList() {
        return this.componentAttributes.recordList;
    }

    get columnMappings() {
        return this.componentAttributes.columnMappings;
    }

    get noResultsText() {
        return this.componentAttributes.noResultsText;
    }

    get itemsPerPage() {
        return this.componentAttributes.itemsPerPage || 10;
    }

    connectedCallback() {
        this.setup();
    }

    setup() {
        if (this._isDataLoaded) {
            return;
        }
        
        const pageName = 'Class Notes';
        const mainSectionName = 'Content Submission Form';
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
                                                         .buildPageName(pageName)
                                                         .buildMainSectionName(mainSectionName)
                                                         .build();

        this.componentLogic.getComponentData();
        this._isDataLoaded = true;
    }
}