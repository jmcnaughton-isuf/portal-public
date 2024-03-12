import { LightningElement, api } from 'lwc';
import SERVER_timeTrack from '@salesforce/apex/PORTAL_ActionOnContentController.SERVER_timeTrack';
import SERVER_timeTrackByName from '@salesforce/apex/PORTAL_ActionOnContentController.SERVER_timeTrackByName';
export default class Portal_TimeTracker extends LightningElement {

    @api recordId;
    @api recordName;
    _startTime;
    _ipAddress;

    connectedCallback() {
        const Http = new XMLHttpRequest();
        const url='https://api.ipify.org/';
        Http.open("GET", url);
        Http.send();
        Http.onreadystatechange=(e)=>{
            if (Http.readyState == 4) {
                let ipAddress = Http.responseText;
                this._ipAddress = ipAddress;
            }
        }
        this._startTime = Date.now();
        window.addEventListener('beforeunload', this.trackTime.bind(this));
    }

    trackTime() {
        let totalTime = Date.now() - this._startTime;
        if (this.recordName) {
            const params = {params:{timeDifference: totalTime, contentName: this.recordName, ipAddress:this._ipAddress}};
            SERVER_timeTrackByName(params).then(res => {

            }).catch(console.error);
        } else if (this.recordId) {
            const params = {params:{timeDifference: totalTime, contentId: this.recordId, ipAddress:this._ipAddress}};
            SERVER_timeTrack(params).then(res => {

            }).catch(console.error);
        }
    }
}