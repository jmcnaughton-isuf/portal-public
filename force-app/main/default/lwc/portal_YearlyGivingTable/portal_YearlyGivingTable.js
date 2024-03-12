import { api, LightningElement } from 'lwc';
import getYearlyGivingTableData from '@salesforce/apex/PORTAL_YearlyGivingController.SERVER_getYearlyGivingTableData';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_YearlyGivingTable extends LightningElement {

    @api helperTextHTML;
    @api hideReceipt;
    @api receiptLabel;
    @api receiptRowLabel;
    @api receiptBaseURL;
    @api receiptContentPageName;
    @api receiptNotReadyText;
    @api noTableDataTextHTML;

    tableData = [];
    permissionMap = {};
    callbackDone = false;
    columnDataList = [];
    columnTitlesListIdCSV = 'year, yearAmount';
    noTableData = false;

    get isDisplayTable() {
        if (this.noTableData && !this.noTableDataTextHTML) {
            return false;
        }

        return this.permissionMap?.yearlyGivingTable?.hasOwnProperty('display') ? this.permissionMap.yearlyGivingTable.display : true;
    }

    connectedCallback() {
        callApexFunction(this,
                         getYearlyGivingTableData,
                         {'receiptBaseURL' : this.receiptBaseURL, 'receiptContentPageName' : encodeURIComponent(this.receiptContentPageName)},
        (result) => {
            this.tableData = this.formatTableData(result['records']);
            this.permissionMap = result['permissionMap'];
            this.callbackDone = true;

            if (this.tableData.length == 0) {
                this.noTableData = true;
                return;
            }

            this.formatColumnTitles(this.columnTitlesListIdCSV);
        });
    }

    formatColumnTitles(columnCSV) {
        let fieldIdList = columnCSV.split(',');
        let columnList = [];

        for (let fieldId of fieldIdList) {
            fieldId = fieldId.trim();
            let column = {};

            if (this.permissionMap[fieldId]) {
                if (!this.permissionMap[fieldId].display) {
                    continue;
                }
                column.label = this.permissionMap[fieldId].label;
                column.fieldId = fieldId;
                if (fieldId === 'yearAmount') {
                    column.fieldType = 'currency';
                }

                columnList.push(column);
            }
        }

        if (!this.hideReceipt) {
            columnList.push({
                label : this.receiptLabel,
                fieldId : 'receiptLink',
                fieldType : 'html'
            });

        }

        this.columnDataList = columnList;
    }

    formatTableData(records) {
        for (let eachRecord of records) {
            if (eachRecord.receiptURL) {
                eachRecord.receiptLink = '<a href="' + eachRecord.receiptURL + '" target="_blank">' + this.receiptRowLabel + '</a>'
            } else {
                eachRecord.receiptLink = this.receiptNotReadyText;
            }
        }

        return records;
    }
}