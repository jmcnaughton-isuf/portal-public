import { LightningElement, api, track } from 'lwc';
export default class Portal_CountdownTimer extends LightningElement {
    @api handleExpiration = () => {};

    @api isHideHeaderText = false;

    @api get sessionExpirationDate() {
        return this._sessionExpirationDate;
    }

    set sessionExpirationDate(expirationDateString) {
        this._sessionExpirationDate = new Date(expirationDateString);
        clearInterval(this.timer);
        this.startTimer();
    }

    get headerText() {
        if (!this.isHideHeaderText) {
            return 'Time to Expiration: '
        }

        return '';
    }

    @track timeToExpiration = '';
    _sessionExpirationDate = new Date();
    timer = undefined;

    startTimer() {
        let endTime = this._sessionExpirationDate.getTime();

        this.timer = setInterval(() => {
            let currentTime = new Date().getTime();

            let timeDifference = endTime - currentTime;

            if (timeDifference < 0) {  // tickets have expired
                clearInterval(this.timer);
                this.timeToExpiration = 'Tickets have expired!';
                this.handleExpiration();
                this.dispatchEvent(new CustomEvent('eventexpired'));
            } else {
                // Time calculations for hours, minutes and seconds
                let hours = Math.floor((timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                let minutes = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));
                let seconds = Math.floor((timeDifference % (1000 * 60)) / 1000);

                this.timeToExpiration = this.padDigits(hours) + ': ' + this.padDigits(minutes) + ': ' + this.padDigits(seconds);
            }
        }, 100);
    }

    padDigits(number) {
        return (number < 10 ? '0' : '') + number;
    }
}