import { LightningElement, api } from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import Utility from 'c/isufWebUtility';

export default class IsufWebFooter extends NavigationMixin(LightningElement) {
    @api quickLink1Text;
    @api quickLink1;
    @api quickLink2Text;
    @api quickLink2;
    @api quickLink3Text;
    @api quickLink3;
    @api quickLink4Text;
    @api quickLink4;
    @api youtubeLink;
    @api linkedinLink;
    @api facebookLink;
    @api instagramLink;
    @api emailAddress;
    @api phoneNumber;
    @api tollFreeNumber;
    @api imageLink;


    handleRedirect (event) {
        event.preventDefault();
        let {src, type} = event.currentTarget.dataset;
        if (type == 'EMAIL') {
            window.location.href = 'mailto:' + src;
        } else if (type == 'PHONE') {
            window.location.href = 'tel:' + src;
        } else  {
            this[NavigationMixin.Navigate](Utility.handleNavigation(src));
        }
    }
}