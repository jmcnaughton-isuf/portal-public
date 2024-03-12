export class DateFormatter {
    FULL_MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    convertStringToDate(isoDateString) {
        if (!isoDateString) {
            return null;
        }

        let resultDate = new Date();

        //YYYY-MM-DD HH:MM:SS
        let dateTimeParts = isoDateString.split(' ');

        let dateParts = dateTimeParts[0].split('-');
        resultDate.setFullYear(dateParts[0]);
        resultDate.setMonth(dateParts[1] - 1);
        resultDate.setDate(dateParts[2]);

        let timeParts = dateTimeParts[1].split(':');
        resultDate.setHours(timeParts[0]);
        resultDate.setMinutes(timeParts[1]);
        resultDate.setSeconds(timeParts[2]);

        return resultDate;
    }

    getFormattedDate(date) {
        return date.toLocaleDateString('en-us', { day:"numeric", year:"numeric", month:"long"})
    }

    getFormattedTime(date) {
        return date.toLocaleString('en-us', {hour12: true, hour:"numeric", minute: "numeric"});
    }

    getFormattedDateTime(date, dateTimeSeperator) {
        let resultString = this.getFormattedDate(date);

        if (!dateTimeSeperator) {
            dateTimeSeperator = ' '
        }
        resultString = resultString + dateTimeSeperator + this.getFormattedTime(date);

        return resultString;
    }

    getFormattedDateRange(startDate, endDate, dateTimeSeperator) {
        let resultString = '';

        if (!endDate) {
            return this.getFormattedDateTime(startDate, dateTimeSeperator);
        }

        if (!startDate || startDate == endDate) {
            return this.getFormattedDateTime(endDate, dateTimeSeperator);
        }

        if (this.getFormattedDate(startDate) === this.getFormattedDate(endDate)) {
            resultString = resultString + this.getFormattedDate(startDate);

            if (!dateTimeSeperator) {
                dateTimeSeperator = ' ';
            }

            resultString = resultString + dateTimeSeperator + this.getFormattedTime(startDate) + ' - ' + this.getFormattedTime(endDate);

            return resultString;
        }

        return this.getFormattedDateTime(startDate, dateTimeSeperator) + ' - ' + this.getFormattedDateTime(endDate, dateTimeSeperator);
    }

    getTimeZoneInitials(longTimeZone) {
        let resultString = '';
        if (!longTimeZone) {
            return resultString;
        }

        // expected format is (GMT–XX:YY) timeZone [(subregion)] (region/subregion)
        // this regex makes a capture group for " timeZone " i.e. the characters not enclosed in parentheses
        const timeZonePattern = /^\([^)]*\)(?<timeZone>[^(]*)\(.*\)$/
        let timeZone = longTimeZone.match(timeZonePattern)?.groups?.timeZone;

        if (!timeZone) {
            return longTimeZone;
        }

        for (let eachPart of timeZone.split(' ')) {
            if (eachPart) {
                resultString = resultString + eachPart[0];
            }
        }

        return resultString;
    }
}