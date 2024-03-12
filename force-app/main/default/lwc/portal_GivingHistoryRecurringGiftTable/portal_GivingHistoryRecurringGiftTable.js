import { api, LightningElement, track } from 'lwc';
import getRecurringGiftTableData from '@salesforce/apex/PORTAL_GivingHistoryRecurringCtrl.SERVER_getRecurringGiftTableData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';

export default class Portal_GivingHistoryRecurringGiftTable extends LightningElement {
    @api helperTextHTML;
    @api desginationNameDisplayOption;
    @api desginationNameOverride;
    @api showNextInstallmentPaymentCoulmn;
    @api nextInstallmentPaymentColumn;
    @api noTableDataTextHTML;
    permissionMap = {};
    @track tableData = [];
    columnTitlesList = [];
    nextPaymentFieldId = 'nextExpectedPaymentDate';
    updateFieldId = 'updateCreditCard';
    cancelFieldId = 'cancelCreditCard';
    columnTitlesListIdCSV = `recurringGiftDonor, recurringGiftDesignationName, recurringGiftAmount, recurringGiftAmountPaid, recurringGiftStartDate, recurringGiftEndDate, recurringGiftFrequency, ${this.nextPaymentFieldId}, ${this.updateFieldId}, ${this.cancelFieldId}`;

    @api paymentMethod;
    @api externalGatewayName;
    @api showUpdateCreditCardColumn;
    @api updateCreditCardColumnTitle;
    @track showUpdateCreditCardModal = false;
    @api showCancelColumn;
    @api cancelColumnTitle;
    @track showCancelGiftModal = false;
    giftId = undefined;
    subscriptionId = undefined;
    externalPaymentGatewayId = undefined;
    externalSystemId = undefined;

    callbackDone = false;
    postProcessCallback;

    @api itemsPerPage;
    totalNumberOfRecords;
    showPagination = false;

    get isTableEmpty() {
        return (!this.tableData || this.tableData.length <= 0);
    }

    get columnDataList() {
        let resultList = [];
        if (!this.permissionMap) {
            return resultList;
        }

        let fieldIdList = this.columnTitlesListIdCSV.split(',');

        for (let fieldId of fieldIdList) {
            fieldId = fieldId.trim();
            let column = {};

            if (this.permissionMap[fieldId]) {
                column.label = this.permissionMap[fieldId].label;
                column.fieldId = fieldId
                column.fieldType = this.permissionMap[fieldId].fieldType !== 'number' ? this.permissionMap[fieldId].fieldType : 'currency'

                if (fieldId === 'recurringGiftDesignationName') {
                    column.fieldType = 'expandData';
                    column.expandText = this.desginationNameOverride;
                    column.hideText = this.desginationNameOverride;
                }

                resultList.push(column);
            }
            // else field IDs are not from custom metadata  
            else if (fieldId == this.nextPaymentFieldId && this.showNextInstallmentPaymentCoulmn) {
                column.label = this.nextInstallmentPaymentColumn;
                column.fieldId = fieldId;
                column.fieldType = 'date';
                resultList.push(column);
                // column['display'] = this.showNextInstallmentPaymentCoulmn;
            } else if (fieldId === this.updateFieldId && this.showUpdateCreditCardColumn) {
                column.label = this.updateCreditCardColumnTitle;
                column.fieldId = fieldId;
                column.fieldType = 'url';
                resultList.push(column);
            } else if (fieldId === this.cancelFieldId && this.showCancelColumn) {
                column.label = this.cancelColumnTitle;
                column.fieldId = fieldId;
                column.fieldType = 'url';
                resultList.push(column);
            }
        }

        return resultList
    }

    connectedCallback() {
        this.getTableData({detail: {offset: 0}});
    }

    getTableData = (event, callback) => {
        this.postProcessCallback = callback;
        let params = {'itemsPerPage' : this.itemsPerPage * 5, 'offset' : event.detail.offset,
                      'showUpdateCreditCard' : this.showUpdateCreditCardColumn, 'paymentMethod' : this.paymentMethod};
        callApexFunction(this, getRecurringGiftTableData, params, this.handleApexResult, () => {});
    }

    handleApexResult = (result) => {
        this.totalNumberOfRecords = result["totalNumberOfRecords"];
        this.permissionMap = result["permissionMap"];

        if (this.totalNumberOfRecords == 0) {
            this.callbackDone = true;
            return;
        }

        this.tableData = [...this.tableData, ...this.formatTableData(result.records)];
        this.callbackDone = true;

        if (this.postProcessCallback) {
            this.postProcessCallback(this.tableData);
        }
    }

    formatTableData(tableData) {
        for (let tableRow of tableData) {
            if (this.desginationNameDisplayOption != 'List of Names' && tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r != null) {
                let desginationDetailNameList = [];

                for (let desginationRow of tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r) {
                    if (desginationRow.recurringGiftDesignationName) {
                        desginationDetailNameList.push(desginationRow.recurringGiftDesignationName);
                    }
                }

                tableRow.recurringGiftDesignationName = desginationDetailNameList.join(', ');
            } else if (tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r != null && tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r.length == 1) {
                tableRow.recurringGiftDesignationName = tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r[0].recurringGiftDesignationName;
            } else {
                tableRow.recurringGiftDesignationName = this.desginationNameOverride;
            }

            if (tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r != null && tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r.length > 1) {
                tableRow.multipleDesgination = true;
                tableRow.expandedData = tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r;
            } else {
                tableRow.multipleDesgination = false;
            }

            if (this.showUpdateCreditCardColumn) {
                // add update credit card callback and CSS classes
                tableRow.callbackMap = tableRow.callbackMap || {};
                tableRow.callbackMap[this.updateFieldId] = this.handleUpdateCreditCard(tableRow.recurringGiftId, tableRow.subscriptionId, tableRow.externalPaymentGatewayId);
                tableRow.classMap = tableRow.classMap || {};
                tableRow.classMap[this.updateFieldId] = 'button secondary small';
            }

            if (this.showCancelColumn) {
                // add cancel subscription label, callback, CSS
                tableRow[this.cancelFieldId] = 'Cancel';
                tableRow.callbackMap = tableRow.callbackMap || {};
                tableRow.callbackMap[this.cancelFieldId] = this.handleCancelGift(tableRow.recurringGiftId, tableRow.subscriptionId, tableRow.externalPaymentGatewayId, tableRow.externalSystemId);
                tableRow.classMap = tableRow.classMap || {};
                tableRow.classMap[this.cancelFieldId] = 'button secondary small';
            }
        }

        return tableData;
    }

    handleUpdateCreditCard = (giftId, subscriptionId, externalPaymentGatewayId) => {
        return () => {
            this.showUpdateCreditCardModal = true;
            this.giftId = giftId;
            this.subscriptionId = subscriptionId;
            this.externalPaymentGatewayId = externalPaymentGatewayId;
        };
    }

    handleCancelGift = (giftId, subscriptionId, externalPaymentGatewayId, externalSystemId) => {
        return () => {
            this.showCancelGiftModal = true;
            this.giftId = giftId;
            this.subscriptionId = subscriptionId;
            this.externalPaymentGatewayId = externalPaymentGatewayId;
            this.externalSystemId = externalSystemId;
        }
    }

    closeUpdateModal = (result) => {
        if (typeof(result) === 'string') {
            // replace old credit card digits with new ones
            for (let tableRow of this.tableData) {
                if (this.giftId === tableRow.recurringGiftId) {
                    tableRow[this.updateFieldId] = `Update Card Ending in ${result}`;
                    break;
                }
            }
            this.tableData = [...this.tableData];
        }
        this.showUpdateCreditCardModal = false;
        this.giftId = undefined;
        this.subscriptionId = undefined;
        this.externalPaymentGatewayId = undefined;
    }

    closeCancelModal = (result) => {
        if (typeof(result) === 'boolean' && result) {
            let newTableData = [];
            for (let tableRow of this.tableData) {
                if (this.giftId !== tableRow.recurringGiftId) {
                    newTableData.push(tableRow);
                }
            }
            this.tableData = newTableData;
        }

        this.showCancelGiftModal = false;
        this.giftId = undefined;
        this.subscriptionId = undefined;
        this.externalPaymentGatewayId = undefined;
        this.externalSystemId = undefined;
    }

    showNotification(title, message, variant = 'info', mode = 'dismissible') {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });

        this.dispatchEvent(evt);
    }

}