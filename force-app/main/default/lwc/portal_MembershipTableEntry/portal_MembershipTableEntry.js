import { LightningElement, api } from 'lwc';

export default class Portal_MembershipTableEntry extends LightningElement {
    @api membershipRecord;
    @api column;
    @api isEditTable;
    @api handleRenewalSolicitOptOut = () => {};

    _columnData = '';
    _initDone = false;

    _isText = false;
    _isCheckbox = false;
    _isButton = false;;

    connectedCallback() {
        if (this.column.key == 'membershipRenewalSolicitOptOut') {
            this.handleMembershipRenewalSolicitationOptOutDisplay();
        } else if (this.column.key == 'membershipRenewCondition' && this.membershipRecord['membershipIsShowRenewalButton']) {
            this._isButton = true;
        } else {
            this._isText = true;
            this.formatTextString(this.membershipRecord[this.column.key]);
        }

        this._initDone = true;
    }

    handleMembershipRenewalSolicitationOptOutDisplay() {
        if (this.membershipRecord['membershipType'] == 'Lifetime') {
            this._isText = true;
            this._columnData = 'N/A';
        } else if (!this.isEditTable) {
            this._isText = true;
            this._columnData = (this.membershipRecord[this.column.key] ? 'Yes' : 'No');
        } else {
            this._isCheckbox = true;
            this._columnData = this.membershipRecord[this.column.key];
        }
    }

    handleRenewalSolicitOptOutClick = (event) => {
        const detail = {
            id: event.target.dataset.id,
            checkedValue: event.target.checked
        }

        this.handleRenewalSolicitOptOut(detail);
    }

    handleRenewClick = (event) => {
        window.location.href = './membership-purchase?recordId=' + this.membershipRecord.membershipId;
    }

    formatTextString(tableEntryString) {
        if (tableEntryString != null && this.column.fieldType == 'number') {
            let amountString = '$' + this.membershipRecord[this.column.key].toFixed(2);
            this._columnData = amountString;
        } else {
            this._columnData = this.membershipRecord[this.column.key];
        }
    }
}