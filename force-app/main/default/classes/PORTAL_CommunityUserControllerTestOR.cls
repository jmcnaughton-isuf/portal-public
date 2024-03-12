public class PORTAL_CommunityUserControllerTestOR extends PORTAL_CommunityUserControllerTest.TestClass{
	public override void testCreateUserWithInterim() {
        UserRole ur = new UserRole(Name = 'Admin');
        insert ur;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User portalAccountOwner = new User(
            UserRoleId = ur.Id,
            ProfileId = p.Id,
            Username = System.now().millisecond() + 'testUC1@testUC1.com',
            Alias = 'bwyane',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
        Database.insert(portalAccountOwner);
        
        System.runAs(portalAccountOwner) {
            Account acct = new Account();
            acct.Name = 'Test Account';
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
            
            Contact cont = new Contact();
            cont.FirstName = 'Test';
            cont.LastName = 'Test';
            cont.AccountId = acct.Id;
            cont.Email = 'demo@ucinnovation.com';
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;
            
            ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
            interim.ucinn_ascendv2__First_Name__c = 'Test';
            interim.ucinn_ascendv2__Last_Name__c = 'Test';
            interim.ucinn_ascendv2__Status__c = 'Completed';
            interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
            interim.ucinn_ascendv2__Contact__c = cont.Id;
            interim.ucinn_ascendv2__Source_File__c = 'Alumni Portal';
            interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
            interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
            insert interim;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('interimId', interim.Id);
            PORTAL_CommunityUserController.SERVER_createUserFromInterim(params);
            
            List<User> users = [SELECT Id FROM User];
            System.debug(users);
            
        }
    }
}