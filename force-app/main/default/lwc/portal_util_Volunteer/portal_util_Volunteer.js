/**
 * given a volunteer with contact and interim fields, choose only 1 set of data
 * 
 * @param volunteerObject   Volunteer__c derived object, only has field to value mappings
 * @param frontEndDataMap   front end data map from Apex response with field information
 * @return verbose field list containing only 1 set of demographic info, volunteer object ID, and interim ID (if available) 
 */ 
export function createVolunteerFieldList(volunteerObject, frontEndDataMap) {
    let fieldList = [];
    let interimFieldList = [];
    let contactFieldList = [];
    let isSelectInterimData = false;

    // checks whether to use interim data or contact data
    for (const sectionId in frontEndDataMap) {
        if (sectionId != null && !frontEndDataMap[sectionId].mainSection) {
            let dataMap = Object.assign({}, frontEndDataMap[sectionId]);

            for (const fieldId in dataMap.fieldMap) {
                if (fieldId == null) {
                    continue;
                }
                
                // fieldId 'interimId' isn't caught but 2 sections below
                // it searches for 'Id' (for volunteer) and 'interimId'
                if (fieldId.includes('Interim')) {
                    interimFieldList.push(fieldId);
                } else {
                    contactFieldList.push(fieldId);
                }
            }
        }
    }

    // if there is any interim data, we will use the interim instead of contact
    // even if some fields are not populated on the interim (because some fields might not be required)
    if (interimFieldList && interimFieldList.length > 0 && volunteerObject) {
        for (const fieldId in interimFieldList) {
            if (volunteerObject[interimFieldList[fieldId]]) {
                isSelectInterimData = true;
                break;
            }
        }
    }

    // select the editable fields
    for (const sectionId in frontEndDataMap) {
        if (sectionId != null && !frontEndDataMap[sectionId].mainSection) {
            let dataMap = Object.assign({}, frontEndDataMap[sectionId]);

            for (const fieldId in dataMap.fieldMap) {
                if (fieldId == null) {
                    continue;
                }

                // populates fields with either interim data or contact data, not both
                if ((fieldId.includes('Interim') && isSelectInterimData) || (!fieldId.includes('Interim') && !isSelectInterimData) || fieldId == 'Id' || fieldId == 'interimId') {
                    let fieldMap = Object.assign({}, dataMap.fieldMap[fieldId]);
                    fieldMap.id = fieldId;

                    // prepopulate fields if information is available, else assign empty string
                    if (volunteerObject) {
                        fieldMap.value = volunteerObject[fieldId] || '';
                        fieldList.push(fieldMap);
                    }
                }
            }
        }
    }
    fieldList.sort((a, b) => (a.orderNumber - b.orderNumber));
    return fieldList;
}