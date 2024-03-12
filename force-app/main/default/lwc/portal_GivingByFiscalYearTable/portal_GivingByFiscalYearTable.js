import { api, LightningElement, track } from 'lwc';
import getTableData from '@salesforce/apex/PORTAL_GivingByFiscalYearTableController.SERVER_getFiscalYearTableData';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_YearlyGivingHistoryTable extends LightningElement {
    @api rowsPerPage;
    @api helperText;
    @api hideRowsWithNoGiving;
    @api fiscalYearOrder;
    @api noTableDataTextHTML;

    columnTitlesListIdCSV = 'fiscalYear, cashAmount, fiscalAmountFundraising';
    columnDataList = [];

    allTableData = [];
    noTableData = false;

    callbackDone = false;
    permissionMap = {};

    get numberOfRows() {
        if (!this.allTableData) {
            return 0;
        }

        return this.allTableData.length;
    }

    get isDisplayTable() {
        return !this.noTableData || this.noTableDataTextHTML || !this.hideRowsWithNoGiving;
    }

    connectedCallback() {
        this.setupTable();
    }

    formatColumnTitles(columnCSV) {
        let fieldIdList = columnCSV.split(',');
        let columnList = [];

        for (let fieldId of fieldIdList) {
            fieldId = fieldId.trim();
            let column = {};

            if (this.permissionMap[fieldId] && this.permissionMap[fieldId].display) {
                column.label = this.permissionMap[fieldId].label;
                column.fieldId = fieldId;
                if (fieldId != 'fiscalYear') {
                    column.fieldType = 'currency';
                }
                columnList.push(column);
            }

        }

        this.columnDataList = columnList;
    }

    setupTable() {
        callApexFunction(this,
                         getTableData,
                         {'hideEmptyRows' : this.hideRowsWithNoGiving,
                          'fiscalYearOrder' : this.fiscalYearOrder
                         },
        (result) => {
            this.permissionMap = result['permissionMap'];
            this.allTableData = result['records'];

            if (this.numberOfRows == 0) {
                this.noTableData = true;
                this.callbackDone = true;
                return;
            }

            this.formatColumnTitles(this.columnTitlesListIdCSV);
            this.callbackDone = true;
        })
    }
}