@isTest
global with sharing class PORTAL_TRIG_ZoneMembershipHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testUpdateContactMembership() {
            ucinn_ascendv2__Trigger_Handler__c zoneMemberHandler = new ucinn_ascendv2__Trigger_Handler__c();
            zoneMemberHandler.Name = 'PORTAL_TRIG_ZoneMembershipHandler';
            zoneMemberHandler.ucinn_ascendv2__Class__c = 'PORTAL_TRIG_ZoneMembershipHandler';
            zoneMemberHandler.ucinn_ascendv2__Is_Active__c = true;
            zoneMemberHandler.ucinn_ascendv2__Is_Asynchronous__c = false;
            zoneMemberHandler.ucinn_ascendv2__Is_User_Managed__c = false;
            zoneMemberHandler.ucinn_ascendv2__Load_Order__c = 1.0;
            zoneMemberHandler.ucinn_ascendv2__Object__c = 'ucinn_portal_Zone_Membership__c';
            zoneMemberHandler.ucinn_ascendv2__Trigger_Action__c = 'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete';
            zoneMemberHandler = (ucinn_ascendv2__Trigger_Handler__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneMemberHandler});
            insert zoneMemberHandler;

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Is_Display_On_Portal__c = true;
            zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;

            Contact con = new Contact(Email = 'testEmail@test.com.invalid', FirstName = 'test', LastName = 'test');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            ucinn_portal_Zone_Membership__c membership = new ucinn_portal_Zone_Membership__c(
                Is_On_Newsletter__c = true,
                Is_Show_On_Directory__c = true,
                Zone__c = zone.Id,
                Status__c = 'Active',
                Constituent__c = con.Id
            );
            //not much to validate since it acts differently depending on email api
            membership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => membership});
            insert membership;
            membership.Status__c = 'Inactive';
            update membership;
            delete membership;
            undelete membership;

        }
    }

    @isTest
    global static void testUpdateContactMembership() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ZoneMembershipHandlerTestClass().testUpdateContactMembership();
    }
}