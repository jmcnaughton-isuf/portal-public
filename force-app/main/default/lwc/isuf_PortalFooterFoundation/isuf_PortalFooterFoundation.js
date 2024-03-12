/**
 * Created by jmcnaughton on 4/17/2023.
 */

import {LightningElement} from 'lwc';
import ISUF_LOGO from '@salesforce/resourceUrl/isu_foundation_reversed';
import FB from '@salesforce/resourceUrl/facebook';
import IN from '@salesforce/resourceUrl/instagram';
import LI from '@salesforce/resourceUrl/linkedin';
import TW from '@salesforce/resourceUrl/twitter';
import YT from '@salesforce/resourceUrl/youtube';
import privacyPolicy from '@salesforce/resourceUrl/Portal_ISUF_Policy';
import terms from '@salesforce/resourceUrl/Portal_ISUF_Terms';

export default class IsufPortalFooterFoundation extends LightningElement {

    logo;
    facebook
    linkedin;
    instagram;
    twitter;
    youtube;
    privacyPolicy;
    terms;
    connectedCallback() {
        this.logo = ISUF_LOGO
        this.facebook = FB;
        this.linkedin = LI;
        this.instagram = IN;
        this.twitter = TW;
        this.youtube = YT;
        this.privacyPolicy = privacyPolicy;
        this.terms = terms;
    }

}