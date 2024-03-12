({
    doInit : function (component, event, helper) {
        let action = component.get('c.SERVER_getContentPageCSSClasses');
        let url = window.location.pathname;

        action.setParams({
            "params": {
                pageUrl: url
             },
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            let result = response.getReturnValue();
            let currentBodyClass = component.get("v.bodyClass");
            
            if (state === 'SUCCESS') {
                if (result) {
                    component.set("v.bodyClass", [currentBodyClass, result].join(" "));
                }
            } else {
                console.log(response.getError()[0]);
            }
        });
        
        $A.enqueueAction(action);
    },

    myAction : function(component, event, helper) {

    }
})