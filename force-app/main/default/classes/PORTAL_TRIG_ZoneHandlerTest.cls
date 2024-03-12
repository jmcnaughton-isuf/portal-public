@isTest
global with sharing class PORTAL_TRIG_ZoneHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testUpdateMailingList() {
            ucinn_ascendv2__Trigger_Handler__c zoneHandler = new ucinn_ascendv2__Trigger_Handler__c();
            zoneHandler.Name = 'PORTAL_TRIG_ZoneHandler';
            zoneHandler.ucinn_ascendv2__Class__c = 'PORTAL_TRIG_ZoneHandler';
            zoneHandler.ucinn_ascendv2__Is_Active__c = true;
            zoneHandler.ucinn_ascendv2__Is_Asynchronous__c = false;
            zoneHandler.ucinn_ascendv2__Is_User_Managed__c = false;
            zoneHandler.ucinn_ascendv2__Load_Order__c = 1.0;
            zoneHandler.ucinn_ascendv2__Object__c = 'ucinn_portal_Zone__c';
            zoneHandler.ucinn_ascendv2__Trigger_Action__c = 'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete';
            zoneHandler = (ucinn_ascendv2__Trigger_Handler__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneHandler});
            insert zoneHandler;

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Is_Display_On_Portal__c = true;
            zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            //not much to validate since it could have different functionality depending on the email api
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;
            delete zone;
            undelete zone;
        }

        public virtual void testRun() {
            List<SObject> newList = new List<SObject>();
            List<SObject> oldList = new List<SObject>();

            ucinn_portal_Zone__c zoneRecord = new ucinn_portal_Zone__c(Name = 'Test', City__c = 'Irvine', State__c = 'CA', Country__c = 'USA', Postal_Code__c = '92602', Search_Radius__c = 50);
            newList.add(zoneRecord);
            insert zoneRecord;
            new PORTAL_TRIG_ZoneHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert, ucinn_portal_Zone__c.getSObjectType().getDescribe());

            ucinn_portal_Zone__c zoneRecordClone = zoneRecord.clone(true, true, false, false);
            zoneRecordClone.Name = 'Test New';
            newList = new List<SObject>{zoneRecordClone};
            oldList = new List<SObject>{zoneRecord};
            update zoneRecordClone;
            new PORTAL_TRIG_ZoneHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate, ucinn_portal_Zone__c.getSObjectType().getDescribe());
        }
    }

    @isTest
    global static void testUpdateMailingList() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ZoneHandlerTestClass().testUpdateMailingList();
    }

    @isTest
    global static void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ZoneHandlerTestClass().testRun();
    }
}