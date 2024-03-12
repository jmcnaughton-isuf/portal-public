import { LightningElement, api } from 'lwc';

export default class Portal_ZoneMembershipTableEntry extends LightningElement {
    @api zoneMembershipRecord;
    @api column;
    @api isEditTable;
    @api index;
    @api isNewsletterFieldDisabled;
    @api handleLeaveZoneMembership = () => {};
    @api handleCheckboxChange = () => {};
    @api handleJoinZoneMembership = () => {};

    _columnData = '';
    _initDone = false;

    _isText = false;
    _isCheckbox = false;
    _isJoinLink = false;
    _isLeaveLink = false;

    get isNewsletterCheckboxDisabled() {
        return (this._isCheckbox && this.isNewsletterFieldDisabled && this.column.key == 'zoneMemIsOnNewsletter')
    }

    connectedCallback() {
        if (this.column.fieldType == 'checkbox' && this.isEditTable && this.zoneMembershipRecord) {
            this._isCheckbox = true;
            this._columnData = this.zoneMembershipRecord[this.column.key];
        } else if (this.isEditTable && this.column.key == 'zoneMemStatus' && this.zoneMembershipRecord?.zoneMemStatus) {
            if (this.zoneMembershipRecord.zoneMemStatus === 'Inactive' || this.zoneMembershipRecord.zoneMemStatus === 'Denied') {
                this._isJoinLink = true;
            } else {
                this._isLeaveLink = true;
            }
        } else if (this.zoneMembershipRecord){
            this._isText = true;
            this.formatTextString(this.zoneMembershipRecord[this.column.key]);
        }

        this._initDone = true;
    }

    handleLeaveClick = (event) => {
        this.handleLeaveZoneMembership(this.zoneMembershipRecord.Id, this.index);
    }

    handleJoinClick = (event) => {
        this.handleJoinZoneMembership(this.index);
    }

    handleCheckboxClick = (event) => {
        const detail = {
            id: this.zoneMembershipRecord.Id,
            fieldId: this.column.fieldId,
            checkedValue: event.target.checked,
            zoneId: this.zoneMembershipRecord.zoneId,
            index: this.index
        }

        this.handleCheckboxChange(detail);
    }

    formatTextString(tableEntryString) {
        if (tableEntryString != null && this.column.fieldType == 'number') {
            let amountString = '$' + this.zoneMembershipRecord[this.column.key].toFixed(2);
            this._columnData = amountString;
        } else if (!this.isEditTable && this.column.fieldType == 'checkbox') {
            this._columnData = (this.zoneMembershipRecord[this.column.key] ? 'Yes' : 'No');
        } else {
            this._columnData = this.zoneMembershipRecord[this.column.key];
        }
    }
}