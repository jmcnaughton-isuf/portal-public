import { LightningElement, api } from 'lwc';

export default class Portal_MembershipBenefits extends LightningElement {
    @api membershipBenefitsTableName;
    @api membershipBenefitsData;
    @api membershipBenefitsColumns;
    @api membershipBenefitsFrontEndDataMap;

    @api totalAmount = 0;
    @api totalNonGiftAmount = 0;
    @api totalGiftAmount = 0;
}