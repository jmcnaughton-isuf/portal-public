import { LightningElement, api, track } from 'lwc';
import viewTemplate from './portal_MyInformationSocialMediaView.html';
import editTemplate from './portal_MyInformationSocialMediaEdit.html';
export default class Portal_MyInformationSocialMedia extends LightningElement {
    @api informationMap;
    @api displayView
    @api deleteIcon;
    @track _informationMap;
    _openModal;
    _modalUpdateType;
    _modalRecord;
    _modalRecordTypeName;
    _modalSObjectName;
    _interimSocialMedia = [];
    _socialMediaIndex = 0;

    @api
    checkInputValidity() {
        let inputs = this.template.querySelectorAll('c-portal_-My-Information-Edit-Field');
        let validity = true;

        if (inputs) {
            for (const input of inputs) {
                if (input.checkValidity() === false) {
                    if (validity === true) {
                        input.reportValidity();
                        validity = false;
                    }
                }
            }
        }

        return validity;
    }

    connectedCallback() {
        if (this.informationMap) {
            this._informationMap = Object.assign({}, JSON.parse(JSON.stringify(this.informationMap)));
            if (this.informationMap && this.informationMap.interimRecords && this.informationMap.interimRecords.socialMedia && this.informationMap.interimRecords.socialMedia.socialMedia) {
                this._interimSocialMedia = [...JSON.parse(JSON.stringify(this.informationMap.interimRecords.socialMedia.socialMedia))];
            }
            if (this._informationMap && this._informationMap.records && this._informationMap.records.Social_Media && this._informationMap.records.Social_Media.records) {
                for (let record of this._informationMap.records.Social_Media.records) {
                    record['index'] = 'socialMedia' + this._socialMediaIndex;
                    this._socialMediaIndex++;
                }
            }
        }
    }

    render() {
        return this.displayView ? viewTemplate : editTemplate;
    }

    editInformation = () => {
        window.location.replace(window.location.href.split(/[?#]/)[0] + '?mode=edit&tab=socialmedia');
    }

    addSocialMedia(event) {
        try {
            this._informationMap.records.Social_Media.records = [...this._informationMap.records.Social_Media.records,
                {socialMediaPlatform:"", status: "Active",socialMediaUrl: "", Id:null, socialMediaShowOnDirectory: false, index: 'socialMedia' + this._socialMediaIndex}];
                this._socialMediaIndex++;
            this.addToChangeSet('Social_Media');
        } catch (e) {
            console.log(e);
        }
    }

    deleteSocialMedia(event) {
        let type = event.currentTarget.getAttribute('data-type');
        let index = event.currentTarget.getAttribute('data-index');
        if (type == "interim") {
            this._informationMap.interimRecords.socialMedia.socialMedia.splice(index, 1);
            this._interimSocialMedia = [...JSON.parse(JSON.stringify(this._informationMap.interimRecords.socialMedia.socialMedia))];
        } else {
            this._informationMap.records.Social_Media.records.splice(index, 1);
            this.addToChangeSet('Social_Media');
        }

    }

    @api
    getEditInformation(){
        if (this.template.querySelectorAll('c-portal_-My-Information-Edit-Field') && this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').length > 0) {
            try {
                this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').forEach(element => {
                    let fieldChanges = element.getEditInformation();
                    if (fieldChanges.fieldType == "interimSocialMedia") {
                        this._informationMap.interimRecords.socialMedia.socialMedia[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                    } else {
                        if (fieldChanges.fieldName.includes('.')) {
                            let fields = fieldChanges.fieldName.split('.');
                            this._informationMap.records.Social_Media.records[fieldChanges.index][fields[0]][fields[1]] = fieldChanges.value;
                        } else {
                            this._informationMap.records.Social_Media.records[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                        }
                    }

                    if (fieldChanges.toggleField) {
                        if (fieldChanges.fieldType == "interimSocialMedia") {
                            this._informationMap.interimRecords.socialMedia.socialMedia[fieldChanges.fieldType][fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                        } else {
                            this._informationMap.records.Social_Media.records[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                        }
                    }

                    if (fieldChanges.changeSetValue) {
                        this.addToChangeSet(fieldChanges.changeSetValue);
                    }
                })
            } catch (e) {
                console.log(e);
            }
        }
        if (this._informationMap && this._informationMap.records && this._informationMap.records.Social_Media && this._informationMap.records.Social_Media.records) {
            for (let record of this._informationMap.records.Social_Media.records) {
                delete record.index;
            }
        }
        return this._informationMap;
    }

    updateDirectorySetting (event){
        let section = event.target.getAttribute('data-changesetvalue');
        let index = event.target.getAttribute('data-index');
        let type = event.target.getAttribute('data-type');
        if (type == "interim") {
            this._informationMap.interimRecords.socialMedia[index].socialMediaShowOnDirectory = event.target.checked;
        } else {
            this._informationMap.records.Social_Media.records[index].socialMediaShowOnDirectory = event.target.checked;

            if (this._informationMap['Change_Set']) {
                let changeSet = new Set (this._informationMap['Change_Set']);
                changeSet.add(section);
                this._informationMap['Change_Set'] = Array.from(changeSet);

            } else {
                this._informationMap['Change_Set'] = [section];
            }

        }

    }

    addToChangeSet (changeSetValue) {
        if (this._informationMap['Change_Set']) {
            let changeSet = new Set (this._informationMap['Change_Set']);
            changeSet.add(changeSetValue);
            this._informationMap['Change_Set'] = Array.from(changeSet);

        } else {
            this._informationMap['Change_Set'] = [changeSetValue];
        }
    }

    reportUpdate(event) {
        let index= event.target.getAttribute('data-index');
        this._modalUpdateType = event.target.getAttribute('data-type');
        this._modalRecordTypeName = event.target.getAttribute('data-recordtype');
        this._modalSObjectName = event.target.getAttribute('data-sobjectname');
        this._modalRecord = this._informationMap.records.Social_Media.records[index];
        this._openModal = true;
        event.preventDefault();
    }

    handleCloseModal = (saved) => {
        this._openModal = false;
    }

    renderedCallback() {
        this.equalHeight(true);
    }

    equalHeight = (resize) => {
        let headerElements = this.template.querySelectorAll('.headerEqualHeight');
        let elements = this.template.querySelectorAll(".equalHeight")
        let expandedElements = this.template.querySelectorAll(".element-row");
        let allHeights = [];
        let allHeaderHeights = [];
        let allRowHeights = [];

        if (!headerElements || !elements) {
            return;
        }

        if(resize === true){
            for(let i = 0; i < elements.length; i++){
                elements[i].style.height = 'auto';
            }
            for(let i = 0; i < headerElements.length; i++){
                headerElements[i].style.height = 'auto';
            }
            for(let i = 0; i < expandedElements.length; i++){
                expandedElements[i].style.height = 'auto';
            }
        }

        for(let i = 0; i < elements.length; i++){
            var elementHeight = elements[i].clientHeight;
            allHeights.push(elementHeight);
        }

        for(let i = 0; i < headerElements.length; i++){
            var elementHeight = headerElements[i].clientHeight;
            allHeaderHeights.push(elementHeight);
        }

        for(let i = 0; i < expandedElements.length; i++){
            var elementHeight = expandedElements[i].clientHeight;
            allRowHeights.push(elementHeight);
        }

        for(let i = 0; i < elements.length; i++){
            elements[i].style.height = Math.max.apply( Math, allHeights) + 'px';
            if(resize === false){
                elements[i].className = elements[i].className + " show";
            }
        }

        for(let i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = Math.max.apply( Math, allHeaderHeights) + 'px';
            if(resize === false){
                headerElements[i].className = headerElements[i].className + " show";
            }
        }

        for(let i = 0; i < expandedElements.length; i++){
            expandedElements[i].style.height = Math.max.apply( Math, allRowHeights) + 'px';
            if(resize === false){
                expandedElements[i].className = expandedElements[i].className + " show";
            }
        }
    }
}