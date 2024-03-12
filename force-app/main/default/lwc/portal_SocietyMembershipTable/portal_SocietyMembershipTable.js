import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSocietyMembershipTableData from '@salesforce/apex/PORTAL_SocietyMembershipTableController.SERVER_getSocietyMembershipTableData';
import getHonorRollManagementInformation from '@salesforce/apex/PORTAL_LWC_HonorRollController.SERVER_getHonorRollManagementInformation';
import submitHonorRollChanges from '@salesforce/apex/PORTAL_LWC_HonorRollController.SERVER_submitHonorRollChanges';
import MailingPostalCode from '@salesforce/schema/Contact.MailingPostalCode';

export default class Portal_SocietyMembershipTable extends LightningElement {

    permissionMap = {}
    annualMemberships = [];
    lifetimeMemberships = [];
    inactiveMemberships = [];
    initDone = false;
    showSpinner = true;

    membershipIdToDisplayHonorRollMap;
    _originalMembershipIdToDisplayHonorRollMap;

    // table column titles
    lifetimeMembershipColumnTitles = [];
    annualMembershipColumnTitles = [];
    inactiveMembershipColumnTitles = [];

    @api tableTitle;
    @api annualMembershipRenewGivingSettingsName;
    @api annualMembershipRenewGivingSettingsfilter;
    @api annualMembershipElevateGivingSettingsName
    @api annualMembershipElevateGivingSettingsfilter;
    @api lifetimeMembershipGivingSettingsName;
    @api lifetimeMembershipGivingSettingsfilter;
    @api inactiveMembershipGivingSettingsName;
    @api inactiveMembershipGivingSettingsfilter;
    @api lifetimeEarliestJoinDateColumnTitle;
    @api showLifetimeJoinDateColumn;
    @api annualEarliestJoinDateColumnTitle;
    @api showAnnualJoinDateColumn;

    @track honorRollOptOutValue;
    @track honorRollName;
    @track honorRollJointPreference;
    @track hasPendingNameChange = false;
    @track isJointPreferenceAvailable = false;

    @track _originalHonorRollOptOutValue;
    @track _originalHonorRollName;
    @track _originalHonorRollJointPreference;

    connectedCallback() {
        this.getHonorRollInformation();
        this.getTableData();
        
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('message') === 'success') {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your changes have been saved.',
                variant: 'success',
                mode: 'sticky'
            });
            this.dispatchEvent(event);
        }
    }

    getHonorRollInformation() {
        getHonorRollManagementInformation()
        .then(data => {
            if (data) {
                this._originalHonorRollOptOutValue = data.honorRollOptOut;
                this._originalHonorRollName = data.honorRollName;
                this._originalHonorRollJointPreference = data.honorRollJointPreference;

                this.honorRollOptOutValue = data.honorRollOptOut;
                this.honorRollName = data.honorRollName;
                this.honorRollJointPreference = data.honorRollJointPreference;

                this.hasPendingNameChange = data.hasPendingNameChange;
                this.isJointPreferenceAvailable = data.isJointPreferenceAvailable;
            }
        }).catch(error => {
            console.log(error);
            this.showNotification('Error', error.body.message, 'error');
        });
    }

    getTableData() {
        getSocietyMembershipTableData({'paramMap' : {'annualMembershipRenewGivingSettingsName' : this.annualMembershipRenewGivingSettingsName,
                                                     'annualMembershipRenewGivingSettingsfilter' : this.annualMembershipRenewGivingSettingsfilter,
                                                     'annualMembershipElevateGivingSettingsName' : this.annualMembershipElevateGivingSettingsName,
                                                     'annualMembershipElevateGivingSettingsfilter' : this.annualMembershipElevateGivingSettingsfilter,
                                                     'lifetimeMembershipGivingSettingsName' : this.lifetimeMembershipGivingSettingsName,
                                                     'lifetimeMembershipGivingSettingsfilter' : this.lifetimeMembershipGivingSettingsfilter,
                                                     'inactiveMembershipGivingSettingsName' : this.inactiveMembershipGivingSettingsName,
                                                     'inactiveMembershipGivingSettingsfilter' : this.inactiveMembershipGivingSettingsfilter}})
        .then(result => {
            this.annualMemberships = result['annualMembershipRecords'];
            this.lifetimeMemberships = result['lifetimeMembershipRecords'];
            this.inactiveMemberships = result['inactiveMembershipRecords'];
            this.permissionMap = result['permissionMap'];
            this.lifetimeMembershipColumnTitles = this.formatColumnTitles('lifetimeGivingSocietyLabel,lifetimeMembershipLevelLabel,lifetimeSocietyMembershipElevateCon,earliestJoinDate,lifetimeSocietyMembershipShowOnHonorRoll', 'lifetime');
            this.annualMembershipColumnTitles = this.formatColumnTitles('annualGivingSocietyLabel,annualMembershipLevelLabel,annualSocietyMembershipElevateCondition,annualSocietyMembershipRenewCondition,earliestJoinDate,annualExpirationDate,annualSocietyMembershipShowOnHonorRoll', 'annual');
            this.inactiveMembershipColumnTitles = this.formatColumnTitles('inactiveGivingSocietyLabel,inactiveMembershipLevelEligibility', 'inactive');

            this.createIdToDisplayOnHonorRollMap();
            this.initDone = true;
            this.showSpinner = false;
        })
        .catch(error => {
            console.log(error);
            this.showNotification('Error', error.body.message, 'error');
        });
    }

    formatColumnTitles(columnCSV, membershipType) {
        let fieldIdList = columnCSV.split(',');
        let columnList = [];

        for (let fieldId of fieldIdList) {
            fieldId = fieldId.trim();
            let column = {};
            column['fieldId'] = fieldId;
            column['fieldType'] = this.permissionMap[fieldId]?.fieldType;


            if (this.permissionMap[fieldId]) {
                column['label'] = this.permissionMap[fieldId].label;
                column['display'] = this.permissionMap[fieldId].display;
                columnList.push(column);
            } else if (fieldId == 'earliestJoinDate' && membershipType == 'lifetime') {
                column['label'] = this.lifetimeEarliestJoinDateColumnTitle;
                column['display'] = this.showLifetimeJoinDateColumn;
                columnList.push(column);
            } else if (fieldId == 'earliestJoinDate' && membershipType == 'annual') {
                column['label'] = this.annualEarliestJoinDateColumnTitle;
                column['display'] = this.showAnnualJoinDateColumn;
                columnList.push(column);
            }

        }
        return columnList;
    }

    get showInactiveSocietyMemberships() {
        return this.inactiveMemberships.length > 0
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.showSpinner = false;

        this.dispatchEvent(evt);
    }

    createIdToDisplayOnHonorRollMap() {
        let idToDisplayOnHonorRollMap = new Map();

        this.annualMemberships.forEach(annualMembership => {
            if (annualMembership) {
                idToDisplayOnHonorRollMap.set(annualMembership.Id, annualMembership.annualSocietyMembershipShowOnHonorRoll);
            }
        });

        this.lifetimeMemberships.forEach(lifetimeMembership => {
            if (lifetimeMembership) {
                idToDisplayOnHonorRollMap.set(lifetimeMembership.Id, lifetimeMembership.lifetimeSocietyMembershipShowOnHonorRoll);
            }
        });

        this._originalMembershipIdToDisplayHonorRollMap = new Map(idToDisplayOnHonorRollMap);
        this.membershipIdToDisplayHonorRollMap = idToDisplayOnHonorRollMap;
    }

    handleShowHonorRollOption = (event) => {
        this.showSpinner = true;
        this.membershipIdToDisplayHonorRollMap.set(event.target.dataset.id, event.target.checked);

        this.showSpinner = false;
    }

    handleSubmitChanges = () => {
        this.showSpinner = true;
        let societyMembershipsToModifyMap = {};
        let functionParams = {};

        for (let key of this.membershipIdToDisplayHonorRollMap.keys()) {
            if (this.membershipIdToDisplayHonorRollMap.get(key) == this._originalMembershipIdToDisplayHonorRollMap.get(key)) {
                continue;
            }

            societyMembershipsToModifyMap[key] = Boolean(this.membershipIdToDisplayHonorRollMap.get(key));
        }

        functionParams.membershipsToUpdate = societyMembershipsToModifyMap;

        if (this.honorRollOptOutValue != this._originalHonorRollOptOutValue) {
            functionParams.honorRollOptOut = this.honorRollOptOutValue;
        }

        if (this.honorRollName != this._originalHonorRollName) {
            functionParams.honorRollName = this.honorRollName;
        }

        if (this.honorRollJointPreference != this._originalHonorRollJointPreference) {
            functionParams.honorRollJointPreference = this.honorRollJointPreference;
        }

        submitHonorRollChanges({params: functionParams})
        .then(() => {
            let currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('message', 'success');

            window.location.href = currentUrl;
        }).catch(error => {
            this.showNotification('Error', error.body.message, 'error');
            this.showSpinner = false;
        });
    }

    handleOptOutChange = (newOptOutValue) => {
        this.honorRollOptOutValue = newOptOutValue;
    }

    handleHonorRollNameInput = (newHonorRollName) => {
        this.honorRollName = newHonorRollName;
    }

    handleJointPreferenceChange = (newJointPreferenceValue) => {
        this.honorRollJointPreference = newJointPreferenceValue;
    }

}