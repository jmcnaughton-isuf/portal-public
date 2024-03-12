// whole LWC is obsolete/not necessary bc of Display Table 
import { api, LightningElement } from 'lwc';

export default class Portal_VolunteerTableEntry extends LightningElement {
    @api volunteerRecord;
    @api column;
    @api recordId;
    @api shiftId;
    @api jobName;
    @api startDate;
    @api endDate;
    @api handleReportHours = () => {};
    @api handleModifyApplication = () => {};

    _columnData = '';
    _initDone = false;
    _isReportLink = false;
    _isModifyLink = false;
    _isDateTime = false;
    _isText = false;
    

    connectedCallback() {
        this._columnData = this.volunteerRecord[this.column.key];

        if (this.column.fieldType === 'datetime') {
            /*try{
                this._columnData = Date.parse(this._columnData);
            } catch(e) {
                this._columnData = '';
            }*/

            this._isDateTime = true;
        } else {
            this._isText = true;
        }

        if (this.column.key === 'report') {
            this._isReportLink = true;
        }

        if (this.column.key === 'modifyApplication') {
            this._isModifyLink = true;
        }
        this._initDone = true;
    }
}