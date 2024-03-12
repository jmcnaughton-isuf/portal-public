({
    doInit : function (component, event, helper) {
        let action = component.get('c.SERVER_getContentModuleMetadata');
        let url = window.location.pathname.split('/').slice(0, 3).join('/');

        action.setParams({
            "params": {pageUrl: url},
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            let result = response.getReturnValue();

            if (state==='SUCCESS') {
                if (result != null) {
                    component.set('v.bannerUrl', result.Banner_URL__c);
                    component.set('v.pageName', result.Name);
                }
            } else {
                console.log(response.getError()[0]);
            }
        });

        $A.enqueueAction(action);
    },
})