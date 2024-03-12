/**
 * Reduces one or more LDS errors into a string[] of error messages.
 * @param {FetchResponse|FetchResponse[]} errors
 * @return {String[]} Error messages
 */
 export function reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    return (
        errors
            // Remove null/undefined items
            .filter((error) => !!error)
            // Extract an error message
            .map((error) => {
                // UI API read errors
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                // UI API DML, Apex and network errors
                else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                }
                // JS errors
                else if (typeof error.message === 'string') {
                    return error.message;
                }
                // Unknown error shape so try HTTP status text
                return error.statusText;
            })
            // Flatten
            .reduce((prev, curr) => prev.concat(curr), [])
            // Remove empty strings
            .filter((message) => !!message)
    );
}


/**
 * Redirects the page using the controller's response Record ID
 * and base URL.
 *
 * @param {Object} controllerResponse : The Apex controller's response.
 */
export function redirectToNewRecordId(controllerResponse) {
    let baseUrl = controllerResponse.baseUrl;
    let newRecordId = controllerResponse.newRecordId;
    let urlString = baseUrl + '/lightning/r/ucinn_portal_Listing__c/' + newRecordId + '/view';
    window.location.href = urlString;
}


/**
 * Used to display error alerts.
 *
 * @param {Exception} error
 */
export function displayErrorAlert(error) {
    console.log('portal_Util_Listing.js - found an error: ', error);
    if (!error) {
        alert(error);
    } else if (error.message) {
        displayDefaultOrCustomErrorAlert(error.body.message);
    } else if (error.body.message) {
        displayDefaultOrCustomErrorAlert(error.body.message);
    } else if (error.body.pageErrors.length > 0) {
        displayDefaultOrCustomErrorAlert(error.body.pageErrors[0].message);
    }
}

function displayDefaultOrCustomErrorAlert(message) {
    try {
        alert(JSON.parse(message).message);
    } catch(e) {
        alert(message);
    }
}


export class ConsoleDebug {
    debugOn;

    constructor() {
        this.debugOn = true;
    }

    log() {
        if (this.debugOn) {
            for (let i = 0; i < arguments.length; i++ ) {
                console.log(arguments[i]);
            }
        }
    }

    turnOff() {
        this.debugOn = false;
    }
}