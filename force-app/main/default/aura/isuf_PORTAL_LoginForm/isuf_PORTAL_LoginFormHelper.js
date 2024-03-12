({
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },

    qsToEventMap2: {
        'expid'  : 'e.c:setExpId'
    },

    handleLogin: function (component, event, helpler) {
        // recaptcha related variables
        var isRecaptchaEnabled = component.get("v.isEnableRecaptcha");
        var recaptchaCmp = component.find("recaptcha");
        var recaptchaToken = '';

        if (isRecaptchaEnabled && recaptchaCmp && recaptchaCmp.isCurrentRecaptchaOptionValid()) {
            recaptchaCmp.handleRecaptchaRequest();

            if (recaptchaCmp.getRecaptchaVersion().toUpperCase() == 'reCAPTCHA V3'.toUpperCase()) {
                return;
            }

            if (!recaptchaCmp.isRecaptchaVerified()) {
                component.set("v.errorMessage",'Please verify with reCAPTCHA before submitting.');
                component.set("v.showError",true);
                return;
            }

            recaptchaToken = recaptchaCmp.getToken();
        }
        
        this.handleLoginCallout(component, recaptchaToken);
    },

    handleLoginWithRecaptchaV3: function (component, event, helper) {
        this.handleLoginCallout(component, event.getParam('token'));
    },

    handleLoginCallout: function (component, recaptchaToken) {
        // probably add to username here
        var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
        var action = component.get("c.login");
        var startUrl = component.get("v.startUrl");
        var recaptchaCmp = component.find("recaptcha");

        startUrl = decodeURIComponent(startUrl);

        action.setParams({username:username, password:password, startUrl:startUrl, recaptchaToken: recaptchaToken});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set("v.errorMessage",rtnValue);
                component.set("v.showError",true);

                if (recaptchaCmp) {
                    recaptchaCmp.resetRecaptchaForLogin();
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleCloseAlert : function(component, event, helper){
        component.set("v.showError", false);
    },

    getIsRecaptchaEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsRecaptchaEnabled");
        action.setParams({classFunctionName: 'PORTAL_LoginFormControllerOR.login'})
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isEnableRecaptcha',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    getIsUsernamePasswordEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsUsernamePasswordEnabled");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isUsernamePasswordEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    getIsSelfRegistrationEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsSelfRegistrationEnabled");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isSelfRegistrationEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    getCommunityForgotPasswordUrl : function (component, event, helpler) {
        var action = component.get("c.getForgotPasswordUrl");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communityForgotPasswordUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    getCommunitySelfRegisterUrl : function (component, event, helpler) {
        var action = component.get("c.getSelfRegistrationUrl");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communitySelfRegisterUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    setBrandingCookie: function (component, event, helpler) {
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    }
})