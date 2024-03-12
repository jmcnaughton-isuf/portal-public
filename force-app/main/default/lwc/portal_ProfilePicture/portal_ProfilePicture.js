import { LightningElement, api, wire, track } from 'lwc';
import getProfilePictureInfoFromConstituentOrOrganization from '@salesforce/apex/PORTAL_ProfilePictureController.getProfilePictureInfoFromConstituentOrOrganization';
import defaultProfilePictureUrl from '@salesforce/resourceUrl/PORTAL_ProfileDefault';
import {formatRelativeUrlWithRootPath} from 'c/portal_util_Urls';

export default class Portal_ProfilePicture extends LightningElement {
    @api altText = '';
    @api isForCurrentUser = false;
    @api recordId = '';
    @api imageStyle = '';

    @track _pictureSrc = '';
    _defaultProfilePictureUrl = defaultProfilePictureUrl;

    @wire (getProfilePictureInfoFromConstituentOrOrganization, {recordId: '$recordId', getCurrentUser: '$isForCurrentUser'})
    setProfilePictureSource({error, data}) {
        if (error) {
            console.log(error);
        }

        if (data) {
            let contentDocId = data.profilePictureId;

            if (contentDocId) {
                this._pictureSrc = formatRelativeUrlWithRootPath('/sfc/servlet.shepherd/version/download/' + contentDocId);
            }
        }
    }
}