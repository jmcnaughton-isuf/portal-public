import { LightningElement, api, track } from 'lwc';
import globalCSS from '@salesforce/resourceUrl/Portal_Global_CSS';
import hamResourceUrl from '@salesforce/resourceUrl/Portal_Ham';
import { loadStyle } from 'lightning/platformResourceLoader';
import isGuestUser from '@salesforce/user/isGuest';
import {communitySitePath, formatRelativeUrlWithRootPath, formatRelativeUrlWithSitePath} from 'c/portal_util_Urls';

export default class Portal_NavigationOR extends LightningElement {
    @api logoUrl = '/resource/Portal_HeaderLogo';
    @api loginUrl = '/s/login';
    @api firstRowNavigation = "[{\"label\": \"My Information\", \"link\": \"my-information\", \"needsLoggedInUser\":true}, {\"label\": \"Donors\", \"submenu\": [{\"label\": \"Give\", \"link\": \"give\" , \"needsLoggedInUser\":false}, {\"label\": \"Giving History\", \"link\": \"giving-history\", \"needsLoggedInUser\":true}]}]";
    @api secondRowNavigation = "";
    @api backgroundColor;

    @track _firstRowNavigation = [];
    @track _secondRowNavigation = [];
    @track _profileActionClass = 'profile-action';
    @track _mobileDropDownClass = 'menu';

    _hamResourceUrl = hamResourceUrl;

    get communityLogoUrl() {
        return formatRelativeUrlWithRootPath(this.logoUrl);
    }

    get communityLoginUrl() {
        return formatRelativeUrlWithRootPath(this.loginUrl);
    }

    get isLoggedInUser() {
        if (isGuestUser) {
            return false;
        }

        return true;
    }

    get homeUrl() {
        return communitySitePath + '/';
    }

    get colorStyle() {
        return 'background-color: ' + this.backgroundColor;
    }

    get top() {
        return 'top';
    }

    connectedCallback() {
        loadStyle(this, globalCSS);
        this._firstRowNavigation = JSON.parse(this.firstRowNavigation);

        for (let eachNavItem of this._firstRowNavigation) {
            if (eachNavItem.needsLoggedInUser && !this.isLoggedInUser) {
                eachNavItem.isHidden = true;
            }

            // this.prependNavLinkRelativeUrls(eachNavItem);

            if (eachNavItem.submenu) {
                eachNavItem.subMenuClass = 'item has-submenu';

                for (let eachSubItem of eachNavItem.submenu) {
                    if (eachSubItem.needsLoggedInUser && !this.isLoggedInUser) {
                        eachSubItem.isHidden = true;
                    }

                    // this.prependNavLinkRelativeUrls(eachSubItem);
                }
            }
        }
    }

    prependNavLinkRelativeUrls(navItem) {
        if (!navItem || !navItem.link || navItem.link.startsWith('http')) {
            return;
        }

        navItem.link = formatRelativeUrlWithSitePath(navItem.link);
    }

    handleLogOut() {
        window.location.replace(formatRelativeUrlWithRootPath("/secur/logout.jsp"));
    }

    handleProfileClick() {
        if (this._profileActionClass === 'profile-action show') {
            this._profileActionClass = 'profile-action';
        } else {
            this._profileActionClass = 'profile-action show';
        }
    }

    handleHamburgerClick() {
        if (this._mobileDropDownClass === 'menu') {
            this._mobileDropDownClass = 'menu active';
        } else {
            this._mobileDropDownClass = 'menu';
        }
    }

    handleSubmenuDropdown(event) {
        let label = event.target.dataset.label;

        for (let eachNavItem of this._firstRowNavigation) {
            if (eachNavItem.label === label && eachNavItem.submenu) {
                if (eachNavItem.subMenuClass === 'item has-submenu') {
                    eachNavItem.subMenuClass = 'item has-submenu submenu-active';
                } else {
                    eachNavItem.subMenuClass = 'item has-submenu';
                }

                break;
            }
        }
    }
}