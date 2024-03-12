({
    handleForgotPassword: function (component, event, helpler) {
        helpler.handleForgotPassword(component, event, helpler);
    },
    onKeyUp: function(component, event, helpler){
    //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helpler.handleForgotPassword(component, event, helpler);
        }
    },

    setExpId: function (component, event, helper) {
        var expId = event.getParam('expid');
        if (expId) {
            component.set("v.expid", expId);
        }
        helper.setBrandingCookie(component, event, helper);
    },

    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();
    },
    
    navigateToLogin : function(component, event, helper) {
        // Get the current URL
        var currentUrl = window.location.href;

        // Extract the base URL without the path
        var newUrl = currentUrl.replace('ForgotPassword', '');

        // Use the force:navigateToURL event to navigate
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": newUrl
        });
        urlEvent.fire();
    }
})