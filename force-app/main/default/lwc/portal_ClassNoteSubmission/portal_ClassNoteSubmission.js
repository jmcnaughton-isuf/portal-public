import { LightningElement, api, track } from 'lwc';
import { ComponentLogic, ComponentLogicBuilder } from './portal_ClassNoteSubmissionHelper';
export * from './portal_ClassNoteSubmissionHelper';

export default class Portal_ClassNoteSubmission extends LightningElement {
    @api contentModuleName = 'Confirmation';

    componentLogic = undefined;

    @track isShowSpinner = true;
    @track isDisplayComponent = false;
    @track isRecaptchaEnabled = false;
    @track recordId = undefined;
    @track currentPageIndex = undefined;
    @track frontEndDataMap = {};
    @track picklists = {};
    @track contentModuleMetadata = {};
    @track record = {};
    @track uploadedFileName = '';
    @track uploadedFileSrc = '';

    connectedCallback() {
        this.setup();
    }

    setup() {
        this.componentLogic = new ComponentLogicBuilder()
            .buildLightningElement(this)
            .buildContentModuleName(this.contentModuleName)
            .build();
        this.componentLogic.getComponentData();
    }

    get progressBarStepList() {
        return this.componentLogic.progressBarStepList(this.currentPageIndex);
    }

    get validFileTypes() {
        return ['.png', '.jpg', '.jpeg', '.svg', '.webp'];
    }    

    get isDisplayPersonalInfoPage() {
        return this.componentLogic.isDisplayPersonalInfoPage(this.currentPageIndex);
    }

    get isDisplayClassNoteContentPage() {
        return this.componentLogic.isDisplayClassNoteContentPage(this.currentPageIndex);
    }

    get isDisplayPreviewPage() {
        return this.componentLogic.isDisplayPreviewPage(this.currentPageIndex);    
    }

    get isDisplayImagePreview() {
        return this.componentLogic.isDisplayImagePreview();
    }

    get isDisplayConfirmationPage() {
        return this.componentLogic.isDisplayConfirmationPage(this.currentPageIndex);
    }

    get isDisplayBackButton() {
        return this.componentLogic.isDisplayBackButton(this.currentPageIndex);
    }
    
    get isDisplayNextButton() {
        return this.componentLogic.isDisplayNextButton(this.currentPageIndex);
    }

    get isDisplaySubmitButton() {
        return this.componentLogic.isDisplaySubmitButton(this.currentPageIndex);
    }
    
    get isDisplayRestartButton() {
        return this.componentLogic.isDisplayRestartButton(this.currentPageIndex);
    }

    handleInput = (event) => {
        this.componentLogic.handleInput(event);
    }

    handleChange = (event) => {
        this.componentLogic.handleChange(event);
    }

    handleBack = (event) => {
        this.componentLogic.handleBack(event);
    }

    handleNext = (event) => {
        this.componentLogic.handleNext(event);
    }

    handleSubmit = (event) => {
        this.componentLogic.handleSubmit(event);
    }

    handleRestart = (event) => {
        this.componentLogic.handleRestart(event);
    }

    handleFileUpload = (event) => {
        this.componentLogic.handleFileUpload(event);
    }
}