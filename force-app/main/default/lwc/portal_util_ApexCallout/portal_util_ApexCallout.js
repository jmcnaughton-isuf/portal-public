import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export function callApexFunction(thisRef, func, params, callback, errorCallback) {
    return func({params: params}).then((data) => {
        return callback(data)
    }).catch(function(e){
        let errorMap = {}
        try {
            errorMap = JSON.parse(e.body.message);
            console.log(errorMap.error);
        } catch (e2) {
            console.log(e);
            errorMap.message = 'There was an issue processing your request. Please contact an administrator.';
        }

        const event = new ShowToastEvent({
            title: 'Error!',
            message: errorMap.message,
            variant:"error",
            mode:"sticky"
        });

        thisRef.dispatchEvent(event);
        return errorCallback(e);
    });
}