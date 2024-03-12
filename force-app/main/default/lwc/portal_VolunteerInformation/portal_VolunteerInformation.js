import { LightningElement, wire, api, track } from 'lwc';
import getVolunteerInformation  from '@salesforce/apex/PORTAL_LWC_VolunteerInformation.SERVER_getVolunteerInformation';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import volunteerChannel from '@salesforce/messageChannel/volunteerChannel__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_VolunteerReportHoursForm extends LightningElement {
    @api pageName = 'Volunteer Information';
    @api mainSectionName = 'Volunteer Information';
    @api itemsPerPage = 4;

    @wire(MessageContext) messageContext;

    @track _showSpinner = true;
    @track _volunteerInfo;
    @track _jobList = [];
    @track _skillList = [];
    @track _reportHoursJobId = '';
    @track _isShowEditForm = false;
    @track _currentJobList = [];
    @track _reportableJobList = [];
    @track _completedJobList = [];
    @track _volunteerHours;
    @track _subscription;
    
    get recordId() {
        return new URLSearchParams(window.location.search).get('recordId');
    }

    get intializeParams() {
        return {pageName: this.pageName, mainSectionName: this.mainSectionName, recordId: this.recordId}
    }

    get isVolunteer() {
        if (this._volunteerInfo && this._volunteerInfo.isVolunteer) {
            return 'Yes';
        }

        return 'No';
    }

    get formatSkills() {
        return this._skillList.map(skill => skill.name).join(', ') || 'N/A';
    }

    connectedCallback() {
        this.getVolunteerInformation();
        this.subscribeToMessageChannel();
        this._reportHoursJobId = new URLSearchParams(window.location.search).get('recordId');
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                volunteerChannel,
                (message) => this.handleMessage(message),
            );
        }
    }

    handleMessage = (message) => {
        this.getVolunteerInformation();
    }

    handleReportHours = (event) => {
        this._reportHoursJobId = event.target.dataset.id;
    }

    handleEditClick() {
        if (this._volunteerInfo) {
            this._isShowEditForm = true;
        }
        else {
            const event = new ShowToastEvent({
                title: 'No user found!',
                message: 'Log in to edit your information.',
                variant:"warning",
            });
            this.dispatchEvent(event);
        }
    }

    closeEditModal = () => {
        this._isShowEditForm = false;
    }

    closeModal = () => {
        this._reportHoursJobId = '';
    }

    getVolunteerInformation = () => {
        this._showSpinner = true;
        callApexFunction(this, getVolunteerInformation, this.intializeParams, (data) => {
            if (!data.records) {
                this._showSpinner = false;
                const event = new ShowToastEvent({
                    title: 'No user found!',
                    message: 'Log in to view your information.',
                    variant:"warning",
                });
                this.dispatchEvent(event);
                return;
            }

            this._volunteerInfo = data.records['Contact Info'][0];
            this._skillList = data.records['Constituent Skills'];

            this._jobList = [];
            this._volunteerHours = 0;
            for (let eachJob of data.records['Volunteer Jobs']) {
                let newJob = Object.assign({}, eachJob);
                this._volunteerHours += newJob.reportedHours || 0;
                // note: there's no status field on Volunteer, these lists aren't used
                if (newJob.status === 'Completed' && newJob.reportedHours) {
                    this._completedJobList.push(newJob);
                } else if (newJob.status === 'Completed') {
                    this._reportableJobList.push(newJob);
                } else {    
                    this._currentJobList.push(newJob);
                }
            }

            this._showSpinner = false;
        }, () => {
            this._showSpinner = false;
        });
    }
}