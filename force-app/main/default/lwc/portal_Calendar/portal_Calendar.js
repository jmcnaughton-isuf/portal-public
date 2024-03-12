import { LightningElement, track, api } from 'lwc';

export default class Portal_Calendar extends LightningElement {
    @api noResultsMobileMessage = "There are no events this month."
    @api frontEndDataMap = null;

    @api get listingList() {
        return this._listingList
    }

    set listingList(value) {
        this._listingList = value;

        if (this._daysGrid) {
            this.createCalendar();
        }
    }

    @track _daysOfTheWeek = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];
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

    @track _listingList;

    @track _hasEventThisMonth;
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

    connectedCallback() {
        window.addEventListener('resize', () => {this.handleResize();});

        let today = new Date();
        let mm = today.getMonth(); //January is 0!
        let yyyy = today.getFullYear();

        today = new Date(yyyy, mm, 1);

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

        let listingList = this._listingList;

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
        this.createDays(lastDayMonthYear, lastMonthDate-(startingDay - 1), lastMonthDate, listingList, nonVisibleStartDays);
        this.createDays(firstDay, 1, monthLength, listingList, daysList);
        this.createDays(nextDayMonthYear, 1, 7 - nextMonthDay, listingList, nonVisibleEndDays);

        this.createGrid(nonVisibleStartDays, daysList, nonVisibleEndDays);
    }

    createDays(date, startDay, endDay, listingList, daysList) {
        // Get the month and year of the date we are currently at in the calendar.
        let getMonth = date.getMonth() + 1;
        let getFullYear = date.getFullYear();

        for (let i = startDay; i <= endDay; i++) {
            let dayListingList = [];
            let myDate = getFullYear.toString() + '-' + getMonth.toString() + '-' + i.toString();
            let dayMap = {day: i, key: i + Date.now(), date: myDate}

            let dayMapDate = new Date(date.getFullYear(), date.getMonth(), i, 0, 0, 0, 0);
            let currentDate = new Date();
            currentDate.setHours(0,0,0,0);

            dayMap.isToday = (dayMapDate.getTime() == currentDate.getTime());

            dayMap.readableDate = `${this._monthsOfTheYear[getMonth - 1]} ${i}, ${getFullYear}`;

            if (listingList != null) {
                for(let listingIndex = 0;  listingIndex < listingList.length; listingIndex++) {
                    if (listingList[listingIndex].eventActualStartDateTime && listingList[listingIndex].eventActualEndDateTime) {
                        let eventStartDate = new Date(listingList[listingIndex].eventActualStartDateTime);
                        let eventEndDate = new Date(listingList[listingIndex].eventActualEndDateTime);
                        eventStartDate.setHours(0,0,0,0);
                        eventEndDate.setHours(0,0,0,0);

                        // if the calendar day of the month matches the calendar day of the event, then add the subject of the event to the calendar day component
                        let uniqueDayList = [];                        
                        if ((eventStartDate.getTime() <= dayMapDate.getTime()) && (dayMapDate.getTime() <= eventEndDate.getTime())
                            && !uniqueDayList.includes(i)) {

                            dayMap.hasListing = true;
                            dayMap.hasEventThisMonth = this._currentMonthDate.getMonth() === date.getMonth();
                            let dayListingObject = Object.assign({}, listingList[listingIndex]);
                            dayListingList.push(dayListingObject);
                            uniqueDayList.push(i);
                        }

                    }
                } // end for
            }
        
            dayMap.listingList = dayListingList;

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

        this._hasEventThisMonth = false;
        for (let dayIndex = 1; dayIndex <= allDays.length; dayIndex++) {
            daysRow.push(allDays[dayIndex - 1]);
            this._hasEventThisMonth = this._hasEventThisMonth || (allDays[dayIndex - 1].hasEventThisMonth === true);

            if (dayIndex % 7 === 0) {
                daysGrid.push(daysRow);
                daysRow = [];
            }
        }

        this._daysGrid = daysGrid;
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

        this.createCalendar();
    }

    handleShowMoreWrapper = (event) => {
        this.handleShowMore(event.target);
    }

    handleShowMore = (anchor) => {
        let popoverClasses = anchor.nextSibling.classList;
        popoverClasses.toggle('show');
        anchor.setAttribute('aria-haspopup', popoverClasses.contains('show'));
        if (anchor.parentNode?.parentNode?.nextSibling === null){
            anchor.nextSibling?.firstChild?.classList?.replace("slds-nubbin_top-left", "slds-nubbin_top-right");
        }
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
}