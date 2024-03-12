import { LightningElement, api } from 'lwc';

export default class Portal_MyInformationPrivacySettings extends LightningElement {
    @api informationMap;
    @api displayView;
    _informationMap;

    connectedCallback() {
        this._informationMap = Object.assign({}, JSON.parse(JSON.stringify(this.informationMap)));
    }

    get directoryOptOut() {
        if (this.informationMap && this.informationMap.records && this.informationMap.records.Privacy_Settings
            && this.informationMap.records.Privacy_Settings.Directory_Opt_Out &&
            this.informationMap.records.Privacy_Settings.Directory_Opt_Out.length > 0) {
                return !this.informationMap.records.Privacy_Settings.Directory_Opt_Out[0].isDirectoryOptOut;
        }
        return true;
    }

    get receivingMessages() {
        if (this.informationMap && this.informationMap.records && this.informationMap.records.Privacy_Settings
            && this.informationMap.records.Privacy_Settings.Directory_Setting &&
            this.informationMap.records.Privacy_Settings.Directory_Setting.length > 0) {
                return this.informationMap.records.Privacy_Settings.Directory_Setting[0].receivingMessages;
        }
        return true;
    }

    get studentCanSee() {
        if (this.informationMap && this.informationMap.records && this.informationMap.records.Privacy_Settings
            && this.informationMap.records.Privacy_Settings.Directory_Setting &&
            this.informationMap.records.Privacy_Settings.Directory_Setting.length > 0) {
                return this.informationMap.records.Privacy_Settings.Directory_Setting[0].studentCanSee;
        }
        return true;
    }

    editInformation() {
        window.location.replace(window.location.href.split(/[?#]/)[0] + '?mode=edit&tab=privacy');
    }

    updateIsStudentCanSee(event){
        if ( this._informationMap.records.Privacy_Settings.Directory_Setting.length > 0) {
            this._informationMap.records.Privacy_Settings.Directory_Setting[0].studentCanSee = event.target.checked
        } else {
            this._informationMap.records.Privacy_Settings.Directory_Setting.push({studentCanSee: event.target.checked, receivingMessages: true, Id:null});
        }
        if (this._informationMap['Change_Set']) {
            let changeSet = new Set (this._informationMap['Change_Set']);
            changeSet.add('Directory_Setting');
            this._informationMap['Change_Set'] = Array.from(changeSet);

        } else {
            this._informationMap['Change_Set'] = ['Directory_Setting'];
        }

    }

    updateIsReceivingMessages(event){
        if ( this._informationMap.records.Privacy_Settings.Directory_Setting.length > 0) {
            this._informationMap.records.Privacy_Settings.Directory_Setting[0].receivingMessages = event.target.checked
        } else {
            this._informationMap.records.Privacy_Settings.Directory_Setting.push({receivingMessages: event.target.checked, studentCanSee: true, Id:null});
        }
        if (this._informationMap['Change_Set']) {
            let changeSet = new Set (this._informationMap['Change_Set']);
            changeSet.add('Directory_Setting');
            this._informationMap['Change_Set'] = Array.from(changeSet);

        } else {
            this._informationMap['Change_Set'] = ['Directory_Setting'];
        }
    }

    updateDirectoryOptOut(event) {
        if(this._informationMap.records.Privacy_Settings.Directory_Opt_Out.length > 0) {
            this._informationMap.records.Privacy_Settings.Directory_Opt_Out[0].isDirectoryOptOut = !event.target.checked;
        } else {
            this._informationMap.records.Privacy_Settings.Directory_Opt_Out.push({isDirectoryOptOut: !event.target.checked, Id:null})
        }
        if (this._informationMap['Change_Set']) {
            let changeSet = new Set (this._informationMap['Change_Set']);
            changeSet.add('Directory_Opt_Out');
            this._informationMap['Change_Set'] = Array.from(changeSet);

        } else {
            this._informationMap['Change_Set'] = ['Directory_Opt_Out'];
        }
    }

    @api
    getEditInformation() {
        return this._informationMap;
    }
}