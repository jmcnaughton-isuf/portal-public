import { LightningElement, api, track } from 'lwc';
export default class Portal_HonorRollManagement extends LightningElement {

    honorRollManagementTitle = 'Honor Roll Management';
    optOutLabel = 'Do not list me on any University-wide honor rolls. (If "Joint" is selected as your honor roll joint preference, your spouse/partner\'s name also will not be listed)';

    @track parsedInformation = false;
    @track showModal = false;

    @api honorRollOptOutValue;
    @api honorRollName;
    @api honorRollJointPreference;
    @api hasPendingNameChange;
    @api isJointPreferenceAvailable;

    _honorRollPreferences = ['Individual', 'Joint'];

    get jointPreferenceOptions() {
        let jointPreferenceOptionsList = [];

        this._honorRollPreferences.forEach(preference => {
            if (preference === 'Joint' && !this.isJointPreferenceAvailable) {
                return;
            }

            jointPreferenceOptionsList.push({label:preference, value:preference})
        });
        
        return jointPreferenceOptionsList;
    }

    @api handleSubmitChanges = () => {};
    @api handleOptOutChange = () => {};
    @api handleHonorRollNameInput = () => {};
    @api handleJointPreferenceChange = () => {};

    onOptOutChange = (event) => {
        this.handleOptOutChange(event.target.checked);
    }

    onHonorRollNameInput = (event) => {
        this.handleHonorRollNameInput(event.target.value);
    }

    onJointPreferenceChange = (event) => {
        this.handleJointPreferenceChange(event.target.value);
    }

    handleSubmitModalOpen = () => {
        this.showModal = true;
    }

    handleSubmitModalClose = () => {
        this.showModal = false;
    }

    handleSubmitChangeButtonClick = () => {
        this.showModal = false;

        this.handleSubmitChanges();
    }

}