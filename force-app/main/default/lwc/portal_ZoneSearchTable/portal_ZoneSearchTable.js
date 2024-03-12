import { LightningElement, api } from 'lwc';

export default class Portal_ZoneSearchTable extends LightningElement {
    // Table stuff
    @api tableData;
    @api frontEndDataMap;
    @api itemsPerPage;
    @api currentPageNumber = 1;
    @api getMoreZoneRecords;
    fieldIdList = ["homePageHTML", "leadershipHTML", "primaryContactHTML", "socialMediaHTML"];
    
    get columnDataList() {
        let resultList = [];
        if (!this.frontEndDataMap) {
            return resultList;
        }


        this.fieldIdList.forEach(fieldId => {
            let column = {};
            if (this.frontEndDataMap[fieldId] && this.frontEndDataMap[fieldId].display) {
                column.label = this.frontEndDataMap[fieldId].label;
                column.fieldId = fieldId;
                column.fieldType = 'html';

                resultList.push(column);
            }
            else if (fieldId === 'homePageHTML' && this.frontEndDataMap.Name && this.frontEndDataMap.Name.display) {
                column.label = this.frontEndDataMap.Name.label;
                column.fieldId = fieldId;
                column.fieldType = 'html';

                resultList.push(column);
            }
            else if (fieldId === 'primaryContactHTML' && this.frontEndDataMap.zoneMemberships && this.frontEndDataMap.zoneMemberships.display) {
                column.label = this.frontEndDataMap.zoneMemberships.label;
                column.fieldId = fieldId;
                column.fieldType = 'html';

                resultList.push(column);
            }
        })

        return resultList
    }
}