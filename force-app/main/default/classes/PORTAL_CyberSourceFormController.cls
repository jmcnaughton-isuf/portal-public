public inherited sharing class PORTAL_CyberSourceFormController {
    public static final String TERMS_AND_CONDITIONS_DEVELOPER_NAME = 'Cybersource_ACH_Terms_and_Conditions_URL';

    /**
     * sends a request to cybersource to authenticate and return a temporary JWT token
     * to be used by the front end to encrypt sensitive details
     * before they are passed back to the backend then cybersource
     */
    public String captureContext {
        get { //FUTURE TODO: call this through the joined capture context function in paymenthub, move call to initialize lwc instead of VF page?

            PORTAL_CybersourcePaymentGateway controller = (PORTAL_CybersourcePaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                PORTAL_Utils.CLASS_TYPE => PORTAL_CybersourcePaymentGateway.Class});
            return controller.getCaptureContext();
        }
        set;
    }

    /**
     * Get the Terms and Conditions URL for the Cybersource ACH form from Portal Organization Settings
     * 
     * @author Jacob Huang
     * @since 1.5
     * 
     * @return URL from Portal Organization Setting 
     */
    public String termsAndConditionsUrl{
        get {
            return Test.isRunningTest() ? '/s/testurl' : PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => TERMS_AND_CONDITIONS_DEVELOPER_NAME});
        }
        set;
    }

    public String lexOrigin {
        get {
            return PORTAL_CommunityUtils.constructOrigin();
        }
        set;
    }

}