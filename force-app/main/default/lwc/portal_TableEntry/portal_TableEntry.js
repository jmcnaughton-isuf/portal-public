import { api, LightningElement } from 'lwc';

export default class Portal_TableEntry extends LightningElement {
    @api record = {};
    @api columnData = {};
    @api handleExpandData = () => {};
    @api index;
    @api subitemIndex;
    @api tableSyncInput = () => {};

    get fieldType() {
        return this.columnData.fieldType;
    }

    get fieldId() {
        return this.columnData.fieldId;
    }

    get isText() {
        return !this.fieldType || this.fieldType === 'text' || (this.fieldType === 'expandData' && !this.record.expandedData);
    }

    get isCurrency() {
        return this.fieldType === 'currency';
    }

    get isHtml() {
        return this.fieldType === 'html';
    }

    get isDate(){
        return this.fieldType === 'date';
    }

    get isDateTime() {
        return this.fieldType === 'datetime';
    }

    get isHyperlink() {
        return this.fieldType === 'url';
    }

    get isInputText() {
        return this.fieldType === 'inputText';
    }

    get isConfirmAction() {
        return this.fieldType === 'confirmAction';
    }

    get inputFieldType() {
        return this.columnData.inputFieldType ? this.columnData.inputFieldType : 'text';
    }

    @api checkValidity() {
        if (this.isInputText) {
            let input = this.template.querySelector('c-portal_-input');
            return input.checkValidity();
        }
        return true;
    }

    @api reportValidity() {
        if (this.isInputText) { 
            let input = this.template.querySelector('c-portal_-input');
            input.reportValidity();
        }
    }

    handleInput = (event) => {
        this.tableSyncInput(this.index, this.subitemIndex, this.fieldId, event.target.value);
        this.callback(event);
    }

    get callback() {
        if (this.record.callbackMap?.hasOwnProperty(this.fieldId)) {
            if (typeof(this.record.callbackMap[this.fieldId]) === 'function') {
                // must use this.record inside of lambda { } else the wrong callback may be used after a page change
                return (event) => {this.record.callbackMap[this.fieldId](event);};
            }
            else {
                return this.record.callbackMap[this.fieldId];
            }
        }
        return () => {};
    }

    get href() {
        return this.record.hrefMap?.[this.fieldId];
    }

    get classes() {
        return this.record.classMap?.[this.fieldId];
    }

    get isExpandDataButton() {
        return this.fieldType === 'expandData' && this.record.expandedData;
    }

    get entryValue() {
        if (this.record[this.fieldId] != undefined && this.record[this.fieldId] != null) {
            return this.record[this.fieldId];
        }

        return ' ';
    }

    handleExpandDataClicked() {
        this.handleExpandData(this.record);
    }
}