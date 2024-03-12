import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import getFeaturedDesignations from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getFeaturedDesignations';
import SERVER_getAllDesignations from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getAllDesignations';
import SERVER_getDesignationsByCategory from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getDesignationsByCategory';
import SERVER_getDesignationsByParentId from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getDesignationsByParentId';
import SERVER_searchDesignations from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_searchDesignations';
export default class Portal_OnlineGivingDesignations extends LightningElement {

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
    @api fieldNamesString;
    _fieldNamesList = [];
    @wire(MessageContext) messageContext;
    _featuredDesignationsList = [];
    _callbackDone = false;
    @track _selectedDesignationsList = [];
    @track _temporaryDesignationList = [];
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
    _keyword = '';
    @track _hierarchyTemporaryDesignationList = [];
    @track _selectedHierarchyDesignations = [];
    _topSelectedHierarchyDesignation = '';
    @track _showSpinner = false;
    _isPledgePayment = false;

    _hierarchyList = [];

    //TODO: move templates into their own html
    //TODO: use portal_util_ApexCallout for callouts

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
        return this._page == this.pageName && !this._isPledgePayment;
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

    get flexgridClass() {
        if (!this._featuredDesignationsList || this._featuredDesignationsList.length === 0) {
            return 'flex-grid';
        }

        if (this._featuredDesignationsList.length >= 4) {
            return 'flex-grid-5';
        }

        return 'flex-grid-' + (this._featuredDesignationsList.length + 1);
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

    connectedCallback() {
        this.subscribeToMessageChannel();
        if (this.designationLevelLabels) {
            this.designationLevelLabels = JSON.parse(this.designationLevelLabels);
        }
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
                    this.selectedDesignationsList.push({"Name": designation.Name, "Id":designation.Id, 'minimumGiftAmount':designation.minimumGiftAmount, "nonGiftAmount":designation.defaultNonGiftAmount});
                }
                publish(this.messageContext, onlineGivingChannel, {detail :this.selectedDesignationsList, type:"designation"});
            }).catch(console.error);
        }
        this._displaySettingList.push({'customMetadataDeveloperName': this.customMetadataDeveloperName});

        this._fieldNamesList = this.fieldNamesString ? this.fieldNamesString.split(",").map((field) => {return field.trim();}) : [];

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
        SERVER_getDesignationsByCategory(designationParams).then( res => {
            let temporaryDesignationIdSet = this.temporaryDesignationIdSet;

            res.forEach(category => {
                let designations = [];
                if (category.designations.length > 0) {
                    category.designations = this.parseDesignationsForMinimums(category.designations);
                    category.designations.forEach(designation => {
                        let checked = temporaryDesignationIdSet.has(designation.Id);
                        if (designation.minimumGiftAmount == null || designation.minimumGiftAmount <= 0) {
                            designation.minimumGiftAmount = 0.01;
                        }
                        designations.push({"Name":designation.Name, "Id": designation.Id, 'externalSystemId':designation.externalSystemId, 'minimumGiftAmount':designation.minimumGiftAmount, "nonGiftAmount": designation.defaultNonGiftAmount, "checked":checked});
                    });
                }
                if (category.category) {
                    this._categoryDesignations.push({'category': category.category, 'showDesignations': false, 'designations':designations, 'class': 'accordion-item'});
                } else {
                    this._categoryDesignations.push({'category': this.BlankCategoryLabel, 'showDesignations': false, 'designations':designations, 'class': 'accordion-item'});
                }

            });
            if(this.otherDesignationLabel) {
                this._categoryDesignations.push({'category': this.otherDesignationLabel, 'showDesignations': false, 'designations':[{"Name":this.otherDesignationLabel, "Id":"Other", "checked":false}], 'class': 'accordion-item'});
            }

        }).catch(console.error).finally(() => {
            this._showSpinner = false;
        });
    }

    initializeFlatModalRecords() {
        const designationParams = {'params':{"pageName": this.pageSectionName}};
        this._showSpinner = true;
        SERVER_getAllDesignations(designationParams).then( res => {
            res = this.parseDesignationsForMinimums(res);
            let temporaryDesignationIdSet = this.temporaryDesignationIdSet;

            res.forEach(designation => {
                let checked = temporaryDesignationIdSet.has(designation.Id);
                if (designation.minimumGiftAmount == null || designation.minimumGiftAmount <= 0) {
                    designation.minimumGiftAmount = 0.01;
                }
                this._allDesignations.push({"Name":designation.Name, "Id": designation.Id, 'externalSystemId':designation.externalSystemId, 'minimumGiftAmount':designation.minimumGiftAmount, "nonGiftAmount": designation.defaultNonGiftAmount, "checked":checked});
            });
            if(this.otherDesignationLabel) {
                this._allDesignations.push({"Name":this.otherDesignationLabel, "Id": "Other", "checked":false});
            }
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
            let temporaryDesignationIdSet = this.temporaryDesignationIdSet;

            this._designationHierachyMap[parentId] = []; //define explicitly so we can skip later even when empty from no children
            res.forEach(designation => {
                let checked = temporaryDesignationIdSet.has(designation.Id); 
                if (designation.minimumGiftAmount == null || designation.minimumGiftAmount <= 0) {
                    designation.minimumGiftAmount = 0.01;
                }
                let parentId = designation.parentDesignation;
                if(parentId == null) {
                    parentId = '';
                }
                let designationLevelList = this._designationHierachyMap[parentId];
                if(designationLevelList == null) {
                    designationLevelList = [];
                }
                this._allDesignations.push({"Name":designation.Name, "Id": designation.Id, 'externalSystemId':designation.externalSystemId, 'minimumGiftAmount':designation.minimumGiftAmount, "nonGiftAmount": designation.defaultNonGiftAmount, "checked":checked});
                designationLevelList.push({"Name":designation.Name, "Id": designation.Id, 'externalSystemId':designation.externalSystemId, 'minimumGiftAmount':designation.minimumGiftAmount, "nonGiftAmount": designation.defaultNonGiftAmount, "checked":checked});
                this._designationHierachyMap[parentId] = designationLevelList;
            });

            if ((parentId == '' || parentId == null) && this.otherDesignationLabel) {
                let designationLevelList = this._designationHierachyMap[''];
                if(designationLevelList == null) {
                    designationLevelList = [];
                }
                this._allDesignations.push({"Name":this.otherDesignationLabel, "Id": "Other",  'minimumGiftAmount': 0.01, "nonGiftAmount": 0, "checked":false});
                designationLevelList.push({"Name":this.otherDesignationLabel, "Id": "Other",  'minimumGiftAmount': 0.01, "nonGiftAmount": 0, "checked":false});
                this._designationHierachyMap[''] = designationLevelList;
            }
        }).catch(console.error).finally(() => {
            this._showSpinner = false;
        });
    }

    renderedCallback() {
        this.setColor();
        this.equalHeight(true);
        window.addEventListener('resize', (event) => {this.equalHeight(true);});
    }

    
    equalHeight = (resize) => {
        let headerElements = this.template.querySelectorAll('.not-available');
        let allHeaderHeights = [];

        if (!headerElements) {
            return;
        }

        if (resize === true){
            for(let i = 0; i < headerElements.length; i++){
                headerElements[i].style.height = 'auto';
            }
        }

        for(let i = 0; i < headerElements.length; i++){
            var elementHeight = headerElements[i].clientHeight;
            allHeaderHeights.push(elementHeight);
        }

        for(let i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = Math.max.apply( Math, allHeaderHeights) + 'px';
            if(resize === false){
                headerElements[i].className = headerElements[i].className + " show";
            }
        }
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

    setColor(hoveredDesignation) {
        if (this.template.querySelectorAll('.ticket-options .grid-item label') && this.template.querySelectorAll('.ticket-options .grid-item label').length > 0) {
            this.template.querySelectorAll('.ticket-options .grid-item label').forEach(element => {
                let buttonName = element.getAttribute('data-name');
                if (this.isButtonNameSelected(buttonName) || (hoveredDesignation && hoveredDesignation == buttonName)) {
                    element.querySelector('span').style.setProperty('background-color', this.selectedButtonColor);
                    element.querySelector('span').style.setProperty('border-color', this.selectedButtonColor);
                    element.querySelector('span a').style = 'color: '+ this.baseButtonColor + ' !important';
                } else {
                    element.querySelector('span').style.setProperty('background-color', this.baseButtonColor);
                    element.querySelector('span').style.setProperty('border-color', '#eeeeee');
                    element.querySelector('span a').style = 'color: '+ this.selectedButtonColor + ' !important';
                }
            });
            return true;
        }

        return false;
    }


    isButtonNameSelected(buttonName) {
        if (buttonName === 'showMore' && this._showLookup) {
            return true;
        }

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



    searchDesignations(event) {
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
    }

    handleShowMoreClicked(event) {
        if (this.componentVersion == 'Modal') {
            this.resetDesignations();

            this._showModal = true;
        } else {
            if (this.selectedDesignationsList.length < this.maxNumberOfDesignations) {
                this._showLookup = !this._showLookup;
            } else if (this._showLookup) {
                // If max # of designations is selected, user can still close the lookup
                this._showLookup = false;
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
        let id = event.currentTarget.getAttribute('data-id');
        let minimumAmount = 0.01;
        if (event.currentTarget.getAttribute('data-min')) {
            minimumAmount = event.currentTarget.getAttribute('data-min');
        }

        if (this.temporaryDesignationIdSet.has(id) === false) {
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

            this.selectedDesignationsList.push({"Name": name, "Id":id, "minimumGiftAmount":minimumAmount});
            publish(this.messageContext, onlineGivingChannel, {detail :this.selectedDesignationsList, type:"designation"});
            this.checkPledgeDesignation(id);
        } else {
            this.removeSelectedDesignation(id);
            publish(this.messageContext, onlineGivingChannel, {detail :this.selectedDesignationsList, type:"designation"});
        }
        this._numberOfDesignations = this._temporaryDesignationList.length;
    }

    removeSelectedDesignation(Id) {
        let resultList = [];
        for (let eachDesignation of this.selectedDesignationsList) {
            if (eachDesignation.Id !== Id) {
                resultList.push(eachDesignation);
            }
        }

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

    handleMultiDesignationClicked(event) {
        let name = event.currentTarget.getAttribute('data-name');
        let id = event.currentTarget.getAttribute('data-id');
        let index = event.currentTarget.getAttribute('data-index');
        let minimumAmount = event.currentTarget.getAttribute('data-min');
        if (event.currentTarget.checked == true) {
            if (this.temporaryDesignationIdSet.has(id) === false) {
                this._temporaryDesignationList.push({"Name": name, "Id":id, "minimumGiftAmount":minimumAmount});
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
            this._showModal = false;
            this.selectedDesignationsList = [];
            this.selectedDesignationsList = [...this._temporaryDesignationList];
            publish(this.messageContext, onlineGivingChannel, {detail : this.selectedDesignationsList, type:"designation"});

        }

    }

    setKeyword(event) {
        this._keyword = event.currentTarget.value;

        this.template.querySelector('[data-name="keyword"]').setCustomValidity('');
        this.template.querySelector('[data-name="keyword"]').reportValidity();
    }

    resetDesignations() {
        let temporaryDesignationIdSet = this.temporaryDesignationIdSet;

        if (this.isCategoryModal) {
            this._categoryDesignations.forEach(category => {
                if (category.designations.length > 0) {
                    category.designations.forEach(designation => {
                        designation.checked = temporaryDesignationIdSet.has(designation.Id);
                    });
                }
                if (!this._showModal) {
                    category.showDesignations = false;
                    category.class = "accordion-item";
                }
            })
        } else if (this.isFlatModal) {
            this._allDesignations.forEach(designation => {
                designation.checked = temporaryDesignationIdSet.has(designation.Id);
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
                    this._hierarchyTemporaryDesignationList.push({"Name": selectedDesignation.Name, 'Id':selectedDesignation.Id, "minimumGiftAmount":selectedDesignation.minimumGiftAmount, "nonGiftAmount":selectedDesignation.defaultNonGiftAmount});
                }
            }

            this._hierarchyTemporaryDesignationList.forEach(designation => {
                designation.checked = temporaryDesignationIdSet.has(designation.Id);
            });

        }

        this._searchDesignationList.forEach(designation => {
            designation.checked = temporaryDesignationIdSet.has(designation.Id);
        });

    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this.selectedDesignationsList = [...message.detail['designationList']];
            this._temporaryDesignationList = [...message.detail['designationList']];
            this._numberOfDesignations = this._temporaryDesignationList.length;
            this._page = message.detail['page'];
            this._isPledgePayment = message.detail['isPledgePayment'];
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
                if (designation.minimumGiftAmount) {
                    minimumAmount = designation.minimumGiftAmount;
                }
                if (designation.defaultNonGiftAmount) {
                    nonGiftAmount = designation.defaultNonGiftAmount;
                }
            }
            if (this.selectedDesignationsList.length >= this.maxNumberOfDesignations) {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'You can have no more than ' + this.maxNumberOfDesignations + ' designations.',
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            } else if (!alreadyInList) {
                this.selectedDesignationsList.push({"Name": option.label, 'Id':option.value, "minimumGiftAmount":minimumAmount, "nonGiftAmount":nonGiftAmount});
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
                    minimumAmount = designation.minimumGiftAmount;
                    nonGiftAmount = designation.defaultNonGiftAmount;
                }
            }
            this._temporaryDesignationList.push({"Name": name, "Id":id, "minimumGiftAmount":minimumAmount, "nonGiftAmount":nonGiftAmount});
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
    }

    handleDesignationLeave() {
        this.setColor();
    }

    parseDesignationsForMinimums(designationList) {
        let resultList = [];

        for (let designation of designationList) {
            let newDesignation = Object.assign({}, designation);

            if (!newDesignation.minimumGiftAmount) {
                newDesignation.minimumGiftAmount = .01;
            }

            if (newDesignation.defaultNonGiftAmount 
                    && newDesignation.defaultNonGiftAmount > newDesignation.minimumGiftAmount) {
                newDesignation.minimumGiftAmount = newDesignation.defaultNonGiftAmount;
            }

            resultList.push(newDesignation);
        }

        return resultList
    }
}