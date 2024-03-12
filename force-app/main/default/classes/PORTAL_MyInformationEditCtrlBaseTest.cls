@isTest
public with sharing class PORTAL_MyInformationEditCtrlBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public Contact con;
        public User communityUser;
        public ucinn_ascendv2__Degree_Information__c schoolDegree;
        public ucinn_ascendv2__Interim__c selfReportInterim;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData(){
            System.runAs(thisUser) {
                ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
                orgSettings.Name = 'Default Org Wide Config';
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
                orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
                insert orgSettings;

                Id profileId = [SELECT Id FROM Profile WHERE Name = :'ascend Customer Community User'].Id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact dummyContact = new Contact();
                dummyContact.FirstName = 'My Information Dummy Contact';
                dummyContact.LastName = 'Do Not Delete This Record';
                dummyContact.AccountId = acct.Id;
                dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});
                insert dummyContact;

                con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');

                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        ContactId = con.Id,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testCommunityUsermig123@test.com');

                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c();
                email.ucinn_ascendv2__Contact__c = con.Id;
                email.ucinn_ascendv2__Email_Address__c = 'blahblah@test.com';
                email.ucinn_ascendv2__Status__c = 'Current';
                email.ucinn_portal_Is_Display_On_Portal__c = true;
                email = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => email});
                insert email;

                schoolDegree = new ucinn_ascendv2__Degree_Information__c(
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Degree_Institution__c = acct.Id, 
                    ucinn_ascendv2__Degree__c = 'BS',
                    ucinn_ascendv2__Conferred_Degree_Year__c = '2018',
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_portal_Status__c = 'Active',
                    recordTypeId = Schema.SObjectType.ucinn_ascendv2__Degree_Information__c.getRecordTypeInfosByDeveloperName().get('School_Degree_Information').getRecordTypeId()
                );
                insert schoolDegree;

                selfReportInterim = new ucinn_ascendv2__Interim__c(
                    ucinn_ascendv2__Contact__c = con.Id, 
                    ucinn_ascendv2__Status__c = PORTAL_MyInformationEditControllerBase.MANUAL_REVIEW,
                    recordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_MyInformationEditControllerBase.BIO_INFORMATION_SELF_REPORT).getRecordTypeId(),
                    ucinn_ascendv2__Birthdate__c = Date.newInstance(2000, 12, 31)
                );

                insert selfReportInterim;

                ucinn_ascendv2__Service_Indicator_Value__c serviceIndicatorValue = new ucinn_ascendv2__Service_Indicator_Value__c();
                serviceIndicatorValue.Name = 'Test';
                serviceIndicatorValue.ucinn_portal_Portal_Description__c = 'Test Service Indicator';
                serviceIndicatorValue = (ucinn_ascendv2__Service_Indicator_Value__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => serviceIndicatorValue});
                insert serviceIndicatorValue;
            }
        }

        public virtual void testSaveEmail() {
            Test.startTest();
            setupData();
            List<Map<String,Object>> records = new List<Map<String,Object>>();
            records.add(new Map<String, Object>{'emailAddress' => 'testmyinfomail@test.com', 'emailType' => 'Personal', 'isDelete' => false});

            Map<Object, Object> params = new Map<Object, Object>();
            params.put('emails', records);
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());

            System.runAs(communityUser) {
                controller.saveInformation(new Map<String, Object>{'sectionIdToUpdatedRecordsMap' => params});
                List<ucinn_ascendv2__Email__c> emailList = [SELECT Id, ucinn_ascendv2__Type__c FROM ucinn_ascendv2__Email__c];
                Assert.areEqual(1, emailList.size());

                records = new List<Map<String,Object>>();
                records.add(new Map<String, Object>{'emailAddress' => 'testmyinfomail1234@test.com', 'emailType' => 'Personal', 'isDelete' => false, 'Id' => emailList.get(0).Id});

                params = new Map<Object, Object>();
                params.put('emails', records);
                controller.saveInformation(new Map<String, Object>{'sectionIdToUpdatedRecordsMap' => params});
                emailList = [SELECT Id, ucinn_ascendv2__Type__c FROM ucinn_ascendv2__Email__c];
                Assert.areEqual(2, emailList.size());
            }

            Test.stopTest();
        }

        public virtual void testSavePhone() {
            Test.startTest();
            setupData();
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());
    
            List<Map<String,Object>> records = new List<Map<String,Object>>();
            records.add(new Map<String, Object>{'phoneNumber' => '9991231234', 'phoneType' => 'Other', 'isDelete' => false});

            Map<Object, Object> params = new Map<Object, Object>();
            params.put('phones', records);

            System.runAs(communityUser) {
                controller.saveInformation(new Map<String, Object>{'sectionIdToUpdatedRecordsMap' => params});
                List<ucinn_ascendv2__Phone__c> phoneList = [SELECT Id FROM ucinn_ascendv2__Phone__c WHERE ucinn_ascendv2__Contact__c =: con.Id];
                Assert.areEqual(1, phoneList.size());

                // delete
                records = new List<Map<String,Object>>();
                records.add(new Map<String, Object>{'phoneNumber' => '9991231234', 'phoneType' => 'Other', 'isDelete' => true, 'Id' => phoneList.get(0).Id});

                params = new Map<Object, Object>();
                params.put('phones', records);

                controller.saveInformation(new Map<String, Object>{'sectionIdToUpdatedRecordsMap' => params});
                phoneList = [SELECT Id, ucinn_ascendv2__Status__c FROM ucinn_ascendv2__Phone__c WHERE ucinn_ascendv2__Contact__c =: con.Id AND ucinn_ascendv2__Phone_Number__c = '9991231234'];
                Assert.areEqual('Former', phoneList.get(0).ucinn_ascendv2__Status__c);
            }
            Test.stopTest();
        }

        public virtual void testSaveAddress() {
            Test.startTest();
            setupData();
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());
    
            List<Map<String,Object>> records = new List<Map<String,Object>>();
            records.add(new Map<String, Object>{'addressLine1' => 'Test Addy', 'addressCity' => 'Irvine', 'addressType' => 'Other', 'isDelete' => false});

            Map<Object, Object> params = new Map<Object, Object>();
            params.put('addresses', records);

            System.runAs(communityUser) {
                controller.saveInformation(new Map<String, Object>{'sectionIdToUpdatedRecordsMap' => params});
                List<ucinn_ascendv2__Address_Relation__c> addressRelationList = [SELECT Id FROM ucinn_ascendv2__Address_Relation__c];
                Assert.areEqual(1, addressRelationList.size());
            }
            Test.stopTest();
        }

        public virtual void testSavePersonalInformation() {
            Test.startTest();
            setupData();
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());
    
            List<Map<String,Object>> nameRecords = new List<Map<String,Object>>();
            nameRecords.add(new Map<String, Object>{'firstName' => 'FirstNameTest', 'isDelete' => false});

            Map<Object, Object> params = new Map<Object, Object>();
            params.put('name', nameRecords);

            List<Map<String,Object>> additionalDetailsRecords = new List<Map<String, Object>>();
            additionalDetailsRecords.add(new Map<String, Object>{'spouseFirstName' => 'SpouseFirstNameTest', 
                                                                'gender' => 'Female',
                                                                'isDelete' => false});
            params.put('additionalDetails', additionalDetailsRecords);

            List<Map<String,Object>> directoryRecords = new List<Map<String, Object>>();
            directoryRecords.add(new Map<String, Object>{'directoryFirstName' => 'TonyDirName', 'isDelete' => false});
            params.put('directoryName', directoryRecords);

            System.runAs(communityUser) {
                controller.saveInformation(new Map<String, Object>{'sectionIdToUpdatedRecordsMap' => params});
                List<Contact> contactList = [SELECT Id FROM Contact WHERE Email = 'testCommunityUsermig123@test.com' AND ucinn_ascendv2__Gender__c = 'Female'];
                Assert.areEqual(1, contactList.size());

                List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id FROM ucinn_ascendv2__Interim__c WHERE ucinn_ascendv2__First_Name__c = 'FirstNameTest' AND ucinn_portal_Directory_First_Name__c = 'TonyDirName'];
                Assert.areEqual(1, interimList.size());
            }
            Test.stopTest();
        }

        public virtual void testGetEditInfo() {
            setupData();
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());
            // testing section with birthdate since Self Report page section settings exist from v1 and work with v2
            Map<String, Object> params = new Map<String, Object>{
                PORTAL_MyInformationEditControllerBase.PAGE_NAME => 'My Information',
                PORTAL_MyInformationEditControllerBase.MAIN_SECTION_NAME => 'Personal_Information',
                PORTAL_MyInformationEditControllerBase.SUB_SECTION_NAME => 'Additional_Details',
                PORTAL_MyInformationEditControllerBase.SELF_REPORT_PAGE_NAME => 'My Information Self Report'
            };

            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> responseMap = controller.getEditInfo(params);
                PORTAL_MyInfoRetriever.MyInfoConfiguration configuration = (PORTAL_MyInfoRetriever.MyInfoConfiguration)JSON.deserialize((String)responseMap.get(PORTAL_MyInfoRetriever.CONFIG_STRING), PORTAL_MyInfoRetriever.MyInfoConfiguration.class);

                System.assert(configuration.sectionConfigurationMap.containsKey('additionalDetails'));
                System.assert(configuration.selfReportSectionConfigurationMap.containsKey('additionalDetails'));
                System.assertEquals(1, ((List<Object>)responseMap.get(PORTAL_MyInfoRetriever.RECORD_LIST_WITH_STAGED_CHANGES)).size());
                System.assertEquals(1, ((List<Object>)responseMap.get(PORTAL_MyInfoRetriever.SELF_REPORT_RECORD_LIST)).size());
            }
            Test.stopTest();
        }

        public virtual void testSelfReportBirthdate() {
            setupData();
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());
            
            // testing section with birthdate since Self Report page section settings exist from v1 and work with v2
            Map<String, Object> birthdateMap = new Map<String, Object>{
                'Id' => selfReportInterim.Id, // not strictly necessary, but this emulates frontend more closely 
                'birthdate' => '2000-10-31',
                'isBirthdateDeleted' => false
            };
            
            Map<String, Object> params = new Map<String, Object>{
                PORTAL_MyInformationEditControllerBase.SELF_REPORT_RECORD_MAP => birthdateMap,
                PORTAL_MyInformationEditControllerBase.PAGE_NAME => 'My Information Self Report',
                PORTAL_MyInformationEditControllerBase.MAIN_SECTION_NAME => 'Personal_Information',
                PORTAL_MyInformationEditControllerBase.SUB_SECTION_NAME => 'Additional_Details',
                PORTAL_MyInformationEditControllerBase.SECTION_ID => 'additionalDetails'
            };

            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> result = controller.selfReportInformation(params);
                System.assertEquals(selfReportInterim.Id, (String)result.get('Id'));
                System.assertEquals(Date.newInstance(2000, 10, 31), (Date)result.get('birthdate'));

                // test self report when the self report interim is not created yet
                String previousId = selfReportInterim.Id;
                delete selfReportInterim;
                birthdateMap.remove('Id');

                result = controller.selfReportInformation(params);
                System.assertNotEquals(previousId, (String)result.get('Id'));
                System.assertEquals(Date.newInstance(2000, 10, 31), (Date)result.get('birthdate'));
            }

            Test.stopTest();
        }

        public virtual void testSelfReportSchoolDegree() {
            setupData();
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());
            
            // Self Report page section settings for School Degrees exists in v1, so this test still works for v2 
            // There are some page section setting fields missing that v2 uses, but the code still runs to completion
            Map<String, Object> degreeRecordMap = new Map<String, Object>{
                'masterDegree' => schoolDegree.Id, // not strictly necessary, but this emulates frontend more closely  
                'schoolDegreeDegree' => 'MS',
                'schoolDegreeYear' => '2019',
                'postCode' => null,
                'minorCode' => null
            };
            
            Map<String, Object> params = new Map<String, Object>{
                PORTAL_MyInformationEditControllerBase.SELF_REPORT_RECORD_MAP => degreeRecordMap,
                PORTAL_MyInformationEditControllerBase.PAGE_NAME => 'My Information Self Report',
                PORTAL_MyInformationEditControllerBase.MAIN_SECTION_NAME => 'Degrees',
                PORTAL_MyInformationEditControllerBase.SUB_SECTION_NAME => 'School_Degree_Information',
                PORTAL_MyInformationEditControllerBase.SECTION_ID => 'schoolDegreesSelfReport',
                PORTAL_MyInformationEditControllerBase.ORIGINAL_RECORD_ID => schoolDegree.Id // doesn't do anything if the page section setting's Original Record Field API Name is blank
            };

            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> result = controller.selfReportInformation(params);
                System.assertNotEquals(schoolDegree.Id, (String)result.get('Id'));
                System.assertEquals('MS', (String)result.get('schoolDegreeDegree'));
                System.assertEquals('2019', (String)result.get('schoolDegreeYear'));
            }
            Test.stopTest();
        }

        public virtual void testSearchServiceIndicatorValues() {
            Test.startTest();
            setupData();
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());
            Map<String, Object> params = new Map<String, Object>{
                PORTAL_MyInformationEditControllerBase.SEARCH_TEXT => 'Test',
                PORTAL_MyInformationEditControllerBase.PAGE_NAME => 'My Information',
                PORTAL_MyInformationEditControllerBase.MAIN_SECTION_NAME => 'Privacy_Settings',
                PORTAL_MyInformationEditControllerBase.SUB_SECTION_NAME => 'Service Indicator Values',
                PORTAL_MyInformationEditControllerBase.SECTION_ID => 'serviceIndicatorValues'
            };

            System.runAs(communityUser) {
                List<Map<String, Object>> result = controller.searchServiceIndicatorValues(params);
            }
            Test.stopTest();
        }

        public virtual void testIsDisplaySearchBar() {
            Test.startTest();
            setupData();
            PORTAL_MyInformationEditControllerBase controller = ((PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController());
            Boolean result = controller.isDisplaySearchBar(new Map<String, Object>());
            Assert.areEqual(true, result);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testSaveEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testSaveEmail();
    }

    @isTest
    public static void testSavePhone() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testSavePhone();
    }

    @isTest
    public static void testSaveAddress() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testSaveAddress();
    }

    @isTest
    public static void testSavePersonalInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testSavePersonalInformation();
    }

    /**
     * Test getEditInfo for my info v2
     * @author Jacob Huang
     * @since 1.10
     */
    @isTest
    public static void testGetEditInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testGetEditInfo();
    }

    /**
     * Test selfReportInformation for my info v2 with birthdate
     * @author Jacob Huang
     * @since 1.10
     */
    @isTest
    public static void testSelfReportBirthdate() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testSelfReportBirthdate();
    }

    /**
     * Test selfReportInformation for my info v2 with a school degree information
     * @author Jacob Huang
     * @since 1.10
     */
    @isTest
    public static void testSelfReportSchoolDegree() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testSelfReportSchoolDegree();
    }

    /**
     * Test searching for service indicator value
     * @author Phillip Nguyen
     * @since 1.12
     */
    @isTest
    public static void testSearchServiceIndicatorValues() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testSearchServiceIndicatorValues();
    }

    /**
     * Test if we display search bar
     * @author Phillip Nguyen
     * @since 1.12
     */
    @isTest
    public static void testIsDisplaySearchBar() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationEditCtrlBaseTestClass().testIsDisplaySearchBar();
    }
}