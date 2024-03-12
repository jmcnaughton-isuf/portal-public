@isTest
public class PORTAL_LWC_MembershipControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetMembershipRecords() {
            PORTAL_LWC_MembershipController.SERVER_getMembershipRecords(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MembershipController.SERVER_getMembershipRecords(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MembershipController.SERVER_getMembershipRecords(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testGetMembershipContactInformation() {

            try {
                PORTAL_LWC_MembershipController.SERVER_getMembershipContactInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MembershipController.SERVER_getMembershipContactInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MembershipController.SERVER_getMembershipContactInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testSaveMembershipRecords() {
            PORTAL_LWC_MembershipController.SERVER_saveMembershipRecords(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MembershipController.SERVER_saveMembershipRecords(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MembershipController.SERVER_saveMembershipRecords(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }
    }

    static testMethod void testGetMembershipRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMembershipControllerTestClass().testGetMembershipRecords();
    }

    static testMethod void testGetMembershipContactInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMembershipControllerTestClass().testGetMembershipContactInformation();
    }

    static testMethod void testSaveMembershipRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMembershipControllerTestClass().testSaveMembershipRecords();
    }

}