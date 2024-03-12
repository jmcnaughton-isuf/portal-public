import { LightningElement } from 'lwc';
import getShiftInfo from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_getShiftInfo';

export default class Portal_VolunteerModifyListener extends LightningElement {
    pageName = 'Volunteers';
    mainSectionName = 'Volunteer Job List';
    _shiftObject = {};
    _volunteerId = '';
    _isShowModifyModal = false;

    connectedCallback() {
        let urlParams = (new URL(document.location)).searchParams;
        let volunteerId = urlParams.get('recordId');
        let shiftId = urlParams.get('shiftId');

        if (!volunteerId || !shiftId) {
            return;
        }

        getShiftInfo({params: {pageName: this.pageName, mainSectionName: this.mainSectionName, volunteerShiftId: shiftId}})
        .then(res => {
            if (!res) {
                return;
            }

            this._shiftObject = res;
            this._volunteerId = volunteerId;
            this._isShowModifyModal = true;
        })
    }

    handleCloseModifyModal = () => {
        this._shiftObject = {};
        this._volunteerId = '';
        this._isShowModifyModal = false;
    }
}