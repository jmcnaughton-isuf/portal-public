({
    initialize: function(component, event, helper) {
        console.log('Controller function called');
        var variableURL = component.get('v.url');
        var currentURL = window.location.href;
        
        // currentURL = currentURL.replace(/\/s\/login/g, '');
        currentURL = currentURL.substring(0, currentURL.indexOf('portal') + 6);

        var newUrl = currentURL + variableURL;

        component.set('v.url', newUrl);
    },

    // handleValueInit: function(component, event, helper) {
    //     // This will fire after the parent component sets the values
    //     var variableValue2 = component.get('v.url');
    // },

    // // Update the child component attributes when the URL and platform change
    // setChildAttributes: function(component, event, helper) {
    //     let platform = event.getParam("platform");
    //     if(platform == "Facebook"){
    //         component.set("v.url", event.getParam("url"));

    //     }
    //     var variableValue2 = component.get('v.url');
    // },
})