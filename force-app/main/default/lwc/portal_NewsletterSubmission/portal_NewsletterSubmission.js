import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SERVER_getSubmissionSetupInfo from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_getSubmissionSetupInfo';
import SERVER_getNewsletterSectionTemplates from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_getNewsletterSectionTemplates';
import SERVER_submitNewsletter from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_submitNewsletter';
import SERVER_getNewsletter from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_getFrontendNewsletter';
import SERVER_sendTestNewsletter from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_sendTestNewsletter';
import SERVER_getPreviewNewsletterHtml from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_getPreviewNewsletterHtml';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_NewsletterSubmission extends LightningElement {
    _DEFAULT_TEMPLATE = 'all';

    _isRecaptchaEnabled = false;
    _templates = {};
    _isShowListing = false;
    _availableZones = [];
    _mergeFields = [];
    _timezones = [];
    _greeting = '';
    _sectionList = [];
    _isShowContentModal = false;
    _isShowDeleteSectionModal = false;
    _isShowDeleteContentModal = false;
    _newsletterTemplates = [];
    _sectionIndex;
    _contentIndex;
    _isShowSpinner = false;
    _isCallbackDone = false;
    _emailString = '';
    _isShowSendTestModal = false;
    _listing = {Name:"", Subject_Line__c: "", Body_Content__c:"Dear ", Start_Date_Time__c: null, Time_Zone__c:"", Portal_Zone__c:""};
    _previewHTML = '';
    _isShowPreview = false;
    _organizationName = '';
    _cont = {};
    _portalUrl = '';
    _isContentModalSecondPage = false;
    _contentModalTitle = "Add Content";
    _titleText = '';
    _showSuccessMessage = false;
    _successMessage = 'Success!';
    _showErrorMessage = false;
    _errorMessage = 'Error!';
    _isSendTestOpenedFromPreview = false;
    _mergeFieldToInsert = '';

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_NewsletterControllerBase.submitNewsletter'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    get isDisableInsertMergeFieldButton() {
        return !this._mergeFieldToInsert;
    }

    get insertMergeFieldButtonClasses() {
        if (this.isDisableInsertMergeFieldButton) {
            return 'button secondary small full-mobile disabled';
        }

        return 'button secondary small full-mobile';
    }

    connectedCallback() {
        this._isShowSpinner = true;
        const params = {params:{}};
        SERVER_getSubmissionSetupInfo(params).then(res => {
            this._templates = {...res['templates']};
            this._organizationName = res['organizationName'];
            this._availableZones = [...res['portalZones']];
            this._mergeFields = [...res['mergeFields']];
            this._timezones = [...res['timezones']];
            this._cont = {...res['contact']};
            this._portalUrl = res['portalUrl'];
            this._titleText = 'Create Newsletter';
            SERVER_getNewsletterSectionTemplates(params).then(res => {
                this._newsletterTemplates = res;
                let urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('rid')) {
                    var isClone = urlParams.get('c') == 'true';
                    const recordParams = {params:{newsletterId: urlParams.get('rid'), clone: isClone}};
                    SERVER_getNewsletter(recordParams).then(res => {
                        this._listing = {...res, Start_Date_Time__c: this.getListingInputDateString(res?.Start_Date_Time__c)};

                        try {
                            delete this._listing['ucinn_portal_Newsletter_Sections__r'];
                            this.setupSectionList(res.ucinn_portal_Newsletter_Sections__r);
                            this._isShowListing = true;
                            if (isClone) {
                                this._titleText = 'Clone Newsletter'
                            } else {
                                this._titleText = 'Edit Newsletter'
                            }
                        } catch (e) {
                            console.log(e);
                        }

                    }).catch(e => {
                        console.log(e);
                        let errorMap = JSON.parse(e.body.message);
                        const toastEvent = new ShowToastEvent({
                            title: 'Error!',
                            message: errorMap.message,
                            variant:"error",
                            mode:"sticky"
                        });
                        this.dispatchEvent(toastEvent);

                    }).finally(() => {
                        this._isCallbackDone = true;
                        this._isShowSpinner = false;
                    });
                } else {
                    this._isCallbackDone = true;
                    this._isShowSpinner = false;
                }
            }).catch(e => {
                this._isCallbackDone = true;
                this._isShowSpinner = false;
                console.log(e);
                let errorMap = JSON.parse(e.body.message);
                const toastEvent = new ShowToastEvent({
                    title: 'Error!',
                    message: errorMap.message,
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(toastEvent);
            })
        }).catch(e => {
            this._isCallbackDone = true;
            this._isShowSpinner = false;
            console.log(e);
            let errorMap = JSON.parse(e.body.message);
            const toastEvent = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(toastEvent);

        });

    }

    setupSectionList(sectionList) {
        let currentIndex = 0;
        if (sectionList == null) {
            return;
        }
        for (let index = 0; index < sectionList.length; index++) {
            let section = sectionList[index];

            if (section) {
                if (!section.Body_Content__c) {
                    section['Body_Content__c'] = '';
                }
                if (!section.Header_Content__c) {
                    section['Header_Content__c'] = '';
                }
                if (!section.Image__c) {
                    section['Image__c'] = '';
                }
                if (!section.Image_Alternative_Text__c) {
                    section['Image_Alternative_Text__c'] = '';
                }
                if (!section.Start_Date_Time__c) {
                    section['Start_Date_Time__c'] = null;
                }
                if (!section.End_Date_Time__c) {
                    section['End_Date_Time__c'] = null;
                }
                if (!section.Location__c) {
                    section['Location__c'] = '';
                }
            }
            let htmlText = this.formatHtml(section);
            if (parseInt(section.Section_Number__c) == currentIndex) {
                if (this._sectionList[currentIndex]) {
                    this._sectionList[currentIndex]['newsletterSectionList'] = [...this._sectionList[currentIndex]['newsletterSectionList'], section];
                    this._sectionList[currentIndex]['htmlList'] = [...this._sectionList[currentIndex]['htmlList'], htmlText];
                } else {
                    let newSection = {Section_Title__c:section.Section_Title__c, Background_Color__c: section.Background_Color__c, newsletterSectionList: [section], htmlList:[htmlText]};
                    this._sectionList = [...this._sectionList, newSection];
                }
            } else {
                let newSection = {Section_Title__c:section.Section_Title__c, Background_Color__c: section.Background_Color__c, newsletterSectionList: [section], htmlList:[htmlText]};
                this._sectionList = [...this._sectionList, newSection];
                currentIndex = parseInt(section.Section_Number__c);
            }
        }
    }

    handleAvailableZone = (event) => {
        if (!event.currentTarget.value) {
            this._isShowListing = false;
            this.resetListingFormData();
        } else {        
            this._isShowListing = true;
        }

        this._listing.Portal_Zone__c = event.currentTarget.value;
    }

    handleMergeFieldSelection = (event) => {
        this._mergeFieldToInsert = event.currentTarget.value;
    }

    handleMergeFieldInsertion = (event) => {
        let content = this.template.querySelector('[data-target="richText"]');
        if (content && this._mergeFieldToInsert) {
            content.insertTextAtCursor(this._mergeFieldToInsert);
        }
    }

    resetListingFormData() {
        this._listing.Name = '';
        this._listing.Subject_Line__c = '';
        this._listing.Body_Content__c = '';
        this._listing.Start_Date_Time__c = '';
        this._listing.Time_Zone__c = '';
        this._sectionList = [];
        this._mergeFieldToInsert = '';
    }

    setRecordValue = (event) => {
        this._listing[event.currentTarget.name] = event.currentTarget.value;
    }

    addSection(event) {
        let newSection = {Section_Title__c:"", Background_Color__c: '', newsletterSectionList: [], htmlList:[]};
        this._sectionList = [...this._sectionList, newSection];
    }

    deleteSection(event) {
        let index = event.currentTarget.getAttribute('data-index');
        this._sectionList.splice(index, 1)
        this._sectionList = [...this._sectionList];
    }

    setSectionFieldValue = (event) => {
        let index = event.currentTarget.getAttribute('data-index');
        this._sectionList[index][event.currentTarget.name] = event.currentTarget.value;

    }

    openContentModal(event) {
        this._sectionIndex = event.currentTarget.getAttribute('data-index');
        this._contentIndex = event.currentTarget.getAttribute('data-section');
        this._isShowContentModal = true;
        this._isShowSpinner = true;
    }

    closeModal(event) { //closes all modals
        this._isShowContentModal = false;
        this._isShowSendTestModal = false;
        this._isShowDeleteSectionModal = false;
        this._isShowDeleteContentModal = false;
        this._isShowPreview = false;
        this._isContentModalSecondPage = false;
        this._contentIndex = null;
        this._sectionIndex = null;
        //stop propagating so elements behind the modal don't get clicked
        event.preventDefault();
        event.stopImmediatePropagation();
    }

    closeSendTestModal(event) { //closes only the test email modal
        this._isShowSendTestModal = false;
        //stop propagating so elements behind the modal don't get clicked
        event.preventDefault();
        event.stopImmediatePropagation();
    }

    clickIgnore(event) {
        //if clicking INSIDE the modal we want to stop propagating this click so modal doesn't close from the background
        event.preventDefault();
        event.stopImmediatePropagation();
    }

    handleCloseSuccess(event) {
        this._showSuccessMessage = false;
    }

    handleCloseError(event) {
        this._showErrorMessage = false;
    }

    openDeleteSectionModal(event) {
        this._sectionIndex = event.currentTarget.getAttribute('data-index');
        this._contentIndex = event.currentTarget.getAttribute('data-section');
        this._isShowDeleteSectionModal = true;
    }

    openDeleteContentModal(event) {
        this._sectionIndex = event.currentTarget.getAttribute('data-index');
        this._contentIndex  = event.currentTarget.getAttribute('data-section');
        this._isShowDeleteContentModal = true;
    }

    openSendTestModal(event) {
        this._isSendTestOpenedFromPreview = false;
        this._isShowSendTestModal = true;
    }

    openSendTestModalFromPreview(event) {
        this._isSendTestOpenedFromPreview = true;
        this._isShowPreview = false;
        this._isShowSendTestModal = true;
    }

    handleBack(event) {
        this.template.querySelector('c-portal_-newsletter-section-modal').setIsShowTemplates(true);
    }

    handleBackFromSendTest(event) {
        this._isShowPreview = true;
        this._isShowSendTestModal = false;
    }

    saveNewsletterContent(event) {
        try {
            let section = this.template.querySelector('c-portal_-newsletter-section-modal').getNewsletterSection();
            if (section) {
                let htmlText = this.formatHtml(section);
                if (this._sectionIndex) {
                    if (!this._contentIndex) {
                        if (this._sectionList[this._sectionIndex]['newsletterSectionList']) {
                            this._sectionList[this._sectionIndex]['newsletterSectionList'].push(section);
                        } else {
                            this._sectionList[this._sectionIndex]['newsletterSectionList'] = [section];
                        }
                        if (this._sectionList[this._sectionIndex]['htmlList']) {
                            this._sectionList[this._sectionIndex]['htmlList'].push(htmlText);
                        } else {
                            this._sectionList[this._sectionIndex]['htmlList']= [htmlText];
                        }
                        this._successMessage = 'New newsletter content has been added.';
                    } else {
                        this._sectionList[this._sectionIndex]['newsletterSectionList'][this._contentIndex] = section;
                        this._sectionList[this._sectionIndex]['htmlList'][this._contentIndex] = htmlText;
                        this._successMessage = 'Existing newsletter content has been edited.';
                    }

                    const toastEvent = new ShowToastEvent({
                        title: 'Success!',
                        message: this._successMessage,
                        variant:"success",
                        mode:"sticky"
                    });
                    this.dispatchEvent(toastEvent);
                    this.closeModal(event);
                }
            }

        } catch (error) {
            console.log(error);
        }

    }

    formatDateTimeLocation(section) {
        section.Start_Date_Time__c = this.getListingISODateString(section.Start_Date_Time__c)
        section.End_Date_Time__c = this.getListingISODateString(section.End_Date_Time__c);

        let dateTimeLocation = '<div style="font-weight: bold">';
        let startDate = this.formatDateTime(section.Start_Date_Time__c)[0];
        let endDate =  this.formatDateTime(section.End_Date_Time__c)[0];
        let startTime =  this.formatDateTime(section.Start_Date_Time__c)[1];
        let endTime = this.formatDateTime(section.End_Date_Time__c)[1];
        if (startDate || endDate){ // adds the time line
            dateTimeLocation += '<p>';
            if (startDate){
                dateTimeLocation += startDate;
                if (endDate){ // start and end
                    dateTimeLocation += '-' + endDate;
                }
            }
            else if (endDate && !startDate) {
                dateTimeLocation += endDate;
            }
            dateTimeLocation += '</p>';
        }
        if (startTime || endTime){
            dateTimeLocation += '<p>';
            if (startTime) {
                dateTimeLocation += startTime;
                if (endTime) {
                    dateTimeLocation += '-' + endTime;
                }
            }
            else if (endTime && !startTime){
                dateTimeLocation += endTime;
            }
            dateTimeLocation += '</p>';
        }

        // add location
        if (section.Location__c){
            dateTimeLocation += '<p>' + section.Location__c +'</p>'
        }

        if (dateTimeLocation) {
            dateTimeLocation += '<br></div>';
        }

        return dateTimeLocation;
    }

    // convert dateTime string into [MM/DD/YYYY, HH:mm p.m.] list
    formatDateTime(dateTime) {
        if (!dateTime) {
            return [null, null];
        }

        let result = dateTime.split('T');
        let time = result[0]; // YYYY-MM-DD
        let dateSplit = time.split('-');
        let date = result[1].substring(0, 6); // HH:MM:SS (24 hour time)
        let timeSplit = date.split(':');

        // remove leading 0
        if (timeSplit[0][0] == 0) {
            timeSplit[0] = timeSplit[0][1];
        }

        // format time
        if (timeSplit[0] > 12 && timeSplit[0] < 24){ //pm
            var formattedTime = (timeSplit[0])-12 + ':' + timeSplit[1] + ' p.m.';
        } else if (timeSplit[0] == 0) {
            var formattedTime = '12:' + timeSplit[1]  + ' a.m.';
        } else if (timeSplit[0] == 12) {
            var formattedTime = '12:' + timeSplit[1]  + ' p.m.';
        }
        else { // am
            var formattedTime = timeSplit[0] + ':' + timeSplit[1] + ' a.m.';
        }

        //format date
        let formattedDate = dateSplit[1] +'/' + dateSplit[2] +'/' + dateSplit[0];

        return [formattedDate, formattedTime];

    }

    formatHtml(section) {
        let htmlText = '';
        for (let index = 0; index < this._newsletterTemplates.length; index++) {
            let template = this._newsletterTemplates[index];
            if (template.Name == section.Selected_Module__c) {
                htmlText = template.Newsletter_HTML__c;
                if (htmlText.includes('img')) {
                    if (section.Image__c.includes('src')) {
                        let re = new RegExp('src\s*=\s*"(.+?)"');
                        let matches = section.Image__c.match(re);
                        if (matches && matches.length >= 2) {
                            if (matches[1].includes('servlet')) {
                                htmlText = htmlText.replace('{imageURL}', this._portalUrl +  matches[1]);
                            } else {
                                htmlText = htmlText.replace('{imageURL}', matches[1]);
                            }

                        }
                        let altText = new RegExp('alt\s*=\s*"(.+?)"');
                        let altTextMatches = section.Image__c.match(altText);
                        if (altTextMatches && altTextMatches.length >= 2) {
                            htmlText = htmlText.replace('{imageAltText}', altTextMatches[1]);
                        } else {
                            htmlText = htmlText.replace('{imageAltText}', '');
                        }
                    } else {
                        let imageStartIndex = htmlText.indexOf('<img');
                        let imageEndIndex = htmlText.indexOf('</img>') + 6;
                        let imageString = htmlText.substring(imageStartIndex, imageEndIndex);
                        htmlText = htmlText.replace(imageString, section.Image__c);
                    }
                }
                htmlText = htmlText.replace('{headerContent}', section.Header_Content__c);
                htmlText = htmlText.replace('{bodyContent}', section.Body_Content__c);
                let dateTimeLocation = this.formatDateTimeLocation(section);
                htmlText = htmlText.replace('{dateTimeLocation}', dateTimeLocation);
                htmlText = htmlText.replace('{headerURL}', section.Header_URL__c);
            }
        }
        return htmlText;
    }

    handleEditNewsletterSection(event) {
        this._sectionIndex = event.currentTarget.getAttribute('data-index');
        this._contentIndex = event.currentTarget.getAttribute('data-section');
        this._isShowContentModal = true;
        this._isShowSpinner = true;
    }

    onNewsletterSectionModalReady(event) {
        this._contentModalTitle = "Add Content";
        if (this._contentIndex) {
            this._contentModalTitle = "Edit Content";
            this.template.querySelector('c-portal_-newsletter-section-modal').setIsShowTemplates(false);
            this.template.querySelector('c-portal_-newsletter-section-modal').setNewsletterSection(this._sectionList[this._sectionIndex]['newsletterSectionList'][this._contentIndex]);
        }
        this._isShowSpinner = false;
    }

    handleContentModalTemplatesChange = (isShowTemplates) => {
        this._isContentModalSecondPage = !isShowTemplates;
    }

    handleDeleteNewsletterSection(event) {
        this._sectionList.splice(this._sectionIndex, 1)
        this._sectionList = [...this._sectionList];

        const toastEvent = new ShowToastEvent({
            title: 'Success!',
            message: 'This section has been deleted',
            variant:"success",
            mode:"sticky"
        });
        this.dispatchEvent(toastEvent);

        this.closeModal();
    }

    handleDeleteContent(event) {
        this._sectionList[this._sectionIndex]['newsletterSectionList'].splice(this._contentIndex, 1);
        this._sectionList[this._sectionIndex]['htmlList'].splice(this._contentIndex, 1);
        const toastEvent = new ShowToastEvent({
            title: 'Success!',
            message: 'The content has been deleted',
            variant:"success",
            mode:"sticky"
        });
        this.dispatchEvent(toastEvent);

        this.closeModal();
    }

    moveSectionUp(event) {
        this._isShowSpinner = true;
        let index = parseInt(event.currentTarget.getAttribute('data-index'));
        let sectionIndex  = parseInt(event.currentTarget.getAttribute('data-section'));
        if (sectionIndex > 0) {
            let prevSection = this._sectionList[index]['newsletterSectionList'][sectionIndex - 1];
            this._sectionList[index]['newsletterSectionList'][sectionIndex - 1] = this._sectionList[index]['newsletterSectionList'][sectionIndex];
            this._sectionList[index]['newsletterSectionList'][sectionIndex] = prevSection;
            let prevHtml = this._sectionList[index]['htmlList'][sectionIndex - 1];
            this._sectionList[index]['htmlList'][sectionIndex - 1] = this._sectionList[index]['htmlList'][sectionIndex];
            this._sectionList[index]['htmlList'][sectionIndex] = prevHtml;
        } else if (index > 0) {
            let prevSection = this._sectionList[index]['newsletterSectionList'][sectionIndex];
            this._sectionList[index]['newsletterSectionList'].splice(sectionIndex, 1);
            this._sectionList[index-1]['newsletterSectionList'] = [...this._sectionList[index-1]['newsletterSectionList'], prevSection];
            let prevHtml = this._sectionList[index]['htmlList'][sectionIndex];
            this._sectionList[index]['htmlList'].splice(sectionIndex, 1);
            this._sectionList[index-1]['htmlList'] = [...this._sectionList[index-1]['htmlList'], prevHtml];
        }
        this._isShowSpinner = false;

    }

    moveSectionDown(event) {
        this._isShowSpinner = true;
        let index = parseInt(event.currentTarget.getAttribute('data-index'));
        let sectionIndex  = parseInt(event.currentTarget.getAttribute('data-section'));
        if (sectionIndex + 1 < this._sectionList[index]['newsletterSectionList'].length) {
            let nextSection = this._sectionList[index]['newsletterSectionList'][sectionIndex + 1];
            this._sectionList[index]['newsletterSectionList'][sectionIndex + 1] = this._sectionList[index]['newsletterSectionList'][sectionIndex];
            this._sectionList[index]['newsletterSectionList'][sectionIndex] = nextSection;
            let nextHtml = this._sectionList[index]['htmlList'][sectionIndex + 1];
            this._sectionList[index]['htmlList'][sectionIndex + 1] = this._sectionList[index]['htmlList'][sectionIndex];
            this._sectionList[index]['htmlList'][sectionIndex] = nextHtml;
        } else if (index + 1 < this._sectionList.length) {
                let nextSection = this._sectionList[index]['newsletterSectionList'][sectionIndex];
                this._sectionList[index]['newsletterSectionList'].splice(sectionIndex, 1);
                this._sectionList[index+1]['newsletterSectionList'] = [nextSection,...this._sectionList[index+1]['newsletterSectionList']];
                let nextHtml = this._sectionList[index]['htmlList'][sectionIndex];
                this._sectionList[index]['htmlList'].splice(sectionIndex, 1);
                this._sectionList[index+1]['htmlList'] = [nextHtml,...this._sectionList[index+1]['htmlList']];

        }
        this._isShowSpinner = false;
    }

    handleSubmit(event) {
        this._isShowSpinner = true;

        if (!this._listing.Name || !this._listing.Subject_Line__c || !this._listing.Start_Date_Time__c) {
            const toastEvent = new ShowToastEvent({
                title: 'Error!',
                message: 'Please fill out all required fields.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(toastEvent);
            this._isShowSpinner = false;
            return;
        }

        submitForm(this, this.submissionLogic, (error) => {
            this._isShowSpinner = false;
            console.log(error);
        });

    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        let newsletterSectionList = [];
        for (let index = 0; index < this._sectionList.length; index++) {
            let section = this._sectionList[index];
            for (let sectionIndex = 0; sectionIndex < section['newsletterSectionList'].length; sectionIndex++) {
                let newletterSection = section['newsletterSectionList'][sectionIndex];
                if (newletterSection) {
                    newletterSection['Section_Title__c'] = section['Section_Title__c'];
                    newletterSection['Background_Color__c'] = section['Background_Color__c'];
                    newletterSection['Order_In_Section__c'] = sectionIndex;
                    newletterSection['Section_Number__c'] = index;
                    newsletterSectionList.push(newletterSection);
                }
            }
        }

        let listingClone = {...this._listing, Start_Date_Time__c: this.getListingISODateString(this._listing?.Start_Date_Time__c)};

        const params = {listing: listingClone, newsletterSectionsList: newsletterSectionList, recaptchaToken: recaptchaToken};
        callApexFunction(this, SERVER_submitNewsletter, params, () => {
            const toastEvent = new ShowToastEvent({
                title: 'Success!',
                message: 'Your newsletter was submitted successfully',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(toastEvent);
            this._isShowSpinner = false;
            window.location.href = 'my-newsletters';
        }, (error) => {
            this._isShowSpinner = false;
            console.log(error);
            errorRecaptchaCallback();
        })
    }

    displayPreview(event) {
        this._isShowSpinner = true;
        this._previewHTML = '';
        this._isShowPreview = true;
        let newsletterSectionList = [];
        for (let index = 0; index < this._sectionList.length; index++) {
            let section = this._sectionList[index];
            for (let sectionIndex = 0; sectionIndex < section['newsletterSectionList'].length; sectionIndex++) {
                let newletterSection = section['newsletterSectionList'][sectionIndex];
                if (newletterSection) {
                    newletterSection['Section_Title__c'] = section['Section_Title__c'];
                    newletterSection['Background_Color__c'] = section['Background_Color__c'];
                    newletterSection['Order_In_Section__c'] = sectionIndex;
                    newletterSection['Section_Number__c'] = index;
                    newsletterSectionList.push(newletterSection);
                }
            }
        }

        let listingClone = {...this._listing, Start_Date_Time__c: this.getListingISODateString(this._listing?.Start_Date_Time__c)};

        const params = {params:{listing: listingClone, newsletterSectionsList: newsletterSectionList}};
        SERVER_getPreviewNewsletterHtml(params).then(res => {
            this._previewHTML = res;
        }).catch(error => {
            this._isShowPreview = false;
            console.log(error);
            let errorMap = JSON.parse(error.body.message);
            const toastEvent = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(toastEvent);
        }).finally(() => {
            this._isShowSpinner = false;
        });
    }

    sendTestNewsletter(event) {
        this._isShowSpinner = true;
        let newsletterSectionList = [];
        for (let index = 0; index < this._sectionList.length; index++) {
            let section = this._sectionList[index];
            for (let sectionIndex = 0; sectionIndex < section['newsletterSectionList'].length; sectionIndex++) {
                let newletterSection = section['newsletterSectionList'][sectionIndex];
                if (newletterSection) {
                    newletterSection['Section_Title__c'] = section['Section_Title__c'];
                    newletterSection['Background_Color__c'] = section['Background_Color__c'];
                    newletterSection['Order_In_Section__c'] = sectionIndex;
                    newletterSection['Section_Number__c'] = index;
                    newsletterSectionList.push(newletterSection);
                }
            }
        }

        let listingClone = {...this._listing, Start_Date_Time__c: this.getListingISODateString(this._listing?.Start_Date_Time__c)};

        const params = {params: {listing: listingClone, newsletterSectionsList: newsletterSectionList, email: this._emailString}};
        SERVER_sendTestNewsletter(params).then(res => {
            const toastEvent = new ShowToastEvent({
                title: 'Success!',
                message: 'Your newsletter was submitted successfully',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(toastEvent);
        }).catch(error => {
            console.log(error);
            let errorMap = JSON.parse(error.body.message);
            const toastEvent = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(toastEvent);
        }).finally(() => {
            this._isShowSendTestModal = false;
            this._isShowSpinner = false;
        })
    }

    handleEmailStringChange = (event) => {
        this._emailString = event.currentTarget.value;
    }
    
    // datetime ISO string for Salesforce (de)serialization
    getListingISODateString(datetimeString) {
        if (!datetimeString || datetimeString.endsWith(':00.000Z')) {
            return datetimeString;
        }

        // 'YYYY-MM-DDTHH:mm' used by <input> must become 'YYYY-MM-SSTHH:mm:ss.mssZ' for Listing in Salesforce
        return (new Date(datetimeString + 'Z')).toISOString();
    }

    // datetime string for <input>
    getListingInputDateString(datetimeString) {
        if (!datetimeString) {
            return null;
        }

        return datetimeString.replace(':00.000Z', '');
    }
}