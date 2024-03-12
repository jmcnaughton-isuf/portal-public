@isTest
public class PORTAL_UTIL_DataCreationTest {
    public virtual class TestClass extends PORTAL_TestClassBase {

        public virtual void testCreateAllData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createAllData();
            Test.stopTest();
        }

        public virtual void testCreateAscendPortalData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createAscendPortalData();
            Test.stopTest();
        }

        public virtual void testCreateMyInformationAndDirectoryData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createMyInformationAndDirectoryData();
            Test.stopTest();
        }

        public virtual void testCreateStaticContentManagementData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createStaticContentManagementData();
            Test.stopTest();
        }

        public virtual void testCreateEventsData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createEventsData();
            Test.stopTest();
        }

        public virtual void testCreatePortalOnlyEventsData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createPortalOnlyEventsData();
            Test.stopTest();
        }

        public virtual void testCreateGivingSocietyHonorRollData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createGivingSocietyHonorRollData();
            Test.stopTest();
        }

        public virtual void testCreateOnlineGivingData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createOnlineGivingAndGivingHistoryData();
            Test.stopTest();
        }

        public virtual void testCreateMembershipData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createMembershipData();
            Test.stopTest();
        }

        public virtual void testNewsletterHTMLTemplate() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createNewsletterHtmlTemplate();
            Test.stopTest();
        }

        public virtual void testCreateDefaultZone() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createDefaultZone();
            Test.stopTest();
        }

        public virtual void testCreateZoneDataWithConstituent() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createZoneDataWithConstituent();
            Test.stopTest();
        }
        
        public virtual void testCreateZoneDataWithoutConstituent() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createZoneDataWithoutConstituent();
            Test.stopTest();
        }

        public virtual void testCreateVolunteerDataWithConstituent() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createVolunteerDataWithConstituent();
            Test.stopTest();
        }

        public virtual void testCreateVolunteerDataWithoutConstituent() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createVolunteerDataWithoutConstituent();
            Test.stopTest();
        }
        
        public virtual void testCreateJobsBoardData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createJobsBoardData();
            Test.stopTest();
        }

        public virtual void testCreateDownloadableContentData() {
            Test.startTest();
            PORTAL_UTIL_DataCreation.createDownloadableContentData();
            Test.stopTest();
        }
    }

    static testMethod void testCreateAllData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateAllData();
    }

    static testMethod void testCreateAscendPortalData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateAscendPortalData();
    }

    static testMethod void testCreateMyInformationAndDirectoryData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateMyInformationAndDirectoryData();
    }

    static testMethod void testCreateStaticContentManagementData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateStaticContentManagementData();
    }

    static testMethod void testCreateEventsData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateEventsData();
    }

    static testMethod void testCreatePortalOnlyEventsData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreatePortalOnlyEventsData();
    }

    static testMethod void testCreateGivingSocietyHonorRollData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateGivingSocietyHonorRollData();
    }

    static testMethod void testCreateOnlineGivingData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateOnlineGivingData();
    }

    static testMethod void testCreateMembershipData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateMembershipData();
    }

    static testMethod void testCreateNewsletterTemplate(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testNewsletterHTMLTemplate();
    }

    static testMethod void testCreateDefaultAllZone(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateDefaultZone();
    }

    static testMethod void testCreateZoneDataWithConstituent() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateZoneDataWithConstituent();
    }

    static testMethod void testCreateZoneDataWithoutConstituent() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateZoneDataWithoutConstituent();
    }

    static testMethod void testCreateVolunteerDataWithConstituent() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateVolunteerDataWithConstituent();
    }

    static testMethod void testCreateVolunteerDataWithoutConstituent() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateVolunteerDataWithoutConstituent();
    }

    static testMethod void testCreateJobsBoardData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateJobsBoardData();
    }

    static testMethod void testCreateDownloadableContentData(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DataCreationTestClass().testCreateDownloadableContentData();
    }
}