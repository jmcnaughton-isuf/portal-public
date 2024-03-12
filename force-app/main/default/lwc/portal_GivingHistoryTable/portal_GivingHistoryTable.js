import { api, LightningElement } from 'lwc';
import getGivingHistoryTableData from '@salesforce/apex/PORTAL_GivingHistoryTableController.SERVER_getGivingHistoryTableData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';

export default class Portal_GivingHistoryTable extends LightningElement {
    @api helperTextHTML;
    @api hideReceipt;
    @api receiptColumnLabel;
    @api receiptRowText;
    @api noReceiptRowText;
    @api receiptBaseURL;
    @api receiptContentPageName;
    @api noTableDataTextHTML;

    noTableData = false;
    tableData = [];
    columnTitlesListIdCSV = 'creditDate, donorName, creditAmount, designationName, creditType, giftType, tenderType';
    permissionMap;
    callbackDone = false;
    postProcessCallback;

    // pagination variables
    @api itemsPerPage;
    totalNumberOfRecords = 0;
    showPagination = false;

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

                resultList.push(column);
            }
        }

        if (!this.hideReceipt) {
            resultList.push({
                label : this.receiptColumnLabel,
                fieldId : 'receiptLink',
                fieldType: 'html'
            });

        }

        return resultList
    }

    connectedCallback() {
        this.getTableData({detail: {offset: 0}});
    }

    getTableData = (event, callback) => {
        this.postProcessCallback = callback;
        let params = {itemsPerPage: this.itemsPerPage * 5, offset : event.detail.offset, 
                      receiptBaseURL : this.receiptBaseURL, receiptContentPageName : encodeURIComponent(this.receiptContentPageName)};
        callApexFunction(this, getGivingHistoryTableData, params, this.handleApexResult, () => {});
    }

    handleApexResult = (result) => {
        let tableData = result['records'];
        this.permissionMap = result['permissionMap'];

        if (tableData.length == 0 && this.tableData.length == 0) {
            this.noTableData = true;
            this.callbackDone = true;
            return;
        }

        let formattedTableData = this.formatTableData(tableData);

        this.tableData = [...this.tableData, ...formattedTableData];
        this.totalNumberOfRecords = result['totalNumberOfRecords'];
        this.callbackDone = true;

        if (this.postProcessCallback) {
            this.postProcessCallback(this.tableData);
        }
    }

    formatTableData = (records) => {
        for (let eachRecord of records) {
            if (eachRecord.receiptURL) {
                eachRecord.receiptLink = '<a href="' + eachRecord.receiptURL + '" target="_blank">' + this.receiptRowText + '</a>'
            } else {
                eachRecord.receiptLink = this.noReceiptRowText;
            }
        }

        return records;
    }
}