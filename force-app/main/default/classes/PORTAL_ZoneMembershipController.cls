/** ----------------------------------- DEPRECATED  -----------------------------------------------------------*/

global without sharing class PORTAL_ZoneMembershipController {

    /**
    * Queries for all portal my memberships custom metadata records and formats them into a list.
    * If constituent is logged in will also populate if newsletter preferences should be disabled.
    *
    * @return                               List of map formatted zone memberships records
    * @since                                1.0
    */
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> SERVER_getZoneCustomMetadata() {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();

            return null;
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }

    /**
     * Query for All the zones that exist as well as all zone memebrships associated with the constituent logged in.
     *
     * @param   recordName                  record name for zones you are querying for
     * @return                              List of all zones and zone memberships assoicated with the logged in constituent
     * @since                               1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getAffinityGroups(List<String> recordName) {


        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();

            return null;
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }

    /**
    * Takes user input from the portal and updates zone memberships accordingly.
    *
    * @param    zoneMembershipData          zone membership updates from the portal
    * @return                               Sucess message to display on the portal
    * @since                                1.0
    */
    @AuraEnabled
    public static String SERVER_savesZoneMemberships(List<Map<String, Object>> zoneMembershipData) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();

            return null;
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }

    /**
    * method that unsubscribes a contact from all newsletters
    * we unsubcribe from everything instead of per zone to satisfy CAN-SPAM act
    *
    * @param id:                                the contact id for the person unsubscribing, prioritized over email if both available
    * @param contactEmail:                      The email address for the person unsubscribing, used if id is not available
    * @author:                                  Sam Longo
    * @since:                                   1.0
    */
    @AuraEnabled
    public static void SERVER_unsubscribeFromNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();
            baseController.unsubscribeFromNewsletter(params);
        } catch(AuraHandledException e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => 'AES_Key', PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => 'AES_Key', PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Could not process the action. Please contact an administrator.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}