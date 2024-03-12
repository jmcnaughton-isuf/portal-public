import { LightningElement } from 'lwc';
import SERVER_changePassword from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_changePassword';
import SERVER_changeEmail from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_changeEmail';
import SERVER_changeUsername from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_changeUsername';
import SERVER_getUserData from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_getUserData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Portal_AccountManagement extends LightningElement {
    _oldPassword = '';
    _newPassword = '';
    _newEmail = '';
    _verifyNewPassword = '';
    _showChangePassword = false;
    _showSpinner = true;
    _showChangeEmail = false;
    _newUsername = '';
    _showChangeUsername = false;
    _user = {Username: "", Email:""};
    user

    connectedCallback() {
        const params = {params:{}};
        SERVER_getUserData(params).then(res => {
            if (res) {
                this.user = res;
                this._user = JSON.parse(JSON.stringify(this.user));
            }
        }).catch(error => {
            console.log(error);
        }).finally(() => {
            this._showSpinner = false;
        })

    }

    handleVerifyPassword = (event) => {
        this._verifyNewPassword = event.currentTarget.value;
        if (this._newPassword !== this._verifyNewPassword) {
            if (this.template.querySelector('[data-name="verify"]')) {
                this.template.querySelector('[data-name="verify"]').setCustomValidity('The passwords do not match.');

            }
        } else {
            if (this.template.querySelector('[data-name="verify"]')) {
                this.template.querySelector('[data-name="verify"]').setCustomValidity('');

            }
        }
        this.template.querySelector('[data-name="verify"]').reportValidity();
    }

    setNewPassword = (event) => {
        this._newPassword = event.currentTarget.value;
    }

    setOldPassword = (event) => {
        this._oldPassword = event.currentTarget.value;
    }

    setNewEmail = (event) => {
        this._newEmail = event.currentTarget.value;
    }

    setUsername = (event) => {
        this._newUsername = event.currentTarget.value;
    }

    handleChangePassword(event){
        this._showChangePassword = true;
        this._showChangeEmail = false;
        this._showChangeUsername = false;
    }

    handleChangeEmail(event) {
        this._showChangeEmail = true;
        this._showChangePassword = false;
        this._showChangeUsername = false;
    }

    handleChangeUsername(event) {
        this._showChangeEmail = false;
        this._showChangePassword = false;
        this._showChangeUsername = true;
    }

    handleCancel(event) {
        this._showChangePassword = false;
        this._showChangeEmail = false;
        this._showChangeUsername = false;
    }

    changePassword(event) {
        if (!this._oldPassword || !this._newPassword || !this._verifyNewPassword) {
            this.showErrorToast('Please fill out all fields.');
            return;
        }
        if (this._newPassword !== this._verifyNewPassword){
            this.showErrorToast('The passwords do not match.');
            return;
        }
        const params = {params: {oldPassword:this._oldPassword, newPassword:this._newPassword, passwordConfirmation: this._verifyNewPassword}}
        this._showSpinner = true;
        SERVER_changePassword(params).then(res => {
            this._showSpinner = false;
            this._oldPassword = '';
            this._newPassword = '';
            this._verifyNewPassword = '';
            this._showChangePassword = false;
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Password changed successfully',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }).catch(error => {
            this._showSpinner = false;
            let errorMap = JSON.parse(error.body.message);
            this.showErrorToast(errorMap.message);
        })
    }

    changeEmail(event) {
        if (!this._newEmail) {
            this.showErrorToast('Please fill out all fields.');
            return;
        }
        const params = {params: {email:this._newEmail}}
        this._showSpinner = true;
        SERVER_changeEmail(params).then(res => {
            this._showChangeEmail = false;
            this._showSpinner = false;
            this.user = res;
            this._user = JSON.parse(JSON.stringify(this.user));
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your email change request has been submitted. To complete the request, please check your original email.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }).catch(error => {
            this._showSpinner = false;
            let errorMap = JSON.parse(error.body.message);
            console.log(errorMap.error);
            this.showErrorToast(errorMap.message);
        })
    }

    changeUsername(event) {
        if (!this._newUsername) {
            this.showErrorToast('Please fill out all fields.');
            return;
        }
        const params = {params: {username:this._newUsername}}
        this._showSpinner = true;
        SERVER_changeUsername(params).then(res => {
            this._showChangeUsername = false;
            this._showSpinner = false;
            this._newUsername = '';
            this.user = res;
            this._user = JSON.parse(JSON.stringify(this.user));
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Username changed successfully',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }).catch(error => {
            this._showSpinner = false;
            let errorMap = JSON.parse(error.body.message);
            console.log(errorMap.error);
            this.showErrorToast(errorMap.message);
        })
    }

    showErrorToast(message){
        const event = new ShowToastEvent({
            title: 'Error!',
            message: message,
            variant:"error",
            mode:"sticky"
        });
        this.dispatchEvent(event);
    }
}