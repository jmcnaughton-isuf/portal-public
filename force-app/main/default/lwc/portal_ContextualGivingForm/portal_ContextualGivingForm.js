import { LightningElement, api, track, wire } from 'lwc';
import { ComponentLogic, ComponentLogicBuilder } from './portal_ContextualGivingFormHelper';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
export * from './portal_ContextualGivingFormHelper';

export default class Portal_ContextualGivingForm extends LightningElement {
    @api givingFormName = '';
    @api urlParamName = '';
    @track componentLogic = undefined;
    @track componentAttributes = {};
    @track _isRecaptchaEnabled = true;

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_OnlineGivingControllerBase.SERVER_createReviewTransaction'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    connectedCallback() {
        this.setup();
    }

    setup() {
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
                                                         .buildGivingFormName(this.givingFormName)
                                                         .build();

        this.componentLogic.getComponentData();
    }

    get isDisplay() {
        return this.componentAttributes.isDisplay;
    }

    get designationList() {
        return this.componentAttributes?.designationList;
    }

    get giftTypes() {
        return this.componentAttributes?.giftTypes;
    }

    get giftFrequencies() {
        return this.componentAttributes?.giftFrequencies;
    }

    get emailTypes() {
        return this.componentAttributes?.emailTypes;
    }

    get phoneTypes() {
        return this.componentAttributes?.phoneTypes;
    }

    get addressTypes() {
        return this.componentAttributes?.addressTypes;
    }

    get giftType() {
        return this.componentAttributes.billingInformation?.giftType;
    }

    get giftTypeLabel() {
        for (let eachGiftType of this.giftTypes) {
            if (this.giftType === eachGiftType.value) {
                return eachGiftType.label;
            }
        }
    }

    get isAutomaticPaymentGiftType() {
        return this.giftType === 'pledge' || this.giftType === 'recurring';
    }

    get isPledgeGiftType() {
        return this.giftType === 'pledge';
    }

    get startDate() {
        return this.componentAttributes.billingInformation.startDate || '';
    }

    get startDateStyle() {
        return this.componentLogic.startDateStyle;
    }

    get minimumStartDate() {
        return this.componentLogic.minimumStartDate;
    }

    get maximumEndDate() {
        return this.componentLogic.maximumEndDate;
    }

    get endDate() {
        return this.componentAttributes.billingInformation.endDate || '';
    }

    get designation() {
        return this.componentAttributes.billingInformation?.designation;
    }

    get frequency() {
        return this.componentAttributes.billingInformation?.frequency;
    }

    get numberOfInstallments() {
        return this.componentAttributes.billingInformation?.numberOfInstallments || '';
    }

    get isEndDateEnabled() {
        return this.componentAttributes.formConfiguration?.isEndDateEnabled && this.giftType === 'recurring';
    }

    get designationName() {
        return this.componentLogic.designationName;
    }

    get giftAmount() {
        return this.componentAttributes.billingInformation?.giftAmount;
    }

    get isFixedAmount() {
        return this.componentAttributes.formConfiguration.isFixedAmount;
    }

    get isFixedInstallments() {
        return this.componentAttributes.formConfiguration.isFixedInstallments;
    }

    get confirmationText() {
        return this.componentAttributes.formConfiguration.confirmationText;
    }

    get firstName() {
        return this.componentAttributes.billingInformation?.firstName || '';
    }

    get lastName() {
        return this.componentAttributes.billingInformation?.lastName || '';
    }

    get phoneNumber() {
        return this.componentAttributes.billingInformation?.phoneNumber || '';
    }

    get phoneType() {
        return this.componentAttributes.billingInformation?.phoneType || '';
    }

    get emailAddress() {
        return this.componentAttributes.billingInformation?.emailAddress || '';
    }

    get emailType() {
        return this.componentAttributes.billingInformation?.emailType || '';
    }

    get addressLine1() {
        return this.componentAttributes.billingInformation?.addressLine1 || '';
    }

    get addressLine2() {
        return this.componentAttributes.billingInformation?.addressLine2 || '';
    }

    get addressCity() {
        return this.componentAttributes.billingInformation?.addressCity || '';
    }

    get addressState() {
        return this.componentAttributes.billingInformation?.addressState || '';
    }

    get addressPostalCode() {
        return this.componentAttributes.billingInformation?.addressPostalCode || '';
    }

    get addressCountry() {
        return this.componentAttributes.billingInformation?.addressCountry || '';
    }

    get addressType() {
        return this.componentAttributes.billingInformation?.addressType || '';
    }

    get currentPage() {
        return this.componentAttributes.currentPage;
    }

    get isDisplayBackButton() {
        return this.currentPage === 'billing-details';
    }

    get isDisplayNextButton() {
        return this.currentPage === 'gift-details' || this.currentPage === 'billing-details';
    }

    get isDisplayGiftDetails() {
        return this.currentPage === 'gift-details';
    }

    get isDisplayBillingDetails() {
        return this.currentPage === 'billing-details';
    }

    get isDisplayConfirmation() {
        return this.currentPage === 'confirmation';
    }

    get isDisplayPaymentForm() {
        return this.currentPage === 'payment-form';
    }

    get isDisplayButtons() {
        return this.isDisplayBackButton || this.isDisplayNextButton || this.isDisplaySubmitButton || this.isDisplayConfirmation;
    }

    get isShowSpinner() {
        return this.componentAttributes.isShowSpinner || false;
    }

    get giftDetailsLabel() {
        return this.componentAttributes.formConfiguration.giftDetailsLabel || 'Gift Details';
    }

    get paymentProcessor() {
        return this.componentAttributes.formConfiguration.paymentProcessor;
    }

    get externalGatewayName() {
        return this.componentAttributes.formConfiguration.externalGatewayName;
    }

    get currentPageTitle() {
        return this.componentLogic.currentPageTitle;
    }

    get paymentBillingInformation() {
        return this.componentLogic.paymentBillingInformation;
    }

    get additionalMetadata() {
        return this.componentLogic.additionalMetadata;
    }

    get minimumRecurringEndDate() {
        return this.componentLogic.minimumRecurringEndDate;
    }

    handleChange = (event) => {
        this.componentLogic.handleChange(event);
    }

    handleBack = (event) => {
        this.componentLogic.handleBack();
    }

    handleNext = (event) => {
        this.componentLogic.handleNext();
    }

    handleReset = (event) => {
        this.componentLogic.handleReset();
    }

    handlePaymentConfirmation = (params) => {
        this.componentLogic.handlePaymentConfirmation(params);
    }
}