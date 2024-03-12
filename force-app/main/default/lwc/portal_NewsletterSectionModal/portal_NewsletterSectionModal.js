import { LightningElement, api, track } from 'lwc';
import SERVER_getNewsletterSectionTemplates from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_getNewsletterSectionTemplates';
import SERVER_searchForListings from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_searchForListings';

export default class Portal_NewsletterSectionModal extends LightningElement {

    @api listingList = [];

    @track _newsletterTemplates = [];
    _altText = "";
    _headerContent = 'Sample Title';
    _headerURL = '';
    _bodyContent = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean fermentum consequat rhoncus. Duis bibendum elit sed magna laoreet, vel lobortis risus facilisis. Donec et mattis velit. In eget tortor nec sapien volutpat faucibus. Maecenas varius fringilla massa, in lobortis justo imperdiet dictum. Sed dictum tempus bibendum. Vivamus sagittis ut sem nec iaculis.';
    _dateTimeLocation = '<p data-aura-rendered-by="859:0">mm/dd/yyyy-mm/dd/yyyy</p><p data-aura-rendered-by="861:0">00:00 a.m, - 00:00 p.m.</p><p data-aura-rendered-by="863:0">Venue Name Lorem Ipsum Dolor, City, State</p>';
    _isShowTemplates = true;
    _searchText = "";
    _listing;
    _section = {Body_Content__c : "", Header_Content__c:"", Image__c:"", Image_Alternative_Text__c:"", Header_URL__c:"", Start_Date_Time__c:null, End_Date_Time__c:null, Location__c:""};
    _isShowImageDetails = false;
    _isShowEventDetails = false;
    _moduleNameToDetailsMap = {};
    _callbackDone = false;
    _isShowSpinner = false;
    _allowedImageFormats = ['image'];

    @api handleIsShowTemplatesChange = () => {};

    @api setIsShowTemplates(value) {
        this._isShowTemplates = value;
        this.handleIsShowTemplatesChange(this._isShowTemplates);
    }

    @api getNewsletterSection() {
        return this._section;
    }

    @api setNewsletterSection(value) {
        this._section = {...value};
        if (this._section) {
            if (!this._section.Body_Content__c) {
                this._section['Body_Content__c'] = '';
            }
            if (!this._section.Header_Content__c) {
                this._section['Header_Content__c'] = '';
            }
            if (!this._section.Image__c) {
                this._section['Image__c'] = '';
            }
            if (!this._section.Image_Alternative_Text__c) {
                this._section['Image_Alternative_Text__c'] = '';
            }
            if (!this._section.Start_Date_Time__c) {
                this._section['Start_Date_Time__c'] = null;
            }
            if (!this._section.End_Date_Time__c) {
                this._section['End_Date_Time__c'] = null;
            }
            if (this._section.Start_Date_Time__c) {
                this._section.Start_Date_Time__c = this._section.Start_Date_Time__c.replace(':00.000Z', '');
            }
            if (this._section.End_Date_Time__c) {
                this._section.End_Date_Time__c = this._section.End_Date_Time__c.replace(':00.000Z', '');
            }
            if (!this._section.Location__c) {
                this._section['Location__c'] = '';
            }
            if (!this._section.Header_URL__c) {
                this._section['Header_URL__c'] = '';
            }
        }
        this._isShowImageDetails = this._moduleNameToDetailsMap[this._section.Selected_Module__c.toString()].hasImage;
        this._isShowEventDetails = this._moduleNameToDetailsMap[this._section.Selected_Module__c.toString()].isEvent;

    }

    get hasListings() {
        return this.listingList && this.listingList.length > 0;
    }

    connectedCallback() {
        const params = {params:{}};
        SERVER_getNewsletterSectionTemplates(params).then(res => {
            if (res && res.length > 0) {
                for (let index = 0; index < res.length; index++) {
                    let isEvent = false;
                    let hasImage = false;
                    let htmlText = res[index].Newsletter_HTML__c;
                    if (htmlText.includes('{imageURL')) {
                        hasImage = true;
                    }

                    if (res[index].Image__c != '') {
                        htmlText = htmlText.replace('{imageURL}', res[index].Image__c);
                    }

                    htmlText = htmlText.replace('{imageAltText}', this._altText);
                    htmlText = htmlText.replace('{headerContent}', this._headerContent);
                    htmlText = htmlText.replace('{bodyContent}', this._bodyContent);
                    htmlText = htmlText.replace('{headerURL}', this._headerURL);
                    if (htmlText.includes('{dateTimeLocation}')) {
                        isEvent = true;
                    }
                    htmlText = htmlText.replace('{dateTimeLocation}', this._dateTimeLocation);
                    htmlText = '<div style="pointer-events: none; cursor: default"><table width="100%" cellpadding="0" cellspacing="0"><tbody>' + htmlText + '</tbody></table></div>';

                    this._moduleNameToDetailsMap[res[index].Name.toString()] = {};
                    this._moduleNameToDetailsMap[res[index].Name.toString()]['hasImage'] = hasImage;
                    this._moduleNameToDetailsMap[res[index].Name.toString()]['isEvent'] = isEvent;
                    this._newsletterTemplates.push({htmlText: htmlText, Name:res[index].Name, isEvent:isEvent, hasImage:hasImage});
                }
            }
        }).catch(console.error)
        .finally(() => {
            this._callbackDone = true;
            this.dispatchEvent(new CustomEvent("ready"));
        });
    }

    handleTemplateSelection(event) {
        let name = event.currentTarget.getAttribute('data-name');
        this._isShowEventDetails = event.currentTarget.getAttribute('data-event') == 'true' ? true : false;
        this._isShowImageDetails = event.currentTarget.getAttribute('data-image')  == 'true' ? true : false;
        this._section['Selected_Module__c'] = name;
        this._isShowTemplates = false;
        this.handleIsShowTemplatesChange(this._isShowTemplates);
    }

    handleSearchTextChange = (event) => {
        this._searchText = event.currentTarget.value;
        this.searchForListings();

    }

    searchForListings() {
        if (this._searchText.length > 3) {
            this._isShowSpinner = true;
            const params={params:{searchText:this._searchText}};
            SERVER_searchForListings(params).then(res => {
                if (res && res.length > 0) {
                    this.listingList = res;
                }
            }).catch(error => {
                console.log(error);
            }).finally(() => {
                this._isShowSpinner = false;
            });
        }
    }

    handleKeyUp = (event) => {
        if (event.key == "Enter") {
            this.searchForListings();
        }
    }

    handleSearchTextClear = () => {
        this._searchText = "";
        this.listingList = [];
    }

    handleLookupOptionClick(event) {
        let index = event.currentTarget.getAttribute('data-index');
        this._listing = this.listingList[index];
        this._searchText = this._listing.Name;
        this.listingList = [];
    }

    setRecordValue = (event) => {
        let name = event.currentTarget.name;
        
        if (name) {
            this._section[name] = event.currentTarget.value;
        }
    }

    handleAutoPopulate(event) {
        if (this._listing) {
            let value = event.currentTarget.getAttribute('data-value');
            if (value == 'image') {
                if (this._listing.Header_Image__c) {
                    this._section['Image__c'] = this._listing.Header_Image__c;
                } else if (this._listing.Header_Image_from_URL__c) {
                    this._section['Image__c'] = '<img src="' + this._listing.Header_Image_from_URL__c + '"/>'
                }
            } else if (value == 'header') {
                if (this._listing.Header_Content__c) {
                    this._section['Header_Content__c'] = this._listing.Header_Content__c;
                }
            } else if (value == 'body') {
                if (this._listing.Body_Content__c) {
                    this._section['Body_Content__c'] = this._listing.Body_Content__c;
                }
            } else if (value == 'event') {
                let startDateTime = this._listing.Event_Actual_Start_Date_Time__c;
                let endDateTime = this._listing.Event_Actual_End_Date_Time__c;

                if (startDateTime) {
                    startDateTime = startDateTime.replace(' ', 'T');
                    startDateTime = startDateTime + 'Z';
                    this._section['Start_Date_Time__c'] = startDateTime;
                }

                if (endDateTime) {
                    endDateTime = endDateTime.replace(' ', 'T');
                    endDateTime = endDateTime + 'Z';
                    this._section['End_Date_Time__c'] = endDateTime;
                }

                let location = '';

                if (this._listing.Street__c){
                    location = this._listing.Street__c;
                }

                if (this._listing.City__c){
                    if (this._listing.Street__c) {
                         location += ', ';
                    }
                    location += this._listing.City__c;
                }

                if (this._listing.State__c) {
                    if (this._listing.City__c) {
                        location += ', ';
                    }
                    location += this._listing.State__c;
                }
                this._section['Location__c'] = location;
            }
            this._section = {...this._section};
        }
    }
}