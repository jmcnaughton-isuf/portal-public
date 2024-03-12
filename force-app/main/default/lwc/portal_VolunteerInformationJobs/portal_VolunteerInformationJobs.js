import { api, LightningElement, track } from 'lwc';

export default class Portal_VolunteerInformationJobs extends LightningElement {
    @api jobList = [];
    @api isShowReportButton = false;
    @api handleReportHours = () => {};
    @api itemsPerPage = 4;

    @track _jobListToShow = [];

    handlePageChange = (paginatedData, pageNumber) => {
        console.log(JSON.stringify(paginatedData));
        this._jobListToShow = paginatedData;
    }
}