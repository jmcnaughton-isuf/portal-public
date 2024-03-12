import { LightningElement, track, wire, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getEmailTemplateList from '@salesforce/apex/PORTAL_LWC_VolunteerReminderEmail.SERVER_getEmailTemplateList';
import scheduleVolunteerReminderEmails from '@salesforce/apex/PORTAL_LWC_VolunteerReminderEmail.SERVER_scheduleVolunteerReminderEmails';

export default class Portal_quickaction_VolunteerReminderEmail extends LightningElement {
    @api recordId;

    @track _templateList = [];
    @track _showSpinner = true;
    @track _templateToHtmlValue = {};
    @track _currentTemplate = '';
    @track _scheduleDate;

    get renderComponent() {
        return this._templateList.length > 0;
    }

    get htmlValue() {
        if (!this._currentTemplate) {
            return '';
        }

        console.log(JSON.stringify(this._templateToHtmlValue[this._currentTemplate]));

        return this._templateToHtmlValue[this._currentTemplate];
    }

    @wire(getEmailTemplateList)
    getEmailTemplateList({error, data}) {
        if (error) {
            let errorMap = JSON.parse(error);
            alert(errorMap.message);
            console.log(errorMap.error);
        }

        if (!data) {
            return;
        }

        data.forEach(template => {
            let newTemplate = {};

            newTemplate.label = template.Name;
            newTemplate.value = template.DeveloperName;

            this._templateToHtmlValue[template.DeveloperName] = template.HtmlValue;

            this._templateList.push(newTemplate);
        })

        this._currentTemplate = this._templateList[0].value;

        this._showSpinner = false;
    }

    handleTemplateChange = (event) => {
        this._currentTemplate = event.target.value;
    }

    handleSchedule() {
        scheduleVolunteerReminderEmails({params: {recordId: this.recordId,
                                                  scheduleDateTime: new Date(this._scheduleDate).getTime(),
                                                  emailTemplateApiName: this._currentTemplate}}).then(response => {
            this.dispatchEvent(new CloseActionScreenEvent());
        })
    }

    handleDateChange(event) {
        this._scheduleDate = event.target.value;
        console.log(this._scheduleDate);
    }

    handleCancel(){
      this.dispatchEvent(new CloseActionScreenEvent());
    }
}