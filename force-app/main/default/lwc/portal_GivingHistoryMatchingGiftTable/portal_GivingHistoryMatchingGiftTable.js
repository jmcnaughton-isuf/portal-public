import { api, LightningElement, track } from 'lwc';
import getMatchingGiftData from '@salesforce/apex/PORTAL_GivingHistoryMatchingCtrl.SERVER_getMatchingGiftData'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';

export default class Portal_GivingHistoryMatchingGiftTable extends LightningElement {


    @api desginationNameDisplayOption;
    @api desginationNameOverride;
    @api noTableDataTextHTML;
    permissionMap = {};
    @track tableData = [];
    columnTitlesListIdCSV = 'giftDate, giftDonor, giftStatus, designationName, giftAmount, giftRemainingAmount, giftAmountPaid';
    columnTitlesList = [];
    noTableData = false;

    @api itemsPerPage;
    totalNumberOfRecords;

    @api helperTextHTML;


    callbackDone = false
    postProcessCallback;

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

                if (fieldId === 'designationName') {
                    column.fieldType = 'expandData';
                    column.expandText = this.desginationNameOverride;
                    column.hideText = this.desginationNameOverride;
                }

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
        let params = {'itemsPerPage' : this.itemsPerPage * 5, 'offset' : event.detail.offset};
        callApexFunction(this, getMatchingGiftData, params, this.handleApexResult, () => {});
    }

    handleApexResult = (result) => {
        this.totalNumberOfRecords = result["totalNumberOfRecords"];
        this.permissionMap = result["permissionMap"];

        if (this.totalNumberOfRecords == 0) {
            this.noTableData = true;
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
        }

        return tableData;
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        this.dispatchEvent(evt);
    }

}