import { api, LightningElement, track } from 'lwc';
import getPledgeTableData from '@salesforce/apex/PORTAL_GivingHistoryPledgeController.SERVER_getPledgeTableData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';

export default class Poratl_GivingHistoryPledgeTable extends LightningElement {
    callbackDone = false;
    postProcessCallback;

    columnTitlesList = [];
    remainingPaymentsFieldId = 'numberOfPaymentsRemaning';
    updateFieldId = 'updateCreditCard';
    cancelFieldId = 'cancelCreditCard';
    columnTitlesListIdCSV = `pledgeDate, designationName, totalAmount, totalAmountPaid, remainingAmount,  installmentDate, installmentExpectedAmount, ${this.remainingPaymentsFieldId}, ${this.updateFieldId}, ${this.cancelFieldId}`;
    permissionMap = {};
    @track tableData = [];

    totalNumberOfRecords = 0;
    showPagination = false;
    offset;

    @api helperTextHTML;
    @api showNumberOfPaymentsColumn;
    @api numberOfPaymentsColumnTitle;
    @api desginationNameDisplayOption;
    @api desginationNameOverride;
    @api itemsPerPage;
    @api noTableDataTextHTML;

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

            if (this.permissionMap[fieldId] && this.permissionMap[fieldId].display) {
                column.label = this.permissionMap[fieldId].label;
                column.fieldId = fieldId
                column.fieldType = this.permissionMap[fieldId].fieldType !== 'number' ? this.permissionMap[fieldId].fieldType : 'currency'

                if (fieldId === 'designationName') {
                    column.fieldType = 'expandData';
                    column.expandText = this.desginationNameOverride;
                    column.hideText = this.desginationNameOverride;
                }

                resultList.push(column);
            } else if (fieldId == this.remainingPaymentsFieldId && this.showNumberOfPaymentsColumn){
                column.label = this.numberOfPaymentsColumnTitle;
                column.fieldId = fieldId
                column.fieldType = 'text';
                resultList.push(column);
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
        callApexFunction(this, getPledgeTableData, params, this.handleApexResult, () => {});
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

    // getPageTable(itemsPerPage, offset) {
    //     getPledgeTableData({'paramMap' : {'itemsPerPage' : itemsPerPage, 'offset' : offset}})
    //     .then(result => {
    //         this.totalNumberOfRecords = result["totalNumberOfRecords"];
    //         this.permissionMap = result["permissionMap"];

    //         if (this.totalNumberOfRecords == 0) {
    //             this.noTableData = true;
    //             this.callbackDone = true;
    //             return;
    //         }

    //         if (!this.callbackDone) {
    //             this.formatColumnTitles(this.columnTitlesListIdCSV);

    //             if (itemsPerPage < this.totalNumberOfRecords) {
    //                 this.showPagination = true;
    //             }
    //         }

    //         this.formatTableData(result["records"]);
    //         this.callbackDone = true;
    //     })
    //     .catch(error => {
    //         this.showNotification('Error', error.body.message, 'error');
    //     });
    // }

    formatTableData(tableData) {
        for (let tableRow of tableData) {
            if (this.desginationNameDisplayOption != 'List of Names' && tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r != null) {
                let desginationDetailNameList = [];

                for (let desginationRow of tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r) {
                    if (desginationRow.designationName) {
                        desginationDetailNameList.push(desginationRow.designationName);
                    }
                }

                tableRow.designationName = desginationDetailNameList.join(', ');
            } else if (tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r != null && tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r.length == 1) {
                tableRow.designationName = tableRow.ucinn_ascendv2__Designation_Details_Opportunity__r[0].designationName;
            } else {
                tableRow.designationName = this.desginationNameOverride;
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
                tableRow.callbackMap[this.updateFieldId] = this.handleUpdateCreditCard(tableRow.pledgeId, tableRow.subscriptionId, tableRow.externalPaymentGatewayId);
                tableRow.classMap = tableRow.classMap || {};
                tableRow.classMap[this.updateFieldId] = 'button secondary small';
            }
            if (this.showCancelColumn) {
                // add cancel subscription label, callback, CSS
                tableRow[this.cancelFieldId] = 'Cancel';
                tableRow.callbackMap = tableRow.callbackMap || {};
                tableRow.callbackMap[this.cancelFieldId] = this.handleCancelGift(tableRow.pledgeId, tableRow.subscriptionId, tableRow.externalPaymentGatewayId, tableRow.externalSystemId);
                tableRow.classMap = tableRow.classMap || {};
                tableRow.classMap[this.cancelFieldId] = 'button secondary small';
            }
        }

        return tableData
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
                if (this.giftId === tableRow.pledgeId) {
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
                if (this.giftId !== tableRow.pledgeId) {
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

    // formatColumnTitles(columnCSV) {
    //     let fieldIdList = columnCSV.split(',');
    //     let columnList = [];

    //     for (let fieldId of fieldIdList) {
    //         fieldId = fieldId.trim();
    //         let column = {};

    //         if (this.permissionMap[fieldId]) {
    //             column['label'] = this.permissionMap[fieldId].label;
    //             column['display'] = this.permissionMap[fieldId].display;
    //         }
    //         else if (fieldId == 'numberOfPaymentsRemaning'){
    //             column['label'] = this.numberOfPaymentsColumnTitle;
    //             column['display'] = this.showNumberOfPaymentsColumn;
    //         }
    //         columnList.push(column);

    //     }

    //     this.columnTitlesList = columnList;
    // }

    // showDesignationBreakdown(event) {
    //     let index = event.target.dataset.index;
    //     this.tableData[index].showDesginationDropdown = !this.tableData[index].showDesginationDropdown;
    // }

    // pageChange(event) {
    //     this.getPageTable(event.detail.itemsPerPage, event.detail.offset);
    // }

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