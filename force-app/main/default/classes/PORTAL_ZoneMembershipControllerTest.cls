@isTest
public without sharing class PORTAL_ZoneMembershipControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetZoneCustomMetadata() {
            try {
                PORTAL_ZoneMembershipController.SERVER_getZoneCustomMetadata();
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_ZoneMembershipController.SERVER_getZoneCustomMetadata();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_ZoneMembershipController.SERVER_getZoneCustomMetadata();
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetAffinityGroups() {
            try{
                PORTAL_ZoneMembershipController.SERVER_getAffinityGroups(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_ZoneMembershipController.SERVER_getAffinityGroups(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_ZoneMembershipController.SERVER_getAffinityGroups(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testSavesZoneMemberships() {
            try {
                PORTAL_ZoneMembershipController.SERVER_savesZoneMemberships(null);
            } catch(Exception e) {

            }


            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_ZoneMembershipController.SERVER_savesZoneMemberships(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_ZoneMembershipController.SERVER_savesZoneMemberships(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testUnsubscribeFromNewsletter() {
            try {
                PORTAL_ZoneMembershipController.SERVER_unsubscribeFromNewsletter(null);
            } catch(Exception e) {

            }


            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_ZoneMembershipController.SERVER_unsubscribeFromNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_ZoneMembershipController.SERVER_unsubscribeFromNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

    }


    static testMethod void testGetZoneCustomMetadata() {
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipControllerTestClass().testGetZoneCustomMetadata();
    }

    static testMethod void testGetAffinityGroups() {
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipControllerTestClass().testGetAffinityGroups();
    }

    static testMethod void testSavesZoneMemberships() {
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipControllerTestClass().testSavesZoneMemberships();
    }

    static testMethod void testUnsubscribeFromNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipControllerTestClass().testUnsubscribeFromNewsletter();
    }


}