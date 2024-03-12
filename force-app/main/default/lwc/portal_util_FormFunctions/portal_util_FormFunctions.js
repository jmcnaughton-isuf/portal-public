import { LightningElement } from 'lwc';

export default class Portal_util_FormFunctions extends LightningElement {}

export function getFormList(thisObject) {
    return thisObject.template.querySelectorAll('c-portal_-Form');
}

export function getFormRecordList(thisObject) {
    return thisObject.template.querySelectorAll('c-portal_-Form-Record');
}

export function getFormById(formData, formId) {
    if (formData.formId === formId) {
        return formData;
    }

    for (let form of formData.subSectionList) {
        if (form.formId === formId) {
            return form;
        }
    }

    return {};
}

export function getFormInfo(thisObject) {
    let result = {};

    let formList = getFormList(thisObject);

    if (!formList) {
        return result;
    }

    for (let form of formList) {
        let formInfo = form.getFormInfo();

        if (!formInfo) {
            continue;
        }

        result = Object.assign(result, formInfo);
    }

    return result;
}

export function getFormRecordInfo(thisObject) {
    let result = [];

    let formRecordList = getFormRecordList(thisObject);

    if (!formRecordList) {
        return result;
    }

    for (let record of formRecordList) {
        let recordInfo = record.getFormRecordInfo();

        if (!recordInfo) {
            continue;
        }

        result.push(recordInfo);
    }

    return Object.values(result);
}

export function checkFormValidity(thisObject) {
    let formList = getFormList(thisObject);
    for (let eachForm of formList) {
        if (!eachForm.checkFormValidity()) {
            return false;;
        }
    }
    return true;
}

export function reportFormValidity(thisObject) {
    let formList = getFormList(thisObject);
    for (let eachForm of formList) {
        eachForm.reportFormValidity();
    }
}