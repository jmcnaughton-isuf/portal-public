@isTest
public class PORTAL_UTIL_VolunteersTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetUsersToEmail() {
            Map<String, User> returnMap = PORTAL_UTIL_Volunteers.getUsersToEmail(null);
            System.assert(returnMap.isEmpty());

            Map<Object,Object> volunteerBioInfoMap = new Map<Object,Object>{PORTAL_UTIL_Volunteers.VOLUNTEER_FIRST_NAME => 'testFirstName',
                                                                            PORTAL_UTIL_Volunteers.VOLUNTEER_LAST_NAME => 'testLastName',
                                                                            PORTAL_UTIL_Volunteers.VOLUNTEER_EMAIL => 'testEmail@test.com'};

            returnMap = PORTAL_UTIL_Volunteers.getUsersToEmail(new Map<String, Object>{PORTAL_UTIL_Volunteers.VOLUNTEER_BIO_INFO_MAP => volunteerBioInfoMap});
            System.assert(!returnMap.isEmpty());
        }


        public virtual void testGetMergeFieldToValueMap() {
            Map<String, Object> emptyParams = new Map<String, Object>();
            Map<String, Object> validParams = new Map<String, Object>();
            Map<String, String> emptyResult =  new Map<String, String>();
            Map<String, String> validResult =  new Map<String, String>();

            ucinn_portal_Volunteer_Job__c sampleJobRecord = new ucinn_portal_Volunteer_Job__c(Name = 'Testing Job Record');
            insert sampleJobRecord;
            ucinn_portal_Volunteer_Shift__c sampleShiftRecord = new ucinn_portal_Volunteer_Shift__c(Name = 'Testing Shift Record',
                                                                                                    Volunteer_Job__c = sampleJobRecord.Id,
                                                                                                    Status__c = 'Open');
            insert sampleShiftRecord;
            ucinn_portal_Volunteer__c sampleRecord = new ucinn_portal_Volunteer__c(Name = 'Testing Volunteer Record',
                                                                                Volunteer_Shift__c = sampleShiftRecord.Id);
            insert sampleRecord;
            validParams.put('volunteerRecord', sampleRecord);

            Test.startTest();

            try {
                emptyResult = PORTAL_UTIL_Volunteers.getMergeFieldToValueMap(emptyParams);
                System.assert(emptyResult.isEmpty());
            } catch (Exception e) {
                System.debug(e);
            }
            

            try {
                validResult = PORTAL_UTIL_Volunteers.getMergeFieldToValueMap(validParams);
                System.assertEquals(validResult.get('Id'), sampleRecord.Id);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }


        public virtual void testCreateVolunteerEmail() {
            Map<String, Object> validParams = new Map<String, Object>();
            Messaging.SingleEmailMessage result = new Messaging.SingleEmailMessage();
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

            // Email Template record
            System.runAs(new User(Id=UserInfo.getUserId())) {
                EmailTemplate emailTemplateRecord = new EmailTemplate(Name = 'Test Template',
                                                                isActive = true,
                                                                DeveloperName = 'unique_name_TestDeveloperName',
                                                                TemplateType = 'text',
                                                                FolderId = UserInfo.getUserId());
                insert emailTemplateRecord;
                validParams.put('emailTemplateRecord', emailTemplateRecord);
            }
            
            // User record
            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig123@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            User newUser = new User(alias = 'testUser',
                                    email = 'testCommunityUsermig123@test.com',
                                    emailencodingkey='UTF-8',
                                    lastname = 'Batman',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = profileId,
                                    contactId = con.Id,
                                    IsActive = true,
                                    timezonesidkey='America/Los_Angeles',
                                    username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
            insert newUser;
            validParams.put('userRecord', newUser);

            // Volunteer record
            ucinn_portal_Volunteer_Job__c sampleJobRecord = new ucinn_portal_Volunteer_Job__c(Name = 'Testing Job Record');
            insert sampleJobRecord;
            ucinn_portal_Volunteer_Shift__c sampleShiftRecord = new ucinn_portal_Volunteer_Shift__c(Name = 'Testing Shift Record',
                                                                                                    Volunteer_Job__c = sampleJobRecord.Id,
                                                                                                    Status__c = 'Open');
            insert sampleShiftRecord;
            ucinn_portal_Volunteer__c sampleRecord = new ucinn_portal_Volunteer__c(Name = 'Testing Volunteer Record',
                                                                                Volunteer_Shift__c = sampleShiftRecord.Id);
            insert sampleRecord;
            validParams.put('volunteerRecord', sampleRecord);

            // Display Name
            String senderDisplayName = 'Testing Code Coverage';
            validParams.put('senderDisplayName', senderDisplayName);


            Test.startTest();

            try {
                result = PORTAL_UTIL_Volunteers.createVolunteerEmail(validParams);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testGetUsersToEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_VolunteersTestClass().testGetUsersToEmail();
    }

    static testMethod void testGetMergeFieldToValueMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_VolunteersTestClass().testGetMergeFieldToValueMap();
    }

    static testMethod void testCreateVolunteerEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_VolunteersTestClass().testCreateVolunteerEmail();
    }
}