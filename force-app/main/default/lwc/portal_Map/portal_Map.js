import { api, LightningElement, track } from 'lwc';

export default class Portal_Map extends LightningElement {
    @api cityApiName;
    @api stateApiName;
    @api titleApiName = 'Name';
    @api zoomLevel;
    @api markerTitle;
    @api hideMarkerList;

    @track mapMarkers = [];
    @track formattedCenter = {};

    @api
    get mapData() {

    }

    set mapData(value) {
        this.formatMapMarkers(value);
    }

    @api
    get center() {

    }

    set center(value) {
        if (value) {
            try {
                this.formattedCenter = JSON.parse(value);
            }
            catch (error) {

            }

        }
    }

    formatMapMarkers(listOfData) {
        let tempMapMarkers = [];

        for (let currentMarker of listOfData) {
            let currentMapMarkerObject = {};
            let city = currentMarker[this.cityApiName];
            let state = currentMarker[this.stateApiName];

            if (city && state) {
                currentMapMarkerObject['location'] = {
                    'City' : city,
                    'State' : state
                };
            } else if (state) {
                currentMapMarkerObject['location'] = {
                    'State' : state
                };
            } else {
                continue;
            }

            if (currentMarker[this.titleApiName]) {
                currentMapMarkerObject["title"] = currentMarker[this.titleApiName];
            }

            tempMapMarkers.push(currentMapMarkerObject);
        }


        this.mapMarkers = tempMapMarkers;
    }
}