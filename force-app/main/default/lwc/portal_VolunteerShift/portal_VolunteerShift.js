import { LightningElement, api } from 'lwc';

export default class Portal_VolunteerShift extends LightningElement {
    @api frontEndDataMap;
    @api shift;
    @api handleSignUp = () => {};
    
    dayAbbreviationMap = {'Mon': 'Monday', 'Tue': 'Tuesday', 'Wed': 'Wednesday', 'Thu': 'Thursday',
                          'Fri': 'Friday', 'Sat': 'Saturday', 'Sun': 'Sunday'};
    monthAbbreviationMap = {'Jan': 'January', 'Feb': 'February', 'Mar': 'March', 'Apr': 'April',
                            'May': 'May', 'Jun': 'June', 'Jul': 'July', 'Aug': 'August',
                            'Sep': 'September', 'Oct': 'October', 'Nov': 'November', 'Dec': 'December'};

    get isReady() {
        return this.frontEndDataMap && this.shift;
    }

    get startDateTime() {
        return Date.parse(this.shift.volunteerJobShiftStartDateTime);
    }

    get endDateTime() {
        return Date.parse(this.shift.volunteerJobShiftEndDateTime);
    }

    get showDateRange() {
        return this.frontEndDataMap?.volunteerJobShiftStartDateTime?.display || this.frontEndDataMap?.volunteerJobShiftEndDateTime?.display
    }

    get shiftLabel() {
        let shiftDate = new Date(this.shift.volunteerJobShiftStartDateTime).toDateString().split(' ');
        shiftDate[0] = this.dayAbbreviationMap[shiftDate[0]] + ',';
        shiftDate[1] = this.monthAbbreviationMap[shiftDate[1]];
        shiftDate[2] += ',';
        return this.shift.volunteerJobShiftName + ': ' + shiftDate.join(' ');
    }

    get availablePositions() {
        if (this.shift.volunteerShiftMaxNumOfVolunteers !== undefined) {
            return this.shift.volunteerShiftMaxNumOfVolunteers - this.shift.volunteerShiftTotalNumOfVolunteers;
        }
        return true;
    }

    get availablePositionsString() {
        let available = this.availablePositions;
        let space = available === true ? '' : ' ';
        let plural = available !== 1 ? 's' : '';

        let number = available;
        if (number === true) {
            number = '';
        }
        else if (number <= 0) {
            number = 'No'
        }

        return `${number}${space}Position${plural}`;
    }

    handleVolunteerShiftSignUp(event) {
        this.handleSignUp(this.shift, '');
    }

    handleModifyApplication(event) {
        this.handleSignUp(this.shift, 'modify');
    }

    handleGuestSignUp(event) {
        this.handleSignUp(this.shift, 'guest');
    }

    toggleAccordion = (event) => {
        let parent = event.currentTarget.parentNode;
        parent.classList.toggle('active');
    }
}