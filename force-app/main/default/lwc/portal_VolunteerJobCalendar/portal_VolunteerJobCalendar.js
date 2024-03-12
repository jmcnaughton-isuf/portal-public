import { LightningElement, track, api } from 'lwc';
import getVolunteerJobList from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_getVolunteerJobList';

export default class Portal_VolunteerJobCalendar extends LightningElement {
    @api pageName = 'Volunteers';
    @api mainSectionName = 'Volunteer Job List';
    @api subSectionName = '';
    @api noJobsMobileMessage = "There are no events this month";
    
    _daysOfTheWeek = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];
    _monthsOfTheYear = ['January', 'February', 'March', 'April',
                        'May', 'June', 'July', 'August',
                        'September', 'October', 'November', 'December'];
    _abbrMonthsOfTheYear = ['Jan', 'Feb', 'Mar', 'Apr',
                            'May', 'Jun', 'Jul', 'Aug',
                            'Sep', 'Oct', 'Nov', 'Dec'];

    @track _month = 'January';
    @track _currentMonthDate;
    @track _beginningMonth
    @track _beginningYear;
    @track _endingYear;
    @track _yearOptions;

    @track _daysGrid;
    @track _monthHasJobs;

    @track _frontEndDataMap = {};
    @track _jobModalObject = {};
    @track _jobList = [];
    @track _isShowModal = false;
    @track _isShowSignUpForm = false;
    @track _shiftModalObject = {};
    @track _signUpType = '';
    @track _volunteerId = '';
    @track _clickedDate = {};
    @track _isRefreshData = false;

    @track _isResized = false;
    
    _isSmallMobileResolution = false; // "Small" refers to a screen width <= 350px, which is primarily the Galaxy Fold but may apply to other devices in the future.

    get _currentYear() {
        if (!this._currentMonthDate) {
            return '';
        }

        return this._currentMonthDate.getFullYear().toString();
    }

    get isNextMonthDisabled() {
        let nextButton = this.template.querySelector('[title="Next"]');
        if (!nextButton) {
            return false;
        }

        let currentMonthDate = new Date(this._currentMonthDate);

        currentMonthDate.setMonth(currentMonthDate.getMonth() + 1); 
        currentMonthDate = new Date(currentMonthDate);

        if (currentMonthDate.getFullYear() > this._endingYear) {
            nextButton.classList.add('disabled-button');
            return true;
        } 

        nextButton.classList.remove('disabled-button');
        return false;
    }

    get isPreviousMonthDisabled() {
        let previousButton = this.template.querySelector('[title="Back"]');
        if (!previousButton) {
            return false;
        }

        let currentMonthDate = new Date(this._currentMonthDate);

        currentMonthDate.setMonth(currentMonthDate.getMonth() - 1); 
        currentMonthDate = new Date(currentMonthDate);

        if (currentMonthDate.getFullYear() < this._beginningYear ||
                (currentMonthDate.getFullYear().toString() === this._beginningYear && currentMonthDate.getMonth() < this._beginningMonth)) {
            previousButton.classList.add('disabled-button');
            return true;
        } 

        previousButton.classList.remove('disabled-button');
        return false;
    }

    get initializeVolunteerJobListParams() {
        let params = {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};

        return params;
    }

    connectedCallback() {
        window.addEventListener('resize', (event) => {this.handleResize();});
        getVolunteerJobList({params: this.initializeVolunteerJobListParams})
        .then(data => {
            let jobList = data.volunteerJobList;
            let registeredShiftsSet = new Set(data.registeredShifts);

            for (let jobListIndex = 0; jobListIndex < jobList.length; jobListIndex++) {
                let volunteerShifts = jobList[jobListIndex].volunteerShifts;

                if (!volunteerShifts) {
                    continue;
                }

                volunteerShifts.forEach(shift => {
                    if (registeredShiftsSet) {
                        shift.isRegisteredForShift = registeredShiftsSet.has(shift.volunteerShiftId);
                    }
                });
            }

            this._frontEndDataMap = data.frontEndDataMap;
            this._jobList = jobList;

            let today = new Date();
            let mm = today.getMonth(); //January is 0!
            let yyyy = today.getFullYear();

            today = new Date(yyyy, mm, 1); 

            // this._month = today;
            this._currentMonthDate = today;
            this._beginningMonth = mm;
            this._beginningYear = yyyy.toString();
            this._endingYear = (yyyy + 5).toString();

            let yearOptions = [];

            for (let yearIndex = this._beginningYear; yearIndex <= this._endingYear; yearIndex++) {
                yearOptions.push({'label': yearIndex.toString(), 'value': yearIndex.toString()});
            }

            this._yearOptions = yearOptions;

            this.createCalendar();
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

    renderedCallback() {
        this._isResized = false;
        let eventDivs = this.template.querySelectorAll('.force-height');
        for (let div of eventDivs) {
            // display "show more" dropdown or not
            if (div.scrollHeight > div.clientHeight + 1) {
                div.nextSibling.style.display = '';
            }
            else {
                div.nextSibling.style.display = 'none';
            }
        }

        this.adjustYearPicklistClasses();
    }

    adjustYearPicklistClasses() {
        let isCurrentlySmallMobileResolution = window.innerWidth <= 350;
        if (this._isSmallMobileResolution !== isCurrentlySmallMobileResolution) {
            this._isSmallMobileResolution = isCurrentlySmallMobileResolution;

            let yearPicklist = this.template.querySelector('div.slds-grid.slds-page-header div.year-picklist');
            yearPicklist.classList.toggle('slds-size--2-of-12');
            yearPicklist.classList.toggle('slds-size--4-of-12');
            yearPicklist.classList.toggle('slds-align--absolute-center');

            this._isSmallMobileResolution ? this.abbreviateCurrentDisplayedMonthLabel() : this.lengthenCurrentDisplayedMonthLabel();
        }
    }

    abbreviateCurrentDisplayedMonthLabel() {
        let today = this._currentMonthDate;
        let mm = today.getMonth();

        this._month = this._abbrMonthsOfTheYear[mm];
    }

    lengthenCurrentDisplayedMonthLabel() {
        let today = this._currentMonthDate;
        let mm = today.getMonth();

        this._month = this._monthsOfTheYear[mm];
    }

    createCalendar() {
        let today = this._currentMonthDate;
        let dd = today.getDate();
        let mm = today.getMonth();
        let yyyy = today.getFullYear();
        let firstDay = new Date(yyyy, mm, 1);
        let startingDay = firstDay.getDay();
        let monthLength = new Date(yyyy, mm + 1, 0).getDate();

        let jobList = this._jobList;

        let cal_months_labels = [];
        if (this._isSmallMobileResolution) {
            cal_months_labels = this._abbrMonthsOfTheYear;
        } else {
            cal_months_labels = this._monthsOfTheYear;
        }  

        this._month = cal_months_labels[mm]; 
        
        // compensate for leap year
        if (mm === 2) { // February only!
            if((yyyy % 4 === 0 && yyyy % 100 !== 0) || yyyy % 400 === 0){
                monthLength = 29;
            }
        }

        let lastDayMonthYear = new Date(today.getFullYear(), today.getMonth(), 0);
        let lastMonthDate = lastDayMonthYear.getDate();

        let nextDayMonthYear = new Date(today.getFullYear(), today.getMonth() + 1, 1);
        let nextMonthDay = nextDayMonthYear.getDay();

        let nonVisibleStartDays = [];
        let daysList = [];
        let nonVisibleEndDays = [];
        this.createDays(lastDayMonthYear, lastMonthDate-(startingDay - 1), lastMonthDate, jobList, nonVisibleStartDays);
        this.createDays(firstDay, 1, monthLength, jobList, daysList);
        this.createDays(nextDayMonthYear, 1, 7 - nextMonthDay, jobList, nonVisibleEndDays); 

        this.createGrid(nonVisibleStartDays, daysList, nonVisibleEndDays);
    }

    createDays(date, startDay, endDay, jobList, daysList) {
        // Get the month and year of the date we are currently at in the calendar.
        let getMonth = date.getMonth() + 1;
        let getFullYear = date.getFullYear(); 

        for (let i = startDay; i <= endDay; i++) {
            let myDate = getFullYear.toString() + '-' + getMonth.toString() + '-' + i.toString();
            let dayMap = {day: i, key: i + Date.now(), date: myDate};
            let dayJobList = [];
            dayMap.readableDate = `${this._monthsOfTheYear[getMonth - 1]} ${i}, ${getFullYear}`;

            if (jobList != null) {
                for(let e = 0;  e < jobList.length; e++) {
                    if (!jobList[e].volunteerShifts) {
                        continue;
                    }

                    let job = jobList[e];
                    let uniqueDayList = [];
                    for (let shift = 0; shift < job.volunteerShifts.length; shift++) {
                        if (!job.volunteerShifts[shift].volunteerJobShiftStartDateTime || !job.volunteerShifts[shift].volunteerJobShiftEndDateTime) {
                            continue;
                        }
                        
                        let eventStartDate = new Date(job.volunteerShifts[shift].volunteerJobShiftStartDateTime);
                        let eventEndDate = new Date(job.volunteerShifts[shift].volunteerJobShiftEndDateTime);
                        
                        // if the calendar day of the month matches the calendar day of the event, then add the subject of the event to the calendar day component
                        //if (eventStartDate.getDate() == i && (eventStartDate.getMonth() + 1) == getMonth && eventStartDate.getFullYear() == getFullYear)  {
                        if (((i == eventStartDate.getDate()) || (i == eventEndDate.getDate()))
                            && ((eventStartDate.getMonth() + 1) <= getMonth) && (getMonth <= (eventEndDate.getMonth() + 1)) 
                            && (eventStartDate.getFullYear() <= getFullYear) && (getFullYear <= eventEndDate.getFullYear()) && !uniqueDayList.includes(i)) {

                            dayMap.hasJob = true;
                            dayMap.hasJobThisMonth = this._currentMonthDate.getMonth() === date.getMonth();
                            let dayJobObject = Object.assign({}, jobList[e]);
                            dayJobList.push(dayJobObject);
                            uniqueDayList.push(i);
                        }

                    }
                } // end for 
            }

            dayMap.jobList = dayJobList;
            
            daysList.push(dayMap);
        }  
    }

    createGrid(nonVisibleStartDays, daysList, nonVisibleEndDays) {
        let allDays = [];

        nonVisibleStartDays.forEach(day => {
            day.isVisible = false;
        })

        daysList.forEach(day => {
            day.isVisible = true;
        })

        nonVisibleEndDays.forEach(day => {
            day.isVisible = false;
        })

        allDays = [...nonVisibleStartDays];
        allDays.push(...daysList);
        allDays.push(...nonVisibleEndDays);

        let daysGrid = [];
        let daysRow = [];

        this._monthHasJobs = false;
        for (let dayIndex = 1; dayIndex <= allDays.length; dayIndex++) {
            daysRow.push(allDays[dayIndex - 1]);
            this._monthHasJobs = this._monthHasJobs || (allDays[dayIndex - 1].hasJobThisMonth === true ? true : false);

            if (dayIndex % 7 === 0) {
                daysGrid.push(daysRow);
                daysRow = [];
            }
        }

        this._daysGrid = daysGrid;
        if (this._isRefreshData) {
            this._isRefreshData = false;
            this.handleJobClick(this._clickedDate);
        }
    }

    handleResize() {
        this._isResized = true;
        this.adjustYearPicklistClasses();
    }

    handleNextMonthClick() {
        let currentMonthDate = new Date(this._currentMonthDate);

        currentMonthDate.setMonth(currentMonthDate.getMonth() + 1); 
        currentMonthDate = new Date(currentMonthDate);

        if (currentMonthDate.getFullYear() > this._endingYear) {
            return;
        } 

        this._currentMonthDate = currentMonthDate;
        this.template.querySelector('select').value = this._currentMonthDate.getFullYear();

        this.createCalendar();
    }

    handlePreviousMonthClick() {
        let currentMonthDate = new Date(this._currentMonthDate);

        currentMonthDate.setMonth(currentMonthDate.getMonth() - 1); 
        currentMonthDate = new Date(currentMonthDate);

        if (currentMonthDate.getFullYear() < this._beginningYear) {
            return;
        } 

        this._currentMonthDate = currentMonthDate;
        this.template.querySelector('select').value = this._currentMonthDate.getFullYear();

        this.createCalendar();
    }

    handleYearChange(event) {
        this._currentMonthDate.setFullYear(event.target.value);
        this.createCalendar();
    }

    handleTodayClick() {
        this._currentMonthDate.setFullYear(this._beginningYear);
        this._currentMonthDate.setMonth(this._beginningMonth);
        this.template.querySelector('select').value = this._currentMonthDate.getFullYear();

        this.createCalendar();
    }

    handleJobClick = (event) => {
        this._clickedDate = {currentTarget: {dataset: {date: event.currentTarget.dataset.date, id: event.currentTarget.dataset.id}}};
        let clickedDate = new Date(event.currentTarget.dataset.date);
        let jobModalObject = {};
        for (const jobIndex in this._jobList) {
            if (this._jobList[jobIndex].Id != event.currentTarget.dataset.id) {
                continue;
            }

            jobModalObject = Object.assign({}, this._jobList[jobIndex]);

            jobModalObject.volunteerShifts = jobModalObject.volunteerShifts.filter(shift => {
                if (!shift.volunteerJobShiftStartDateTime || !shift.volunteerJobShiftEndDateTime) {
                    return false;
                }

                let startDate = new Date(shift.volunteerJobShiftStartDateTime);
                let endDate = new Date(shift.volunteerJobShiftEndDateTime);
                if ((clickedDate.getUTCDate() == startDate.getDate()) && (clickedDate.getUTCMonth() == startDate.getMonth()) && (clickedDate.getUTCFullYear() == startDate.getFullYear())) {
                    return true;
                } else if ((clickedDate.getUTCDate() == endDate.getDate()) && (clickedDate.getUTCMonth() == endDate.getMonth()) && (clickedDate.getUTCFullYear() == endDate.getFullYear())) {
                    return true;
                } else {
                    return false;
                }
            });

            break;
        }

        this._jobModalObject = jobModalObject;
        this._isShowModal = true;
    }

    local_handleDayClick(event) {
        this.handleDayClick(event.target.dataset.date);
    }

    handleVolunterShiftSignUp = (shift, type) => {
        this._signUpType = type;
        this._shiftModalObject = shift;
        if (type == 'modify') {
            this._volunteerId = '';
            this._isShowModifyModal = true;
        } else {
            this._isShowSignUpForm = true;
        }
        this.handleCloseCalendarModal();
    }

    handleCloseCalendarModal = () => {
        //this._jobModalObject = {};
        this._isShowModal = false;
    }

    handleCloseSignUpModal = (action) => {
        this._shiftModalObject = {};
        this._isShowSignUpForm = false;

        if (action == 'showCalendarShifts') {
           this._isShowModal = true;
        } else if (action === 'refreshList') {
            this._jobList = [];
            this._jobModalObject = {};
            this._isRefreshData = true;
            this.connectedCallback();
        }
    }

    handleCloseModifyModal = (action) => {
        this._shiftModalObject = {};
        this._isShowModifyModal = false;

        if (action == 'showCalendarShifts') {
            this._isShowModal = true;
        } else if (action == 'refreshList') {
            this._jobList = [];
            this._jobModalObject = {};
            this._isRefreshData = true;
            this.connectedCallback();
        }
    }

    handleSignUpBackButton = () => {
        this._isShowSignUpForm = false;
    }

    handleShowMoreWrapper = (event) => {
        this.handleShowMore(event.target);
    }
    
    handleClosePopup = (event) => {
        let anchors = this.template.querySelectorAll('a.show-all-events');
        for (let a of anchors) {
            if (event.currentTarget.dataset.date === a.dataset.date) {
                this.handleShowMore(a);
                break;
            }
        }
    }

    handleShowMore = (anchor) => {
        let popoverClasses = anchor.nextSibling.classList;
        popoverClasses.toggle('show');
        anchor.setAttribute('aria-haspopup', popoverClasses.contains('show'));
        if (anchor.parentNode?.parentNode?.nextSibling === null){
            anchor.nextSibling?.firstChild?.classList?.replace("slds-nubbin_top-left", "slds-nubbin_top-right");
        }
    }
}