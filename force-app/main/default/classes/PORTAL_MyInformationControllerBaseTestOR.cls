public class PORTAL_MyInformationControllerBaseTestOR extends PORTAL_MyInformationControllerBaseTest.TestClass{
	
    public override void createPhones() {
        
        List<ucinn_ascendv2__Phone__c> phones = new List<ucinn_ascendv2__Phone__c>();
        
        ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
        homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
        homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
        homePhone.ucinn_ascendv2__Is_Preferred__c = true;
        homePhone.ucinn_ascendv2__Status__c = 'Current';
        homePhone.ucinn_ascendv2__Contact__c = con.Id;
        homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
        homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
        homePhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => homePhone});
        phones.add(homePhone);
        
        ucinn_ascendv2__Phone__c inactivePhone = new ucinn_ascendv2__Phone__c();
        inactivePhone.ucinn_ascendv2__Phone_Number__c = '5555555555';
        inactivePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
        inactivePhone.ucinn_ascendv2__Is_Preferred__c = false;
        inactivePhone.ucinn_ascendv2__Status__c = 'Inactive';
        inactivePhone.ucinn_ascendv2__Contact__c = con.Id;
        inactivePhone.ucinn_portal_Is_Display_On_Portal__c = true;
        inactivePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
        inactivePhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => inactivePhone});
        phones.add(inactivePhone);
        
        ucinn_ascendv2__Phone__c mobilePhone = new ucinn_ascendv2__Phone__c();
        mobilePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
        mobilePhone.ucinn_ascendv2__Type__c = 'Home - Landline';
        mobilePhone.ucinn_ascendv2__Is_Preferred__c = false;
        mobilePhone.ucinn_ascendv2__Status__c = 'Current';
        mobilePhone.ucinn_ascendv2__Contact__c = con.Id;
        mobilePhone.ucinn_portal_Is_Display_On_Portal__c = true;
        mobilePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
        mobilePhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => mobilePhone});
        phones.add(mobilePhone);
        
        ucinn_ascendv2__Phone__c businessPhone = new ucinn_ascendv2__Phone__c();
        businessPhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
        businessPhone.ucinn_ascendv2__Type__c = 'Business - Cell';
        businessPhone.ucinn_ascendv2__Is_Preferred__c = false;
        businessPhone.ucinn_ascendv2__Status__c = 'Current';
        businessPhone.ucinn_portal_Is_Display_On_Portal__c = true;
        businessPhone.ucinn_ascendv2__Contact__c = con.Id;
        businessPhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
        businessPhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => businessPhone});
        phones.add(businessPhone);
        
        insert phones;
        
        
    }

}