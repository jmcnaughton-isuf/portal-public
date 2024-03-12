@isTest
public without sharing class PORTAL_BATCH_EmailApiZonesTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testBatch() {

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            zone.Is_Display_on_Portal__c = true;
            zone.Footer_Content__c = '<p>Test</p>';
            zone.Social_Media_Order__c = 'Facebook;Twitter';
            zone.Newsletter_Html_Format__c = '<p><p>';
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;

            Set<Id> zoneIds = new Set<Id>();
            zoneIds.add(zone.Id);

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_EmailApiZones(zoneIds));
            Test.stopTest();
        }
    }

    @IsTest
    public static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getEmailApiZonesTestClass().testBatch();
    }
}