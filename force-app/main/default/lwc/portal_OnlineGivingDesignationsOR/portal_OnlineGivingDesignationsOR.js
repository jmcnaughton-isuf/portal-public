import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import getFeaturedDesignations from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getFeaturedDesignations';
import SERVER_getAllDesignations from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getAllDesignations';
//import SERVER_getDesignationsByCategory from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getDesignationsByCategory';
import SERVER_getDesignationsByCategory from '@salesforce/apex/PORTAL_OnlineGivingCustomExtension.SERVER_getDesignationsByCategory';
import SERVER_getDesignationsByParentId from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getDesignationsByParentId';
import SERVER_searchDesignations from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_searchDesignations';
//import SERVER_searchDesignations from '@salesforce/apex/PORTAL_OnlineGivingCustomExtension.searchDesignations';
import searchLogo from '@salesforce/resourceUrl/portal_searchlogo';
import searchLogoWhite from '@salesforce/resourceUrl/portal_searchlogowhite';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
export default class Portal_OnlineGivingDesignationsOR extends LightningElement {

    @api componentLabel;
    @api componentVersion;
    @api baseButtonColor;
    @api selectedButtonColor;
    @api pageSectionName;
    @api featuredDesignationList;
    @api maxNumberOfDesignations;
    @api selectMoreLabel;
    @api otherDesignationLabel;
    @api designationLevelLabels;
    @api BlankCategoryLabel;
    @api modalTitle;
    @api modalText;
    @api pageName;
    @api groupFields;
    @api customMetadataApiName;
    @api customMetadataDeveloperName;
    @api textColor;
    @api showMoreButton;
    @api useSearch;
    @api modalFormat;
    @api maxAmount;

    @wire(MessageContext) messageContext;
    _featuredDesignationsList = [];
    _callbackDone = false;
    @track _selectedDesignationsList = [];
    @track _temporaryDesignationList = [];
    @track addedDesignationsList = [];
    _showModal = false;
    _allDesignations = [];
    _categoryDesignations = [];
    _numberOfDesignations = 0;
    _subscription = null;
    _clearList = true;
    _lookupLabelSet = true;
    _displaySettingList = [];
    _showLookup = false;
    _featuredDesignationColumnSize = 6;
    _page = 'giving';
    _designationHierachyMap = {};
    _pledgeDesignations = [];
    @track _searchDesignationList = [];
    _searchDesignationSize = 0;
    _keyword = '';
    @track _hierarchyTemporaryDesignationList = [];
    @track _selectedHierarchyDesignations = [];
    _topSelectedHierarchyDesignation = '';
    @track _showSpinner = false;
    @track _categoryComboDesignations = [];
    @track _categoryfundDesignations = [];
    _categorySelected = [];
    @track _categoryFundSelected = [];
    _categoryFundMap = {};
    @track isShowDesignations;
    @track isMoreButton = false;
    @track _amount = [];
    @track _selectedAmount;
    @track _totalAmount = 0;
    @track _addButtonDisabled = false;
    @track _addMoreButtonDisabled = true;
    @track _showFinishButton = false;
    @track _addMoreFunds =[];
    @track _firstTimeFund = true;
    @track _showOtherFund = false;
    @track searchBarLogo = searchLogo;
    @track showOtherInput = false;
    _hierarchyList = [];
    // added
    @api defaultGivingAmounts;
    _defaultGivingAmountList = [];
    //TODO: move templates into their own html
    //TODO: use portal_util_ApexCallout for callouts
    _comboboxOptionList = [];
    @api fieldNamesString;
    get selectedDesignationsList() {
        return this._selectedDesignationsList;
    }

    set selectedDesignationsList(value) {
        this._selectedDesignationsList = value;
        this.setColor();
    }

    get headerStyle() {
        return "margin-bottom: .5em;" + 'color: ' + this.textColor + ';';
    }

    get isShowComponent() {
        return this._page == this.pageName;
    }

    get isCategoryModal() {
        return this.modalFormat === 'Category';
    }

    get isFlatModal() {
        return this.modalFormat === 'Flat';
    }

    get isHierarchyModal() {
        return this.modalFormat === 'Hierarchy';
    }

    get topDesignationLevelLabel() {
        if (this.designationLevelLabels[0]) {
            return this.designationLevelLabels[0]
        } else {
            return '';
        }
    }

    get showAddButton() {
        return (this._selectedHierarchyDesignations
            && this._selectedHierarchyDesignations.length > 0
            && ( this._selectedHierarchyDesignations[0] == 'Other' /* this would mean the 'other' designation is selected */
                || this._designationHierachyMap[this._selectedHierarchyDesignations[this._selectedHierarchyDesignations.length - 1]]?.length == 0));
    }

    // added for customization.
    getcategoryComboBoxOptionList() {
        let comboBoxOptionList = [];
        this._categoryFundMap = new Map();
        if(this._categoryDesignations.length > 0) {
            for (let designation of this._categoryDesignations) {
                var index = this.addedDesignationsList.findIndex(x => (x.Id == "Other" && designation.category == this.otherDesignationLabel && !this._firstTimeFund));
                if (index === -1) {
                    comboBoxOptionList.push({label: designation.category, value: designation.category});
                    console.log('desgination : ' + designation.category);
                }
                this._categoryFundMap.set(designation.category, designation.designations);
            }
        }
        this._comboboxOptionList = comboBoxOptionList;
    }

    //added for customization
    get getcategoryfundDesignations() {
        let comboBoxOptionList = [];
        console.log('called getter method:: '+JSON.stringify(comboBoxOptionList));
        console.log('called Combo:: '+JSON.stringify(this._categoryComboDesignations));
        console.log('called Category:: '+JSON.stringify(this._categoryDesignations));
        console.log('Entered child combo box-->');
        return this._categoryfundDesignations;
    }

    get hierarchyComboBoxOptionList() {
        let comboBoxOptionList = [];

        if(!this._selectedHierarchyDesignations || !this._designationHierachyMap) {
            return comboBoxOptionList
        }
        let depth = 1;
        for (let chosenDesignationId of this._selectedHierarchyDesignations) {
            let designationLevelList = this._designationHierachyMap[chosenDesignationId];
            let optionLevelList = [];

            if (designationLevelList && designationLevelList.length > 0) {
                optionLevelList.push({label: 'Select an Option', value: ''});
                for (let designation of designationLevelList) {
                    optionLevelList.push({label: designation.Name, value: designation.Id});
                }
                if(this.otherDesignationLabel) {
                    optionLevelList.push({"Name":this.otherDesignationLabel, "Id": "Other"})
                }
                let levelLabel = '';
                if (this.designationLevelLabels) {
                    levelLabel = this.designationLevelLabels[depth];
                }

                comboBoxOptionList.push({"options":optionLevelList,"depth":depth, "key": Date.now(), "label":levelLabel, "value":this._selectedHierarchyDesignations[depth]});
            }
            depth++;
        }
        return comboBoxOptionList;
    }

    get topHierarchyComboBoxOptionList() {
        let comboBoxOptionList = [];
        let designationLevelList = this._designationHierachyMap[''];
        if (!designationLevelList) {
            return comboBoxOptionList;
        }

        comboBoxOptionList.push({label: 'Select an Option', value: ''});
        for (let designation of designationLevelList) {
            comboBoxOptionList.push({label: designation.Name, value: designation.Id});
        }
        if(this.otherDesignationLabel) {
            comboBoxOptionList.push({"Name":this.otherDesignationLabel, "Id": "Other"});
        }
        return comboBoxOptionList;
    }

    get modalId() {
        return 'hiearchy-modal';
    }

    get temporaryDesignationIdSet() {
        let idSet = new Set();
        if (!this._temporaryDesignationList.length) {
            return idSet;
        }

        for (let eachDesignation of this._temporaryDesignationList) {
            idSet.add(eachDesignation.Id);
        }
        return idSet;
    }

    get flexgridClass() {
        if (!this._featuredDesignationsList || this._featuredDesignationsList.length === 0) {
            return 'flex-grid slds-grid slds-grid_align-center';
        }

        if (this._featuredDesignationsList.length >= 4) {
            return 'flex-grid-5 slds-grid slds-grid_align-center';
        }

        return 'flex-grid-' + (this._featuredDesignationsList.length + 1) + 'slds-grid slds-grid_align-center';
    }

    connectedCallback() {
        this._fieldNamesList = this.fieldNamesString ? this.fieldNamesString.split(",").map((field) => {return field.trim();}) : [];
        this.subscribeToMessageChannel();
        if (this.designationLevelLabels) {
            this.designationLevelLabels = JSON.parse(this.designationLevelLabels);
        }
        let amount = [25.00,50.00,100.00];
        this._defaultGivingAmountList.push({"amount":  parseFloat(25.00).toFixed(2), "label":"$" + 25.00});
        this._defaultGivingAmountList.push({"amount":  parseFloat(50.00).toFixed(2), "label":"$" + 50.00});
        this._defaultGivingAmountList.push({"amount":  parseFloat(100.00).toFixed(2), "label":"$" + 100.00});
        //this._defaultGivingAmountList.push({"amount":  parseFloat(amount).toFixed(2), "label":"$" + amount});
        /*if (this.defaultGivingAmounts) {
            for (let amount of this.defaultGivingAmounts.split(',')) {
                this._defaultGivingAmountList.push({"amount":  parseFloat(amount).toFixed(2), "label":"$" + amount});
            }
            this._amount = parseFloat(this.defaultGivingAmounts.split(',')[0]).toFixed(2);
            this.amountToDisplay = parseFloat(this.defaultGivingAmounts.split(',')[0]).toFixed(2);
            this._size = Math.floor(12/(this.defaultGivingAmounts.split(',').length + 2));
        }*/
        if (this.featuredDesignationList) {
            const params = {'params':{"designations": this.featuredDesignationList, "pageName": this.pageSectionName}};
            if (this.featuredDesignationList.split(',').length == 1) {
                this._featuredDesignationColumnSize = 12;
            }
            getFeaturedDesignations(params).then( res => {
                this._featuredDesignationsList = this.parseDesignationsForMinimums(res);
                this._callbackDone = true;
            }).catch(console.error);
        }
        let vars = {};

        let parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });
        if (vars['dsgt']) {
            let designationNameList = decodeURIComponent(vars['dsgt']);
            const params = {'params':{"designations": designationNameList, "pageName": this.pageSectionName}};
            getFeaturedDesignations(params).then( res => {
                res = this.parseDesignationsForMinimums(res);
                for (let designation of res) {
                    this.selectedDesignationsList.push({"Name": designation.Name, "Id":designation.Id, 'ucinn_ascendv2__Minimum_Gift_Amount__c':designation.ucinn_ascendv2__Minimum_Gift_Amount__c, "nonGiftAmount":designation.ucinn_ascendv2__Default_Non_Gift_Amount__c});
                }
                publish(this.messageContext, onlineGivingChannel, {detail :this.selectedDesignationsList, type:"designation"});
            }).catch(console.error);
        }
        this._displaySettingList.push({'customMetadataDeveloperName': this.customMetadataDeveloperName});

        if (this.isCategoryModal) {
            this.initializeCategoryModalRecords()
        } else if (this.isFlatModal) {
            this.initializeFlatModalRecords();
        } else if (this.isHierarchyModal) {
            this.initializeHierarchyModalRecords();
        }
    }

    initializeCategoryModalRecords() {
        const designationParams = {'params':{"pageName": this.pageSectionName}};
        this._showSpinner = true;
        let options = [];
        SERVER_getDesignationsByCategory(designationParams).then( res => {
            //console.log('initializeCategoryModalRecords Server call-->'+JSON.stringify(res));
            res.forEach(category => {
                //console.log('initializeCategoryModalRecords category-->'+JSON.stringify(category));
                let designations = [];
                if (category.designations.length > 0) {
                    category.designations = this.parseDesignationsForMinimums(category.designations);
                    category.designations.forEach(designation => {
                        let checked = false;
                        if (this._temporaryDesignationList.length > 0) {

                            for (let selectedDesignation of this._temporaryDesignationList) {
                                if (selectedDesignation.Id == designation.Id) {
                                    checked = true;
                                }
                            }

                        }
                        if (designation.ucinn_ascendv2__Minimum_Gift_Amount__c == null || designation.ucinn_ascendv2__Minimum_Gift_Amount__c <= 0) {
                            designation.ucinn_ascendv2__Minimum_Gift_Amount__c = 0.01;
                        }
                        designations.push({"Name":designation.Name, "Id": designation.Id, 'ucinn_ascendv2__External_System_ID__c':designation.ucinn_ascendv2__External_System_ID__c, 'ucinn_ascendv2__Minimum_Gift_Amount__c':designation.ucinn_ascendv2__Minimum_Gift_Amount__c, "nonGiftAmount": designation.ucinn_ascendv2__Default_Non_Gift_Amount__c, "checked":checked});
                    });
                }
                if (category.category) {
                    this._categoryDesignations.push({'category': category.category, 'showDesignations': false, 'designations':designations, 'class': 'accordion-item'});
                    this._categoryComboDesignations.push({ label: category.category, value: category.category });
                } else {
                    this._categoryDesignations.push({'category': this.BlankCategoryLabel, 'showDesignations': false, 'designations':designations, 'class': 'accordion-item'});
                    //this._categoryComboDesignations.push({ label: category.category, value: category.category }); // check blank
                }
            });
            if(this.otherDesignationLabel) {
                this._categoryDesignations.push({'category': this.otherDesignationLabel, 'showDesignations': false, 'designations':[{"Name":this.otherDesignationLabel, "Id":"Other", "checked":false}], 'class': 'accordion-item'});
            }
        }).then((res) => {
            this.getcategoryComboBoxOptionList();
        }).catch(console.error).finally(() => {
            this._showSpinner = false;
        });
    }

    initializeFlatModalRecords() {
        const designationParams = {'params':{"pageName": this.pageSectionName}};
        this._showSpinner = true;
        SERVER_getAllDesignations(designationParams).then( res => {
            res = this.parseDesignationsForMinimums(res);

            res.forEach(designation => {
                let checked = false;
                if (this._temporaryDesignationList.length > 0) {

                    for (let selectedDesignation of this._temporaryDesignationList) {
                        if (selectedDesignation.Id == designation.Id) {
                            checked = true;
                        }
                    }

                }
                if (designation.ucinn_ascendv2__Minimum_Gift_Amount__c == null || designation.ucinn_ascendv2__Minimum_Gift_Amount__c <= 0) {
                    designation.ucinn_ascendv2__Minimum_Gift_Amount__c = 0.01;
                }
                this._allDesignations.push({"Name":designation.Name, "Id": designation.Id, 'ucinn_ascendv2__External_System_ID__c':designation.ucinn_ascendv2__External_System_ID__c, 'ucinn_ascendv2__Minimum_Gift_Amount__c':designation.ucinn_ascendv2__Minimum_Gift_Amount__c, "nonGiftAmount": designation.ucinn_ascendv2__Default_Non_Gift_Amount__c, "checked":checked});
            });
            if(this.otherDesignationLabel) {
                console.log('other desination label ' + this.otherDesignationLabel);
                this._allDesignations.push({"Name":this.otherDesignationLabel, "Id": "Other", "checked":false});
            }

            //console.log(JSON.stringify(this._allDesignations));
        }).catch((e) => {
            console.log(e);
        }).finally(() => {
            this._showSpinner = false;
        });
    }

    initializeHierarchyModalRecords() {
        this.getChildDesignationsFromParentId(null);
    }

    //performs a query for all the designations that are direct children of provided designation Id
    getChildDesignationsFromParentId(parentId) {
        const designationParams = {'params':{"pageName": this.pageSectionName, "parentId": parentId}};
        this._showSpinner = true;
        SERVER_getDesignationsByParentId(designationParams).then( res => {
            res = this.parseDesignationsForMinimums(res);

            this._designationHierachyMap[parentId] = []; //define explicitly so we can skip later even when empty from no children
            res.forEach(designation => {
                let checked = false;
                if (this._temporaryDesignationList.length > 0) {

                    for (let selectedDesignation of this._temporaryDesignationList) {
                        if (selectedDesignation.Id == designation.Id) {
                            checked = true;
                        }
                    }

                }
                if (designation.ucinn_ascendv2__Minimum_Gift_Amount__c == null || designation.ucinn_ascendv2__Minimum_Gift_Amount__c <= 0) {
                    designation.ucinn_ascendv2__Minimum_Gift_Amount__c = 0.01;
                }
                let parentId = designation.ucinn_ascendv2__Parent_Designation__c;
                if(parentId == null) {
                    parentId = '';
                }
                let designationLevelList = this._designationHierachyMap[parentId];
                if(designationLevelList == null) {
                    designationLevelList = [];
                }
                this._allDesignations.push({"Name":designation.Name, "Id": designation.Id, 'ucinn_ascendv2__External_System_ID__c':designation.ucinn_ascendv2__External_System_ID__c, 'ucinn_ascendv2__Minimum_Gift_Amount__c':designation.ucinn_ascendv2__Minimum_Gift_Amount__c, "nonGiftAmount": designation.ucinn_ascendv2__Default_Non_Gift_Amount__c, "checked":checked});
                designationLevelList.push({"Name":designation.Name, "Id": designation.Id, 'ucinn_ascendv2__External_System_ID__c':designation.ucinn_ascendv2__External_System_ID__c, 'ucinn_ascendv2__Minimum_Gift_Amount__c':designation.ucinn_ascendv2__Minimum_Gift_Amount__c, "nonGiftAmount": designation.ucinn_ascendv2__Default_Non_Gift_Amount__c, "checked":checked});
                this._designationHierachyMap[parentId] = designationLevelList;
            });

            if ((parentId == '' || parentId == null) && this.otherDesignationLabel) {
                let designationLevelList = this._designationHierachyMap[''];
                if(designationLevelList == null) {
                    designationLevelList = [];
                }
                this._allDesignations.push({"Name":this.otherDesignationLabel, "Id": "Other",  'ucinn_ascendv2__Minimum_Gift_Amount__c': 0.01, "nonGiftAmount": 0, "checked":false});
                designationLevelList.push({"Name":this.otherDesignationLabel, "Id": "Other",  'ucinn_ascendv2__Minimum_Gift_Amount__c': 0.01, "nonGiftAmount": 0, "checked":false});
                this._designationHierachyMap[''] = designationLevelList;
            }
        }).catch(console.error).finally(() => {
            this._showSpinner = false;
        });
    }

    renderedCallback() {
        this.setColor();
    }

    disconnectedCallback() {
        unsubscribe(this._subscription);
        this._subscription = null;
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                onlineGivingChannel,
                (message) => this.handleMessage(message)
            );
        }
    }

    setColor(hoveredAmount) {
        if (this.template.querySelectorAll('.grid-item label') && this.template.querySelectorAll('.grid-item label').length > 0) {
            this.template.querySelectorAll('.grid-item label').forEach(element => {
                let buttonAmount = element.getAttribute('data-amount');
                if ((buttonAmount == this._amount && !this._showOther)
                    || (this._showOther && buttonAmount == 'Other')
                    || (hoveredAmount && buttonAmount == hoveredAmount)) {
                    element.querySelector('span').style = this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.baseButtonColor
                } else {
                    element.querySelector('span').style = this.nonSelectedTypeColorStyle;
                    element.querySelector('span a').style = 'color: ' + this.selectedButtonColor
                }
            });
            return true;
        }

        return false;
    }


    isButtonNameSelected(buttonName) {
        if (!this.selectedDesignationsList) {
            return false;
        }

        for (let eachSelectedDesignation of this.selectedDesignationsList) {
            if (eachSelectedDesignation.Name === buttonName) {
                return true;
            }
        }

        return false;
    }

    searchOnKeyPress(event) {
        let input_number = event.target.value;
        //console.log('Number: '+input_number + event.keyCode);
        if(event.keyCode === 13){
            this.searchDesignations(event);
        }
    }

    /*searchDesignations(event) {
        if(!this._keyword || this._keyword.trim().length < 2) {
            if (this.template.querySelector('[data-name="keyword"]')) {
                this.template.querySelector('[data-name="keyword"]').setCustomValidity('Keyword must be at least 2 characters long.');
                this.template.querySelector('[data-name="keyword"]').reportValidity();
            }
            return;
        }

        const designationSearchParams = {'params':{"pageName": this.pageSectionName, "offset": 0, "keyword": this._keyword, "fieldNamesList": this._fieldNamesList}};
        this._showSpinner = true;
        SERVER_searchDesignations(designationSearchParams)
            .then(res => {
                let temporaryDesignationIdSet = this.temporaryDesignationIdSet;
                this._searchDesignationList = [];
                res.forEach(designation => {
                    let checked = temporaryDesignationIdSet.has(designation.Id);
                    if (designation.minimumGiftAmount == null || designation.minimumGiftAmount <= 0) {
                        designation.minimumGiftAmount = 0.01;
                    }
                    this._searchDesignationList.push({"Name":designation.Name, "Id": designation.Id, 'externalSystemId':designation.externalSystemId, 'minimumGiftAmount':designation.minimumGiftAmount,"nonGiftAmount":designation.defaultNonGiftAmount, "checked":checked});

                });
            })
            .catch(e => {
                console.log(e);
                let errorMap = JSON.parse(e.body.message);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: errorMap.message,
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            })
            .finally(() => {
                this._showSpinner = false;
            });
    }*/

    searchDesignations(event) {
        if(!this._keyword || this._keyword.trim().length < 2) {
            if (this.template.querySelector('[data-name="keyword"]')) {
                this.template.querySelector('[data-name="keyword"]').setCustomValidity('keyword must be atleast 2 characters long');
                this.template.querySelector('[data-name="keyword"]').reportValidity();
            }
            return;
        }

        const designationSearchParams = {
            'params': {
                "pageName": this.pageSectionName,
                "offset": 0,
                "keyword": this._keyword,
                "fieldNamesList": this._fieldNamesList
            }
        };
        this._showSpinner = true;
        SERVER_searchDesignations(designationSearchParams)
            .then(res => {
                this._searchDesignationList = [];
                res.forEach(designation => {
                    let checked = false;
                    if (this._temporaryDesignationList.length > 0) {

                        for (let selectedDesignation of this._temporaryDesignationList) {
                            if (selectedDesignation.Id == designation.Id) {
                                checked = true;
                            }
                        }

                    }
                    if (designation.ucinn_ascendv2__Minimum_Gift_Amount__c == null || designation.ucinn_ascendv2__Minimum_Gift_Amount__c <= 0) {
                        designation.ucinn_ascendv2__Minimum_Gift_Amount__c = 0.01;
                    }
                    console.log('designation:: '+JSON.stringify(designation));
                    this._searchDesignationList.push({"Name":designation.ISUF_Name, "displayName" :designation.Search_Name, "Id": designation.Id, 'ucinn_ascendv2__External_System_ID__c':designation.ucinn_ascendv2__External_System_ID__c, 'ucinn_ascendv2__Minimum_Gift_Amount__c':designation.ucinn_ascendv2__Minimum_Gift_Amount__c,"nonGiftAmount":designation.ucinn_ascendv2__Default_Non_Gift_Amount__c, "checked":checked});
                    console.log('_searchDesignationList'+JSON.stringify(this._searchDesignationList));
                    this._searchDesignationSize = this._searchDesignationList.length;
                });

                if(this._searchDesignationList.length < 1) {
                    this._searchDesignationSize = 0;
                    if (this.template.querySelector('[data-name="keyword"]')) {
                        this.template.querySelector('[data-name="keyword"]').setCustomValidity('No Results Found.');
                        this.template.querySelector('[data-name="keyword"]').reportValidity();
                    }
                }

            })
            .catch(e => {
                console.log(e);
                let errorMap = JSON.parse(e.body.message);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: errorMap.message,
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            })
            .finally(() => {
                this._showSpinner = false;
            });
    }

    handleShowMoreClicked(event) {
        if (this.componentVersion == 'Modal') {
            this.resetDesignations();

            this._showModal = true;
        } else {
            if (this.selectedDesignationsList.length < this.maxNumberOfDesignations) {
                this._showLookup = true;
            } else {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            }

        }
    }

    handleDesignationClicked(event) {
        let name = event.currentTarget.getAttribute('data-name');
        console.log(`name : ${name}`);
        let id = event.currentTarget.getAttribute('data-id');
        let hasDesignation = false;
        let minimumAmount = 0.01;
        if (event.currentTarget.getAttribute('data-min')) {
            minimumAmount = event.currentTarget.getAttribute('data-min');
        }
        for (let designation of this._temporaryDesignationList) {
            if (designation.Id == id) {
                hasDesignation = true;
            }
        }

        if (hasDesignation == false) {
            if (this.selectedDesignationsList.length >= this.maxNumberOfDesignations) {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);

                return;
            }

            this.selectedDesignationsList.push({"Name": name, "Id":id, "ucinn_ascendv2__Minimum_Gift_Amount__c":minimumAmount});
            publish(this.messageContext, onlineGivingChannel, {detail :this.selectedDesignationsList, type:"designation"});
            this.checkPledgeDesignation(id);
        } else {
            //console.log('removing: ' + id);
            this.removeSelectedDesignation(id);
            publish(this.messageContext, onlineGivingChannel, {detail :this.selectedDesignationsList, type:"designation"});
        }
        this._numberOfDesignations = this._temporaryDesignationList.length;
    }

    removeSelectedDesignation(Id) {
        let resultList = [];
        for (let eachDesignation of this.selectedDesignationsList) {
            //console.log(JSON.stringify(eachDesignation));
            if (eachDesignation.Id !== Id) {
                resultList.push(eachDesignation);
            }
        }

        //console.log(JSON.stringify(resultList));

        this.selectedDesignationsList = resultList;
    }

    handleCategoryClicked(event) {
        let index = event.currentTarget.getAttribute('data-index');
        this._categoryDesignations[index].showDesignations = !this._categoryDesignations[index].showDesignations;
        if (this._categoryDesignations[index].showDesignations) {
            this._categoryDesignations[index].class = 'accordion-item active';
        } else {
            this._categoryDesignations[index].class = 'accordion-item';
        }

        this._categoryDesignations = [...this._categoryDesignations];
    }

    //added for customization
    handleAmountClick(event) {
        //console.log('changed ---> '+event.detail);
        this._amount = event.detail;

        // added for change::
        if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        } else if (this._firstTimeFund ===true && this._categorySelected.length < 1 || this._categoryFundSelected.length < 1 || this._amount === undefined || this._amount === '') {
            console.log(' No Error:: ');
        }
        else if (this._firstTimeFund) {
            //console.log('First Time Fund::: '+this._firstTimeFund);
            this._showModal = false;
            //this._addButtonDisabled = false;
            this.isShowDesignations = true;
            if(this._categoryFundSelected){
                this.checkDesignationToPublish(this._categoryFundSelected);
            }

            /*let id = this._categoryFundSelected;
            console.log('_temporaryDesignationList Exist:: '+JSON.stringify(this._temporaryDesignationList));
            console.log('_selectedDesignationsList Fund Exist:: '+JSON.stringify(this._selectedDesignationsList));
            if (this._firstTimeFund) {
                this._temporaryDesignationList = [];
                let name = '';
                let minimumAmount = 0.01;
                let nonGiftAmount = 0;
                let amount = this._amount;
                let totalAmount = this._totalAmount;
                for (let categoryDesignation of this._categoryDesignations) {
                    for(let designation of categoryDesignation.designations){
                        //console.log('FT check Designation:: '+JSON.stringify(designation));
                        if (designation.Id == id) {
                            //console.log('FT Check Inside:: '+JSON.stringify(designation));
                            name = designation.Name;
                            minimumAmount = designation.ucinn_ascendv2__Minimum_Gift_Amount__c;
                            nonGiftAmount = designation.nonGiftAmount;
                        }
                    }
                }
                this._temporaryDesignationList.push({"Name": name, "Id":id, "ucinn_ascendv2__Minimum_Gift_Amount__c":minimumAmount, "nonGiftAmount":nonGiftAmount, "amount":amount, "firstTimeFund":this._firstTimeFund});
                totalAmount = (parseFloat(totalAmount) + parseFloat(amount)).toFixed(2);
                console.log('this.totalAmount  '+totalAmount);
                this._numberOfDesignations = this._temporaryDesignationList.length;
                this.checkPledgeDesignation(id);
            }
            this.resetDesignations();
            if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            }
            this.selectedDesignationsList = [];
            this.selectedDesignationsList = [...this._temporaryDesignationList];
            console.log(' Final List::: '+JSON.stringify(this.selectedDesignationsList));
            //this._categoryFundSelected = [];
            //this._categorySelected = [];
            //this._amount = '';
            //this.isMoreButton = true;
            //this.isShowDesignations=false;
            publish(this.messageContext, onlineGivingChannel, {detail : this.selectedDesignationsList, type:"designation"});
            publish(this.messageContext, onlineGivingChannel, {detail:this._amount, type:"amount"});
            //publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._totalAmount)), type:"totalAmount"});*/
        }
        else
        {
            this._showModal = false;
            //this._addButtonDisabled = false;
            if(!this._firstTimeFund){
                this._showFinishButton = true;
            }
            //console.log('Else Amount::: '+this._amount);
            //publish(this.messageContext, onlineGivingChannel, {detail:this._amount, type:"amount"});
        }
        this.setColor();
    }

    //added for customization
    handleCategoryFundClicked(event) {
        let id = event.detail.value;
        let inputId = event.currentTarget.value;
        console.log('Event:: '+event.detail.Id +' inputId: '+event.currentTarget.value);
        console.log('1st check:: '+id + 'FC: '+this._firstTimeFund +' amount:: '+this._amount + ' Length: '+this._amount.length);
        this._categoryFundSelected = inputId;//event.detail.value;
        if(this._categorySelected === this.otherDesignationLabel) {
            inputId = "Other";
        }
        console.log('_categoryFundSelected 1:: '+JSON.stringify(this._categoryFundSelected));
        if(this._firstTimeFund === true && this._amount.length > 0){
            this.checkDesignationToPublish(inputId);
        }
    }

    //added for customization
    handleCategoryParentClicked(event) {
        this._categoryfundDesignations = [];
        this._categorySelected = event.detail.value;
        let getVal = event.detail.value;
        //console.log('other:: ',event.detail.value);
        if(this._categorySelected == this.otherDesignationLabel){//'Unlisted fund (enter manually)'){ //this.otherDesignationLabel
            this.showOtherInput = true;
            //this._categorySelected = 'Other';
            getVal = 'Other';
        }else {
            this.showOtherInput = false;
        }
        this._categoryFundSelected = [];
       //console.log('this.this._categoryFundMap.get(getVal): ',this._categoryFundMap.get(getVal));

        for (let designation of this._categoryFundMap.get(getVal)) {
            var index = this.addedDesignationsList.findIndex(x => x.Id == designation.Id);
            //console.log('Index::: ',index);
            if(index === -1) {
                this._categoryfundDesignations.push({label: designation.Name, value: designation.Id});
            }else {
                //console.log('Dont add',designation.Name);
            }
            /*if(this.addedDesignationsList.length > 0) {
                    for(let des of this.addedDesignationsList){
                        console.log('Fund Name: ',designation.Name +' Added Name: ',des.Name, ' selected Funds ',JSON.stringify(this._categoryfundDesignations));
                        if(des.Name != designation.Name) {
                            this._categoryfundDesignations.push({label: designation.Name, value: designation.Id});
                        }else {
                            console.log('Dont add',des.Name);
                        }
                    }
                }
                else {
                    this._categoryfundDesignations.push({label: designation.Name, value: designation.Id});
                }*/
        }
        //console.log('comboBoxOptionList:: 22 '+JSON.stringify(this._categoryfundDesignations));
    }

    handleMultiDesignationClicked(event) {
        let name = event.currentTarget.getAttribute('data-name');
        let id = event.currentTarget.getAttribute('data-id');
        let index = event.currentTarget.getAttribute('data-index');
        let minimumAmount = event.currentTarget.getAttribute('data-min');
        if (event.currentTarget.checked == true) {
            let hasDesignation = false;
            for (let designation of this._temporaryDesignationList) {
                if (designation.Id == id) {
                    hasDesignation = true;
                }
            }
            if (hasDesignation == false) {
                this._temporaryDesignationList.push({"Name": name, "Id":id, "ucinn_ascendv2__Minimum_Gift_Amount__c":minimumAmount});
                this._numberOfDesignations = this._temporaryDesignationList.length;
                this.checkPledgeDesignation(id);
            }
        } else {
            let newList = [];
            for (let designation of this._temporaryDesignationList) {
                if (designation.Id != id) {
                    newList.push(designation);
                }
            }
            this._temporaryDesignationList = newList;
            this._numberOfDesignations = this._temporaryDesignationList.length;
        }
        this.resetDesignations();
        if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }

    }

    closeModal(event) {
        this._showModal = false;
        this._temporaryDesignationList = [];
        this._temporaryDesignationList = [...this.selectedDesignationsList];
        this._numberOfDesignations = this._temporaryDesignationList.length;
        this.resetDesignations();
    }

    //added for customization
    handleContinueClicked(event) {
        if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        } else {
            this._categoryFundSelected = [];
            this._categorySelected = [];
            //console.log('details::: '+JSON.stringify(event.target.dataset.targetId));
            let id = event.target.dataset.targetId;
            for (let designation of this._categoryDesignations) {
                for(let des of designation.designations){
                    if (des.Id == id) {
                        this._categorySelected = designation.category;
                        this._categoryFundSelected = JSON.parse(JSON.stringify(des.Id));
                        this._categoryfundDesignations.push({label: des.Name, value: des.Id});
                    }
                }
            }
            //console.log('Cat:: '+this._categorySelected +' des:: '+this._categoryFundSelected);
            setTimeout(() => {
                eval("$A.get('e.force:refreshView').fire();");
            }, 1000);
            this._showModal = false;
        }
    }

    //added for customization
    handleAddAdditionalGiftClicked(event) {
        //console.log('this . validation --- ' + this._categorySelected.length);
        //console.log('this . validation --- ' + this._categoryFundSelected.length);
        //console.log('this . amount --- ' + this._amount +' FirstTime Fund:: '+ this._firstTimeFund);
        this.showOtherInput = false;
        this._showSpinner = true;
        if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You cannot have no more than ' + this.maxNumberOfDesignations + ' designations.',
                variant: "error",
                mode: "sticky"
            });
            this.dispatchEvent(event);
        } else if (this._categorySelected.length < 1 || this._categoryFundSelected.length < 1 || this._amount === undefined || this._amount === '') {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Please Select College, Fund and Amount',
                variant: "error",
                mode: "sticky"
            });
            this.dispatchEvent(event);
        } else if (this._firstTimeFund) {
            this._categoryFundSelected = [];
            this._categorySelected = [];
            this._amount = 0;
            //this._addButtonDisabled = true;
            this._firstTimeFund = false;
            publish(this.messageContext, onlineGivingChannel, {detail : this._firstTimeFund, type:"firstTimeFund"});
            this.template.querySelector("c-portal_-online-giving-amount-o-r").handleAmountShow();
            //this.checkDesignationToPublish(this._categoryFundSelected);
        }else if (!this._firstTimeFund && this._temporaryDesignationList.length >0) {
            if(this._categorySelected == this.otherDesignationLabel) {
                this.checkDesignationToPublish('Other');
            } else{
                this.checkDesignationToPublish(this._categoryFundSelected);
            }
            // reset the values.
            this._categoryFundSelected = [];
            this._categorySelected = [];
            this._amount = '';
            //this._addButtonDisabled = true;
            this.isShowDesignations = false;
            /*this._categoryFundSelected = [];
            this._categorySelected = [];
            this._amount = '';
            publish(this.messageContext, onlineGivingChannel, {detail:this._amount, type:"amount"});
            this.isShowDesignations = false;
            this._addButtonDisabled = false;*/
            setTimeout(() => {
                eval("$A.get('e.force:refreshView').fire();");
                eval("$A.get('e.force:closeQuickAction').fire();");
            }, 1000);
            this.template.querySelector("c-portal_-online-giving-amount-o-r").handleAmountShow();
            this.isShowDesignations = true;
        }else if (!this._firstTimeFund) {
            if( this._categorySelected == this.otherDesignationLabel) {
                this.checkDesignationToPublish('Other');
            } else{
                this.checkDesignationToPublish(this._categoryFundSelected);
            }
            this._categoryFundSelected = [];
            this._categorySelected = [];
            this._amount = '';
            //this._addButtonDisabled = true;
            this.isShowDesignations = false;
            setTimeout(() => {
                eval("$A.get('e.force:refreshView').fire();");
                eval("$A.get('e.force:closeQuickAction').fire();");
            }, 1000);
            this.template.querySelector("c-portal_-online-giving-amount-o-r").handleAmountShow();
            this.isShowDesignations = true;
            //this._addButtonDisabled = false;
        } else {
            console.log('not executed:: ');
        }
        this._showSpinner = false;

    }

    //added for customization
    checkDesignationToPublish(designationId){
        if(this._temporaryDesignationList.length >= 0){
            let hasDesignation = false;
            let id = designationId;

            if(this._firstTimeFund){
                this._temporaryDesignationList = [];
            }

            for (let designation of this._temporaryDesignationList) {
                if (designation.Id == id) {
                    hasDesignation = true;
                    designation.checked = true;
                }
            }

            if (hasDesignation == false) {
                let name = '';
                let minimumAmount = 0.01;
                let nonGiftAmount = 0;
                let amount = this._amount;
                let totalAmount = this._totalAmount;
                for (let categoryDesignation of this._categoryDesignations) {
                    for(let designation of categoryDesignation.designations){
                        //console.log('designation.Id : ',designation.Id +' :',id);
                        if (designation.Id == id) {
                            console.log('D ID: ',designationId +' id: ',id +' desName: ',designation.Name, ' CF: ',this._categoryFundSelected +' Name: ',name);
                            if( designation.Name == this.otherDesignationLabel) {
                                name = this._categoryFundSelected;
                                console.log('If : ',name);
                            } else {
                                name = designation.Name;
                                console.log('elae: ',name);
                            }
                            console.log('name.Id : ',name);
                            minimumAmount = designation.ucinn_ascendv2__Minimum_Gift_Amount__c;
                            nonGiftAmount = designation.nonGiftAmount;
                        //} else if(this._categorySelected == 'Other') {
                        } else if(this._categorySelected == this.otherDesignationLabel) {
                            console.log('OtherL : ',designationId);
                            name = this._categoryFundSelected;
                            console.log('name : ',name, ' DS: ',designation.Name);
                            id = 'Other';
                            console.log('id : ',id);
                            minimumAmount = designation.ucinn_ascendv2__Minimum_Gift_Amount__c;
                            nonGiftAmount = designation.nonGiftAmount;
                        }
                    }
                }
                console.log('Name in loop : ',name +' ID: ',id);
                this._temporaryDesignationList.push({"Name": name, "Id":id, "ucinn_ascendv2__Minimum_Gift_Amount__c": minimumAmount, "nonGiftAmount": nonGiftAmount, "amount": amount, "firstTimeFund": this._firstTimeFund});
                console.log('List: ',JSON.stringify(this._temporaryDesignationList));
                totalAmount = (parseFloat(totalAmount) + parseFloat(amount)).toFixed(2);
                this._numberOfDesignations = this._temporaryDesignationList.length;
                this.checkPledgeDesignation(id);
            }
            this.resetDesignations();
            if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            }
            this.selectedDesignationsList = [];
            this.selectedDesignationsList = [...this._temporaryDesignationList];
            //console.log(' Final List::: '+JSON.stringify(this.selectedDesignationsList));
            //this.isShowDesignations = false;
            publish(this.messageContext, onlineGivingChannel, {detail : this.selectedDesignationsList, type:"designation"});
            publish(this.messageContext, onlineGivingChannel, {detail:this._amount, type:"amount"});
            publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._totalAmount)), type:"totalAmount"});
        }
    }

    //added for customization
    handleFinsishAdditionalGiftClicked(event) {
        console.log('this . validation --- ' + this._categorySelected.length);
        console.log('this . validation --- ' + this._categoryFundSelected.length);
        console.log('this . amount --- ' + this._amount);
        if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                variant: "error",
                mode: "sticky"
            });
            this.dispatchEvent(event);
        } else if (this._categorySelected.length < 1 || this._categoryFundSelected.length < 1 || this._amount === undefined || this._amount === '') {
            this._categoryFundSelected = [];
            this._categorySelected = [];
            this._amount = '';
            //this._addButtonDisabled = true;
            this.isShowDesignations = false;
            this.isMoreButton = true;
        }
        else if (!this._firstTimeFund && this._temporaryDesignationList.length > 0)
        {
            this.checkDesignationToPublish(this._categoryFundSelected);
            this._categoryFundSelected = [];
            this._categorySelected = [];
            this._amount = '';
            //this._addButtonDisabled = true;
            this.isShowDesignations = false;
            this.isMoreButton = true;
        }
        else {
            this._categoryFundSelected = [];
            this._categorySelected = [];
            this._amount = '';
            //this._addButtonDisabled = true;
            this.isShowDesignations = false;
            this.isMoreButton = true;
            }
    }

    handleAddContinueClicked(event) {
        console.log('this . validation --- '+this._categorySelected.length);
        console.log('this . validation --- '+this._categoryFundSelected.length);
        console.log('this . amount --- '+this._amount);
        if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        } else if(this._categorySelected.length < 1 || this._categoryFundSelected.length < 1 || this._amount === undefined || this._amount === ''){
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Please Select College, Fund and Amount',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        } else{
            this._showModal = false;
            //this._addButtonDisabled = true;
            //added
            let hasDesignation = false;
            let id = this._categoryFundSelected;
            for (let designation of this._temporaryDesignationList) {
                console.log('1-2 check:: '+id);
                if (designation.Id == id) {
                    hasDesignation = true;
                    designation.checked = true;
                }
            }
            console.log('2 check:: '+id);
            if (hasDesignation == false) {
                console.log('23 check:: '+id);
                let name = '';
                let minimumAmount = 0.01;
                let nonGiftAmount = 0;
                let amount = this._amount;
                let totalAmount = this._totalAmount;
                for (let categoryDesignation of this._categoryDesignations) {
                    for(let designation of categoryDesignation.designations){
                        console.log('24 check:: '+JSON.stringify(designation));
                        if (designation.Id == id) {
                            console.log('24 Inside:: '+JSON.stringify(designation));
                            name = designation.Name;
                            minimumAmount = designation.ucinn_ascendv2__Minimum_Gift_Amount__c;
                            nonGiftAmount = designation.nonGiftAmount;
                        }
                    }
                }
                this._temporaryDesignationList.push({"Name": name, "Id":id, "ucinn_ascendv2__Minimum_Gift_Amount__c":minimumAmount, "nonGiftAmount":nonGiftAmount, "amount":amount});
                totalAmount = (parseFloat(totalAmount) + parseFloat(amount)).toFixed(2);
                console.log('this.totalAmount  '+totalAmount);
                this._numberOfDesignations = this._temporaryDesignationList.length;
                this.checkPledgeDesignation(id);
            }
            this.resetDesignations();
            if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            }
            this.selectedDesignationsList = [];
            this.selectedDesignationsList = [...this._temporaryDesignationList];
            console.log(' Final List::: '+JSON.stringify(this.selectedDesignationsList));
            this._categoryFundSelected = [];
            this._categorySelected = [];
            //this._amount = '';
            this.isMoreButton = true;
            this.isShowDesignations=false;
            publish(this.messageContext, onlineGivingChannel, {detail : this.selectedDesignationsList, type:"designation"});
            publish(this.messageContext, onlineGivingChannel, {detail:this._amount, type:"amount"});
            //publish(this.messageContext, onlineGivingChannel, {detail:JSON.parse(JSON.stringify(this._totalAmount)), type:"totalAmount"});
        }
        //this.isShowDesignations = false;
    }

    handleAddMoreContinueClicked(event) {
            this._showModal = false;
            this.isShowDesignations = true;
            this.isMoreButton = false;
    }

    handleFinishContinueClicked(event) {
        if (this._temporaryDesignationList.length < 0) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You have to Choose at least one designations.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        } else if(this._categorySelected.length < 1 || this._categoryFundSelected.length < 1 || this._amount === undefined || this._amount === ''){
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Please Select College, Fund and Amount',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }else {
            this._showModal = false;
            this.isShowDesignations = false;
            this.isMoreButton = true;
        }
    }

    setKeyword(event) {
        this._keyword = event.currentTarget.value;

        this.template.querySelector('[data-name="keyword"]').setCustomValidity('');
        this.template.querySelector('[data-name="keyword"]').reportValidity();
    }

    resetDesignations() {
        if (this.isCategoryModal) {
           // console.log('button clicked');
            this._categoryDesignations.forEach(category => {
                //console.log('button clicked inside'+JSON.stringify(category));
                if (category.designations.length > 0) {
                    category.designations.forEach(designation => {
                        //console.log('button clicked inside Designations'+JSON.stringify(designation));
                        if (this._temporaryDesignationList.length > 0) {
                            let checked = false;
                            for (let selectedDesignation of this._temporaryDesignationList) {
                                if (selectedDesignation.Id == designation.Id) {
                                    checked = true;
                                }
                            }
                            designation.checked = checked;
                        }
                        //console.log('button clicked inside Designations'+JSON.stringify(designation));
                    });
                }
                //console.log('class:: '+this._showModal);
                if (!this._showModal) {
                    category.showDesignations = false;
                    category.class = "accordion-item";
                }
            })
        } else if (this.isFlatModal) {
            this._allDesignations.forEach(designation => {
                if (this._temporaryDesignationList.length > 0) {
                    let checked = false;
                    for (let selectedDesignation of this._temporaryDesignationList) {
                        if (selectedDesignation.Id == designation.Id) {
                            checked = true;
                        }
                    }
                    designation.checked = checked;

                }
            });
        } else if (this.isHierarchyModal) {
            if (!this._showModal) {
                this._selectedHierarchyDesignations = [];
                this._hierarchyTemporaryDesignationList = [];
                this._topSelectedHierarchyDesignation = "";
            }

            for (let selectedDesignation of this._temporaryDesignationList) {
                let found = false;
                this._hierarchyTemporaryDesignationList.forEach(designation => {
                    if (this._temporaryDesignationList.length > 0 && selectedDesignation.Id == designation.Id) {
                        found = true;
                    }
                });
                if (!found) {
                    this._hierarchyTemporaryDesignationList.push({'Name': selectedDesignation.Name, 'Id':selectedDesignation.Id, "ucinn_ascendv2__Minimum_Gift_Amount__c":selectedDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c, "nonGiftAmount":selectedDesignation.nonGiftAmount});
                }
            }

            this._hierarchyTemporaryDesignationList.forEach(designation => {
                let checked = false;

                if (this._temporaryDesignationList.length > 0) {

                    for (let selectedDesignation of this._temporaryDesignationList) {
                        if (selectedDesignation.Id == designation.Id) {
                            checked = true;
                        }
                    }

                }
                designation.checked = checked;
            });

        }

        this._searchDesignationList.forEach(designation => {
            let checked = false;
            if (this._temporaryDesignationList.length > 0) {
                for (let selectedDesignation of this._temporaryDesignationList) {
                    if (selectedDesignation.Id == designation.Id) {
                        checked = true;
                    }
                }
            }
            designation.checked = checked;
        });

    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this.addedDesignationsList  = message.detail['designationList'];
            this.selectedDesignationsList = [...message.detail['designationList']];
            this._temporaryDesignationList = [...message.detail['designationList']];
            this._numberOfDesignations = this._temporaryDesignationList.length;
            if(this._temporaryDesignationList.length < 1){
                this.isShowDesignations = true;
                //this._firstTimeFund = true;
            }else {
                //this._firstTimeFund = false;
            }
            this._page = message.detail['page'];
        } else if (message.type == 'pledgeDesignations') {
            this._pledgeDesignations = message.detail;
        }
    }

    handleLookup = (option) => {
        if (option && option.value) {
            let alreadyInList = false;
            let minimumAmount = 0.01;
            let nonGiftAmount = 0;
            for (let designation of this.selectedDesignationsList) {
                if (designation.Id == option.value) {
                    alreadyInList = true;
                }
                if (designation.ucinn_ascendv2__Minimum_Gift_Amount__c) {
                    minimumAmount = designation.ucinn_ascendv2__Minimum_Gift_Amount__c;
                }
                if (designation.nonGiftAmount) {
                    nonGiftAmount = designation.nonGiftAmount;
                }
            }
            if (!alreadyInList) {
                this.selectedDesignationsList.push({'Name': option.label, 'Id':option.value, "ucinn_ascendv2__Minimum_Gift_Amount__c":minimumAmount, "nonGiftAmount":nonGiftAmount});
                publish(this.messageContext, onlineGivingChannel, {detail : this.selectedDesignationsList, type:"designation"});
            } else {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'This designation has already been selected.',
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            }
        }
        this._clearList = true;
        this._lookupLabelSet = true;
        this._showLookup = false;
    }

    handleLookupChange = () => {
        if (this._lookupLabelSet) {
            this._clearList = true;
            this._lookupLabelSet = false;
        } else {
            this._clearList = false;
        }
    }

    handleTopHierarchyChange = (event) => {
        this._selectedHierarchyDesignations = [];
        this._selectedHierarchyDesignations.push(event.currentTarget.value);
        this._topSelectedHierarchyDesignation = event.currentTarget.value;
        console.log(this._topSelectedHierarchyDesignation);
        if (this._designationHierachyMap[this._topSelectedHierarchyDesignation] === undefined && this._topSelectedHierarchyDesignation != 'Other') {
            this.getChildDesignationsFromParentId(this._topSelectedHierarchyDesignation);
        }
    }

    handleHierarchyChange = (event) => {
        let id = event.target.value;
        let depth = event.target.name;
        this._selectedHierarchyDesignations.length = depth; //cuts off everything after and including the depth index
        this._selectedHierarchyDesignations.push(id);

        if (this._designationHierachyMap[this._selectedHierarchyDesignations[depth]] === undefined) {
            this.getChildDesignationsFromParentId(this._selectedHierarchyDesignations[depth]);
        }
    }

    checkPledgeDesignation(designationId) {
        if (this._pledgeDesignations && this._pledgeDesignations.length > 0) {
            let hasMatchingDesignation = false;
            for (let pledgeDesignation of this._pledgeDesignations) {
                if (designationId == pledgeDesignation.Id) {
                    hasMatchingDesignation = true;
                }
            }

            if (!hasMatchingDesignation) {
                const event = new ShowToastEvent({
                    title: 'Warning!',
                    message: 'You selected a designation that is not part of the pledge you are paying towards.',
                    variant:"warning",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            }
        }
    }

    addSelectedButton(event) {
        let id = this._selectedHierarchyDesignations[this._selectedHierarchyDesignations.length - 1];

        let hasDesignation = false;
        for (let designation of this._temporaryDesignationList) {
            if (designation.Id == id) {
                hasDesignation = true;
                designation.checked = true;
            }
        }
        if (hasDesignation == false) {
            let name = '';
            let minimumAmount = 0.01;
            let nonGiftAmount = 0;
            for (let designation of this._allDesignations) {
                if (designation.Id == id) {
                    name = designation.Name;
                    minimumAmount = designation.ucinn_ascendv2__Minimum_Gift_Amount__c;
                    nonGiftAmount = designation.nonGiftAmount;
                }
            }
            this._temporaryDesignationList.push({"Name": name, "Id":id, "ucinn_ascendv2__Minimum_Gift_Amount__c":minimumAmount, "nonGiftAmount":nonGiftAmount});
            this._numberOfDesignations = this._temporaryDesignationList.length;

            this.checkPledgeDesignation(id);
        }

        this.resetDesignations();

        if (this._temporaryDesignationList.length > this.maxNumberOfDesignations) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }
    }

    handleDesignationEnter(hoveredDesignation) {
        this.setColor(hoveredDesignation.target.dataset.name);
        this.searchBarLogo = searchLogoWhite;
    }

    handleDesignationLeave() {
        this.setColor();
        this.searchBarLogo = searchLogo;
        //console.log('SearchBarlogo Leave'+this.searchBarLogo);
    }

    parseDesignationsForMinimums(designationList) {
        let resultList = [];

        for (let designation of designationList) {
            let newDesignation = Object.assign({}, designation);

            if (!newDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c) {
                newDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c = .01;
            }

            if (newDesignation.ucinn_ascendv2__Default_Non_Gift_Amount__c
                && newDesignation.ucinn_ascendv2__Default_Non_Gift_Amount__c > newDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c) {
                newDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c = newDesignation.ucinn_ascendv2__Default_Non_Gift_Amount__c;
            }

            resultList.push(newDesignation);
        }

        return resultList
    }
}