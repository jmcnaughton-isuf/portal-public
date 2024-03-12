import { api, LightningElement } from 'lwc';

export default class Portal_MembershipInfoForm extends LightningElement {
    @api membershipBenefitsTableName;
    @api membershipBenefitsData;
    @api membershipBenefitsColumns;
    @api membershipBenefitsFrontEndDataMap;

    @api totalAmount;
    @api totalNonGiftAmount;
    @api totalGiftAmount;

    @api fieldList;
    @api isHideBackButton;
    @api isDisableNextButton;
    @api handleValueChange = () => {};
    @api handleBackClick = () => {};
    @api handleNextClick = () => {};

    get isShowMembershipBenefits() {
        return this.membershipBenefitsData?.length > 0 
                && this.membershipBenefitsColumns?.length > 0
                && this.membershipBenefitsFrontEndDataMap?.membershipBenefits.display;
    }
}