import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import saveInformation from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_saveInformation';
import getCustomMetadataConfiguration from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getCustomMetadataConfiguration';
import { getRelativeUrl } from 'c/portal_util_Urls';

export default class Portal_MyInformationWrapper_v2 extends LightningElement {
    @track _currentTab = 'contact';
    @track _displayMode = 'view';
    @track _isDisplayWrapper = false;
    @track _isShowSpinner = false;
    @track _isDisableNavigationInterrupt = false;
    @track _customMetdataConfiguration = {}

    _tabNameToLabelList = [{tab: 'contact', label: 'Contact Information'},
                           {tab: 'employment', label: 'Employment Information'},
                           {tab: 'degree', label: 'Degree Information'},
                           {tab: 'socialmedia', label: 'Social Media Information'}, 
                           {tab: 'privacy', label: 'Privacy Settings'}
                          ];

    _tabNameToComponentName = {'contact': 'c-portal_-My-Information-Contact_v2',
                               'employment': 'c-portal_-My-Information-Employment_v2',
                               'degree': 'c-portal_-My-Information-Degree_v2',
                               'socialmedia': 'c-portal_-My-Information-Social-Media_v2',
                               'privacy': 'c-portal_-My-Information-Contact-Preferences_v2'
                               };

    connectedCallback() {
        callApexFunction(this, getCustomMetadataConfiguration, {}, (data) => {
            this._customMetdataConfiguration = data;
            this.setup();
        }, () => {
        });
    }

    setup() {
        const urlParams = new URLSearchParams(window.location.search);
        let displayModeParam = urlParams.get('mode');
        if (displayModeParam === 'edit' || displayModeParam === 'view') {
            this._displayMode = displayModeParam;
        }

        let tabParam = urlParams.get('tab');
        if (this.validTabs.includes(tabParam)) {
            this._currentTab = tabParam;
        }

        let messageParam = urlParams.get('message');
        if (messageParam === 'success') {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'Your changes have been saved.',
                variant:"success",
                mode:"sticky"
            }));
        }

        if (this._displayMode != 'view') {
            window.addEventListener('beforeunload', (event) => {
                if (this._isDisableNavigationInterrupt) {
                    return;
                }

                // Recommended
                event.preventDefault();

                // Included for legacy support, e.g. Chrome/Edge < 119
                event.returnValue = true;
            });
        }

        this._isDisplayWrapper = true;
    }

    get validTabNameToLabelList() {
        return this._tabNameToLabelList.filter(eachTab => {
            switch(eachTab.tab) {
                case 'contact':
                    return this.isDisplayContactTab;
                case 'employment':
                    return this.isDisplayEmploymentTab;
                case 'degree':
                    return this.isDisplayDegreeTab;
                case 'socialmedia':
                    return this.isDisplaySocialMediaTab;
                case 'privacy':
                    return this.isDisplayPrivacyTab;
                default:
                    return false;
            }
        });
    }

    get validTabs() {
        return this.validTabNameToLabelList.map(eachTab => eachTab.tab);
    }

    get isDisplayContact() {
        return this._currentTab === 'contact';
    }

    get isDisplayDegree() {
        return this._currentTab === 'degree';
    }

    get isDisplaySocialMedia() {
        return this._currentTab === 'socialmedia';
    }

    get isEditMode() {
        return this._displayMode === 'edit';
    }

    get isDisplayEmployment() {
        return this._currentTab === 'employment';
    }

	get isDisplayPrivacy() {
		return this._currentTab === 'privacy';
	}

    get pathClass() {
        return 'progress-step-custom slds-path__item slds-is-incomplete';
    }

    get activePathClass() {
        return this.pathClass + ' slds-is-active';
    }

    get progressTabList() {
        let progressTabList = [];

        let timestamp = Date.now();

        for (let {tab: eachTab, label: eachLabel} of this.validTabNameToLabelList) {
            progressTabList.push({label: eachLabel, 
                                  value: eachTab, 
                                  class: this._currentTab === eachTab ? this.activePathClass : this.pathClass, 
                                  key: ++timestamp});
        }

        return progressTabList;
    }

    get isDisplaySocialMediaTab() {
        return this._customMetdataConfiguration.socialMedia.display;
    }

    get isDisplayEmploymentTab() {
        return this._customMetdataConfiguration.employment.display;
    }

    get isDisplayPrivacyTab() {
        return (this._customMetdataConfiguration.directoryOptOut.display || this._customMetdataConfiguration.directorySetting.display || this._customMetdataConfiguration.serviceIndicators.display);
    }

    get isDisplayDegreeTab() {
        return (this._customMetdataConfiguration.schoolDegrees.display || this._customMetdataConfiguration.nonSchoolDegrees.display);
    }

    get isDisplayContactTab() {
        return (this._customMetdataConfiguration.name.display
                || this._customMetdataConfiguration.nickname.display
                || this._customMetdataConfiguration.maidenName.display
                || this._customMetdataConfiguration.additionalDetails.display
                || this._customMetdataConfiguration.emails.display
                || this._customMetdataConfiguration.phones.display
                || this._customMetdataConfiguration.addresses.display)
    }

    handleTabClick = (event) => {
        let clickedTab = event.currentTarget.dataset.value;
        if (!this.isCurrentTabDataValid()) {
            return;
        }

        this._currentTab = clickedTab;
    }

    isCurrentTabDataValid() {
        if (this._displayMode == 'view') {
            return true;
        }
        
        let currentTabComponent = this.template.querySelector(this._tabNameToComponentName[this._currentTab]);
        const invalidFieldList = currentTabComponent?.getInvalidFieldList();
        if (!invalidFieldList || invalidFieldList.length === 0) {
            return true;
        }

        const invalidFieldSet = new Set(invalidFieldList);
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error.',
            message: 'Please correct the following field' + (invalidFieldSet.size > 1 ? 's' : '') + ': ' + [...invalidFieldSet].join(', '),
            variant: 'error',
            mode: 'sticky'
        }));
        return false;
    }

    handleSave = (event) => {
        this._isShowSpinner = true;

        let childComponentList = [
            this.template.querySelector('c-portal_-My-Information-Degree_v2'),
            this.template.querySelector('c-portal_-My-Information-Employment_v2'),
            this.template.querySelector('c-portal_-My-Information-Social-Media_v2'),
            this.template.querySelector('c-portal_-My-Information-Contact_v2'),
            this.template.querySelector('c-portal_-My-Information-Contact-Preferences_v2')
        ];
            
        for (let eachComponent of childComponentList) {
            if (!eachComponent || eachComponent.checkAndReportInputValidity()) {
                continue;
            }
            
            this._isShowSpinner = false;
            return;
        }
            
        let sectionIdToUpdatedRecordsMap = {};
        
        for (let eachComponent of childComponentList) {
            if (!eachComponent) {
                continue;
            }
            
            // directorySetting shows up in 2 sections (Contact and Privacy Settings), so its record needs to potentially be merged
            let sectionRecordMap = eachComponent.getUpdatedRecordsMap();
            if (sectionIdToUpdatedRecordsMap.hasOwnProperty('directorySetting') && sectionRecordMap?.hasOwnProperty('directorySetting')) {
                let targetSetting = sectionIdToUpdatedRecordsMap.directorySetting?.[0];
                let sourceSetting = sectionRecordMap.directorySetting?.[0];

                if (targetSetting && sourceSetting) {
                    sectionIdToUpdatedRecordsMap.directorySetting = [Object.assign(targetSetting, sourceSetting)];
                }

                delete sectionRecordMap.directorySetting;
            }

            sectionIdToUpdatedRecordsMap = Object.assign(sectionIdToUpdatedRecordsMap, sectionRecordMap);
        }
        let params = {sectionIdToUpdatedRecordsMap: sectionIdToUpdatedRecordsMap, interimSourceUrl: getRelativeUrl()};
        callApexFunction(this, saveInformation, params, () => {
            this._isDisableNavigationInterrupt = true;
            window.location.replace('?message=success');
        }, () => {
            this._isShowSpinner = false;
        });
    }
}