@isTest
public class PORTAL_ProfilePictureControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public ContentVersion cv;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            cv = new ContentVersion(Title = 'Test',
                                                   PathOnClient = 'Test.jpg',
                                                   VersionData = blob.valueOf('Test CV data'),
                                                   IsMajorVersion = true);
            cv = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cv});
            insert cv;

            con = new Contact(LastName = 'TestContact',
                                      ucinn_ascendv2__Picture_Record_ID__c = String.valueOf(cv.Id));
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            ContentDocumentLink contentLink = new ContentDocumentLink();
            contentLink.LinkedEntityId = con.Id;
            contentLink.ShareType = 'V';
            contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion Where Id =: cv.Id].ContentDocumentId;
            contentLink = (ContentDocumentLink)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentLink});
            insert contentLink;


        }

        public virtual void testGetProfilePictureFromConNoPic() {
            Contact cont = new Contact(LastName = 'TestContact',
                               ucinn_ascendv2__Picture_Record_ID__c = null);
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;
            PORTAL_ProfilePictureController.getProfilePictureFromConstituent(cont.Id);
        }

        public virtual void testGetProfilePictureFromCon() {
            setupData();
            PORTAL_ProfilePictureController.getProfilePictureFromConstituent(con.Id);
        }

        public virtual void testGetProfPictureFromCv() {
            setupData();
            PORTAL_ProfilePictureController.getProfilePictureFromContentVersion(con.Id);
        }

        public virtual void testGetProfPictureFromCvNoContentLink() {
            Contact con = new Contact(LastName = 'TestContact');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;
            PORTAL_ProfilePictureController.getProfilePictureFromContentVersion(con.Id);
        }

        public virtual void testUpdateProfilePictureMultipleUploaded() {
            setupData();
            List<Id> uploadedProfilePics = new List<Id>();

            ContentVersion cv1 = new ContentVersion(Title = 'Test1',
                                     PathOnClient = 'Test1.jpg',
                                     VersionData = blob.valueOf('Test CV data1'),
                                     IsMajorVersion = true);
            cv1 = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cv1});
            insert cv1;

            ContentVersion cv2 = new ContentVersion(Title = 'Test2',
                                     PathOnClient = 'Test2.jpg',
                                     VersionData = blob.valueOf('Test CV data2'),
                                     IsMajorVersion = true);
            cv2 = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cv2});
            insert cv2;

            ContentDocumentLink contentLink1 = new ContentDocumentLink();
            contentLink1.LinkedEntityId = con.Id;
            contentLink1.ShareType = 'V';
            contentLink1.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion Where Id =: cv1.Id].ContentDocumentId;
            contentLink1 = (ContentDocumentLink)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentLink1});
            insert contentLink1;

            ContentDocumentLink contentLink2 = new ContentDocumentLink();
            contentLink2.LinkedEntityId = con.Id;
            contentLink2.ShareType = 'V';
            contentLink2.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion Where Id =: cv2.Id].ContentDocumentId;
            contentLink2 = (ContentDocumentLink)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentLink2});
            insert contentLink2;

            uploadedProfilePics.add(contentLink1.Id);
            uploadedProfilePics.add(contentLink2.Id);

            PORTAL_ProfilePictureController.updateProfilePicture(con.Id, String.valueOf(cv.Id), uploadedProfilePics);
        }
        
        public virtual void testGetProfilePictureFromConstituentOrOrganizationEmptyRecordId() {
            cv = new ContentVersion(Title = 'Test',
                                                   PathOnClient = 'Test.jpg',
                                                   VersionData = blob.valueOf('Test CV data'),
                                                   IsMajorVersion = true);
            cv = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cv});
            insert cv;

            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

            Account acct = new Account(name = 'Test_Account') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                              ucinn_ascendv2__Picture_Record_ID__c = String.valueOf(cv.Id),
                              AccountId = acct.Id,
                              Email = 'testCommunityUserf14@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            ContentDocumentLink contentLink = new ContentDocumentLink();
            contentLink.LinkedEntityId = con.Id;
            contentLink.ShareType = 'V';
            contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion Where Id =: cv.Id].ContentDocumentId;
            contentLink = (ContentDocumentLink)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentLink});
            insert contentLink;

            User comUser = new User(alias = 'testUser',
                                    email = 'testCommunityUserf14@test.com',
                                    emailencodingkey='UTF-8',
                                    lastname = 'Batman',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = profileId,
                                    contactId = con.Id,
                                    IsActive = true,
                                    timezonesidkey='America/Los_Angeles',
                                    username = System.now().millisecond() + 'testCommunityUserf14@test.com');
            comUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => comUser});
            insert comUser;

            Test.startTest();

            System.runAs(comUser) {
                Map<String, Object> result = PORTAL_ProfilePictureController.getProfilePictureInfoFromConstituentOrOrganization('', true);
                System.assertEquals(cv.Id, result.get('profilePictureId'));
            }

            Test.stopTest();
        }
    }

    static testMethod void testGetProfilePictureFromConNoPic() {
        PORTAL_TestClassFactory.getTestClassFactory().getProfilePictureControllerTestClass().testGetProfilePictureFromConNoPic();
    }

    static testMethod void testGetProfilePictureFromCon() {
        PORTAL_TestClassFactory.getTestClassFactory().getProfilePictureControllerTestClass().testGetProfilePictureFromCon();
    }

    static testMethod void testGetProfPictureFromCv() {
        PORTAL_TestClassFactory.getTestClassFactory().getProfilePictureControllerTestClass().testGetProfPictureFromCv();
    }

    static testMethod void testGetProfPictureFromCvNoContentLink() {
        PORTAL_TestClassFactory.getTestClassFactory().getProfilePictureControllerTestClass().testGetProfPictureFromCvNoContentLink();
    }

    static testMethod void testUpdateProfilePictureMultipleUploaded() {
        PORTAL_TestClassFactory.getTestClassFactory().getProfilePictureControllerTestClass().testUpdateProfilePictureMultipleUploaded();
    }
    
    static testMethod void testGetProfilePictureFromConstituentOrOrganizationEmptyRecordId() {
        PORTAL_TestClassFactory.getTestClassFactory().getProfilePictureControllerTestClass().testGetProfilePictureFromConstituentOrOrganizationEmptyRecordId();
    }
	
}