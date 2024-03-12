import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getVolunteerJobList from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_getVolunteerJobList';

export default class Portal_VolunteerJobList extends LightningElement {
    @api pageName = 'Volunteers';
    @api mainSectionName = 'Volunteer Job List';
    @api subSectionName = '';
    @api recordsPerPage = 2;

    @track _volunteerJobRecordsList = [];
    @track _volunteerJobNameSearchString = '';
    @track _frontEndDataMap = {};
    @track _city = '';
    @track _state = '';
    @track _zipCode = '';
    @track _radius = '';
    @track _country = '';
    @track _shiftList = [];

    // pagination
    @track _currentPage = 1;
    @track _visibleData = [];
    @track _totalItems = 2000;
    @track _offset = 0;
    @track _signUpType = '';

    _isShowSpinner = true;
    _isShowSignUpForm = false;
    _isShowModifyModal = false;
    @track _shiftModalObject = {};

    get initializeVolunteerJobListParams() {
        let locationObject = {city: this._city, state: this._state, postalCode: this._zipCode, country: this._country, radius: parseInt(this._radius, 10)};
        let params = {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName, location: locationObject, searchString: this._volunteerJobNameSearchString, offset: this._offset};
        return params;
    }

    connectedCallback() {
        getVolunteerJobList({params: this.initializeVolunteerJobListParams})
        .then(data => {
            let volunteerJobList = data.volunteerJobList;
            let registeredShiftsSet = new Set(data.registeredShifts);

            volunteerJobList.forEach(job => {                
                job.volunteerShifts.forEach(shift => {
                    if (registeredShiftsSet) {
                        shift.isRegisteredForShift = registeredShiftsSet.has(shift.volunteerShiftId);
                        if (shift.isRegisteredForShift) {
                            job.isSignedUp = true;
                        }
                    }
                });

                if (job.volunteerShifts.length <= 0) {
                    job.isShiftsEmpty = true;
                }
            })

            this._frontEndDataMap = data.frontEndDataMap;
            this._volunteerJobRecordsList = [...this._volunteerJobRecordsList, ...volunteerJobList];
            this._isShowSpinner = false;
        }).catch(error => {
            this._isShowSpinner = false;
            let errorMap = JSON.parse(error.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        });
    }

    handleInput = (event) => {
        this[event.target.name] = event.target.value;
    }

    handleSearch() {
        this._volunteerJobRecordsList = [];
        this._currentPage = 1;
        this._isShowSpinner = true;
        this.connectedCallback();
    }

    handleClear() {
        this._volunteerJobNameSearchString = '';
        this._city = '';
        this._state = '';
        this._zipCode = '';
        this._radius = '';
        this._country = '';
    }

    handleShiftSignUp = (shift, type) => {
        this._signUpType = type;
        this._shiftModalObject = shift;

        if (type == 'modify') {
            this._isShowModifyModal = true;
        } else {
            this._isShowSignUpForm = true;
        }
    }

    handleCloseSignUpModal = (action) => {        
        this._shiftModalObject = {};
        this._isShowSignUpForm = false;

        if (typeof action == 'string') {  // this is to refresh the page after a successful sign up
            this._volunteerJobRecordsList = [];
            this._visibleData = [];
            this.connectedCallback();
        }
    }

    handleCloseModifyModal = (action) => {
        this._shiftModalObject = {};
        this._isShowModifyModal = false;

        if (typeof action == 'string') {  // this is to refresh the page after withdrawning the last application for a shift
            this._volunteerJobRecordsList = [];
            this._visibleData = [];
            this.connectedCallback();
        }
    }

    handleQueryMore = (event) => {
        this._offset = event.detail.offset;
        this.connectedCallback();
    }

    handlePageChange = (paginatedData, pageNumber) => {
        this._visibleData = paginatedData;
        this._currentPage = pageNumber;
    }
}