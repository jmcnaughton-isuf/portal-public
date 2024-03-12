import { api, LightningElement } from 'lwc';

export default class Portal_SocietyMembershipDisplayTableEntry extends LightningElement {
    @api record = {};
    @api columnData = {};
    @api handleExpandData = () => {};
    @api handleCheckboxClick = () => {};

    get fieldType() {
        return this.columnData.fieldType;
    }

    get fieldId() {
        return this.columnData.fieldId;
    }

    get isText() {
        return !this.fieldType || this.fieldType === 'text' || (this.fieldType === 'expandData' && !this.record.expandedData)
                || (this.fieldType === 'url' && this.linkValue == null);
    }

    get isCurrency() {
        return this.fieldType === 'currency';
    }

    get isHtml() {
        return this.fieldType === 'html';
    }

    get isDate(){
        return this.fieldType === 'date';
    }

    get isCheckbox() {
        return this.fieldType === 'checkbox';
    }

    get isLink() {
        return this.fieldType === 'url';
    }

    get isExpandDataButton() {
        return this.fieldType === 'expandData' && this.record.expandedData;
    }

    get entryValue() {
        if (this.record[this.fieldId] != undefined && this.record[this.fieldId] != null) {
            return this.record[this.fieldId];
        }

        return ' ';
    }

    get linkValue() {
        if (this.record[this.fieldId] == undefined || this.record[this.fieldId] == null) {
            return null;
        }

        if (this.fieldId == 'annualSocietyMembershipElevateCondition' && this.record.elevateGivingLink) {
            return this.record.elevateGivingLink;
        } else if (this.fieldId == 'annualSocietyMembershipRenewCondition' && this.record.renewGivingLink) {
            return this.record.renewGivingLink;
        } else if (this.fieldId == 'lifetimeSocietyMembershipElevateCon' && this.record.elevateGivingLink) {
            return this.record.elevateGivingLink;
        } else if (this.fieldId == 'inactiveMembershipLevelEligibility' && this.record.reenterGivingLink) {
            return this.record.reenterGivingLink;
        }

        return null;
    }

    handleExpandDataClicked() {
        this.handleExpandData(this.record);
    }

    handleCheckboxClicked = (event) => {
        this.handleCheckboxClick(event);
    }
}