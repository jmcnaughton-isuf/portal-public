@isTest
public without sharing class PORTAL_DirectorySearchTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        public Contact dummyContact;
        public Contact dummyContact2;
        public Contact dummyContact3;

        public virtual void setupData() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                dummyContact = new Contact();
                dummyContact.FirstName = 'Dummy';
                dummyContact.LastName = 'Contact';
                dummyContact.AccountId = acct.Id;
                dummyContact.ucinn_portal_Is_Display_On_Portal__c = true;
                dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});
                insert dummyContact;

                dummyContact2 = new Contact();
                dummyContact2.FirstName = 'Dummy';
                dummyContact2.LastName = 'Contact';
                dummyContact2.AccountId = acct.Id;
                dummyContact2.ucinn_portal_Is_Display_On_Portal__c = true;
                dummyContact2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact2});
                insert dummyContact2;

                dummyContact3 = new Contact();
                dummyContact3.FirstName = 'Dummy';
                dummyContact3.LastName = 'Contact';
                dummyContact3.AccountId = acct.Id;
                dummyContact3.ucinn_portal_Is_Display_On_Portal__c = true;
                dummyContact3 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact3});
                insert dummyContact3;

                insert testClassUtil.populateRequiredfieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => new ucinn_ascendv2__Degree_Information__c(ucinn_ascendv2__Contact__c = dummyContact.Id, ucinn_ascendv2__Degree__c = 'AB', ucinn_ascendv2__Conferred_Degree_Year__c = '2017')});
                insert testClassUtil.populateRequiredfieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => new ucinn_ascendv2__Affiliation__c(ucinn_ascendv2__Contact__c = dummyContact.Id, ucinn_ascendv2__Job_Title__c = 'Tester', ucinn_ascendv2__Account__c = acct.Id, ucinn_ascendv2__Constituent_Role__c = 'Employee', ucinn_ascendv2__Organization_Role__C = 'Employer')});
            }
        }

        public virtual void testSearch() {
            setupData();

            PORTAL_SearchCategory degreeSearchCategory = new PORTAL_SearchCategory();
            degreeSearchCategory.objectApiName = 'ucinn_ascendv2__Degree_Information__c';
            degreeSearchCategory.searchCriteriaList = new List<PORTAL_SearchCriteria>{new PORTAL_SearchCriteria('Class Year', '2017')};

            PORTAL_DirectorySearch controller = new PORTAL_DirectorySearch.Builder().build();
            controller.performSearch();

            ucinn_portal_Search_Filter_Cache__c filterCache = new ucinn_portal_Search_Filter_Cache__c(Cache_Api_Name__c = 'Hiring_Managers_Cache', Contact_Id_Cache_1__c = dummyContact.Id + ';', Filter_Value__c = 'true');
            insert filterCache;

            filterCache = new ucinn_portal_Search_Filter_Cache__c(Cache_Api_Name__c = 'Job_Seekers_Cache', Contact_Id_Cache_1__c = dummyContact.Id + ';', Filter_Value__c = 'true');
            insert filterCache;

            controller = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>{degreeSearchCategory})
                                                             .buildCachedCriteriaList(new List<PORTAL_SearchCriteria>{new PORTAL_SearchCriteria('Show Hiring Managers', 'true'), new PORTAL_SearchCriteria('Show Job Seekers', 'true')})
                                                             .build();
            controller.performSearch();

            controller = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>{degreeSearchCategory})
                                                             .buildCachedCriteriaList(new List<PORTAL_SearchCriteria>{new PORTAL_SearchCriteria('Show Hiring Managers', 'true'), new PORTAL_SearchCriteria('Name Search', 'Dummy')})
                                                             .build();
            controller.performSearch();

            controller = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>{degreeSearchCategory})
                                                             .buildCachedCriteriaList(new List<PORTAL_SearchCriteria>{new PORTAL_SearchCriteria('Name Search', 'Dummy')})
                                                             .buildZoneName('Main')
                                                             .buildMaxContacts(20)
                                                             .build();
            controller.performSearch();
        }

        public virtual void testAddressSearch() {
            setupData();

            PORTAL_SearchCategory addressSearchCategory = new PORTAL_SearchCategory();
            addressSearchCategory.objectApiName = 'ucinn_ascendv2__Address_Relation__c';
            addressSearchCategory.searchCriteriaList = new List<PORTAL_SearchCriteria>{
                new PORTAL_SearchCriteria('City', 'Irvine'),
                new PORTAL_SearchCriteria('State', 'CA'),
                new PORTAL_SearchCriteria('Country', 'USA'),
                new PORTAL_SearchCriteria('Postal Code', '92606')
            };


            PORTAL_SearchCategory degreeSearchCategory = new PORTAL_SearchCategory();
            degreeSearchCategory.objectApiName = 'ucinn_ascendv2__Degree_Information__c';
            degreeSearchCategory.searchCriteriaList = new List<PORTAL_SearchCriteria>{new PORTAL_SearchCriteria('Class Year', '2017')};

            PORTAL_DirectorySearch controller = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>{degreeSearchCategory, degreeSearchCategory, addressSearchCategory}).build();
            controller.performSearch();

            addressSearchCategory.searchCriteriaList = new List<PORTAL_SearchCriteria>{
                new PORTAL_SearchCriteria('City', 'Irvine'),
                new PORTAL_SearchCriteria('State', 'CA'),
                new PORTAL_SearchCriteria('Country', 'USA'),
                new PORTAL_SearchCriteria('Postal Code', '92606'),
                new PORTAL_SearchCriteria('Distance', '10')
            };

            controller = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>{degreeSearchCategory, addressSearchCategory, degreeSearchCategory}).build();
            controller.performSearch();
        }

        public virtual void testQueryContactIdsFromSearchCategories() {
            setupData();
            Set<String> params = new Set<String>();
            params.add(dummyContact.Id);
            params.add(dummyContact2.Id);
            params.add(dummyContact3.Id);

            PORTAL_SearchCategory addressSearchCategory = new PORTAL_SearchCategory();
            addressSearchCategory.objectApiName = 'ucinn_ascendv2__Address_Relation__c';
            addressSearchCategory.searchCriteriaList = new List<PORTAL_SearchCriteria>{
                new PORTAL_SearchCriteria('City', 'Irvine'),
                new PORTAL_SearchCriteria('State', 'CA'),
                new PORTAL_SearchCriteria('Country', 'USA'),
                new PORTAL_SearchCriteria('Postal Code', '92606')
            };
    
    
            PORTAL_SearchCategory degreeSearchCategory = new PORTAL_SearchCategory();
            degreeSearchCategory.objectApiName = 'ucinn_ascendv2__Degree_Information__c';
            degreeSearchCategory.searchCriteriaList = new List<PORTAL_SearchCriteria>{new PORTAL_SearchCriteria('Class Year', '2017')};


            Test.startTest();

            PORTAL_DirectorySearch controller = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>{degreeSearchCategory, addressSearchCategory, degreeSearchCategory}).build();
            controller.queryContactIdsFromSearchCategories(params);

            PORTAL_DirectorySearch controllerAlternativeOrder = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>{degreeSearchCategory, degreeSearchCategory, addressSearchCategory}).build();
            controllerAlternativeOrder.queryContactIdsFromSearchCategories(params);

            PORTAL_DirectorySearch controllerTwoCategories = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>{degreeSearchCategory, degreeSearchCategory}).build();
            controllerTwoCategories.queryContactIdsFromSearchCategories(params);

            PORTAL_DirectorySearch controllerEmptyCategoryList = new PORTAL_DirectorySearch.Builder().buildCategoryList(new List<PORTAL_SearchCategory>()).build();
            controllerEmptyCategoryList.queryContactIdsFromSearchCategories(params);

            Test.stopTest();
        }

        public virtual void testParseContactIdsFromSearch() {
            setupData();
            PORTAL_DirectorySearch controller = new PORTAL_DirectorySearch.Builder().build();

            Test.startTest();

            controller.parseContactIdsFromSearch(new Set<String>{dummyContact.Id});

            Test.stopTest();
        }

        public virtual void testGetQueryClauseForFieldSetting() {
            Portal_Directory_Search_Query_Field__mdt fieldSetting = new Portal_Directory_Search_Query_Field__mdt();
            fieldSetting.Operation__c = 'DISTANCE';

            PORTAL_AddressWrapper address = new PORTAL_AddressWrapper();
            address.streetLine1 = 'Test street';
            address.city = 'Test city';
            address.state = 'California';
            address.country = 'US';
            address.postalCode = '00000';

            PORTAL_SearchCriteria searchCriteria = new PORTAL_SearchCriteria();
            searchCriteria.addressList = new List<PORTAL_AddressWrapper>{address};

            PORTAL_DirectorySearch controller = new PORTAL_DirectorySearch.Builder().build();

            Test.startTest();

            controller.getQueryClauseForFieldSetting(fieldSetting, searchCriteria);

            Test.stopTest();
        }

        public virtual void testParseSearchCriteriaForAddresses() {
            PORTAL_DirectorySearch controller = new PORTAL_DirectorySearch.Builder().build();

            List<PORTAL_SearchCriteria> searchCriteriaList = new List<PORTAL_SearchCriteria>();

            PORTAL_SearchCriteria searchCriteriaCity = new PORTAL_SearchCriteria();
            searchCriteriaCity.searchForSelected = 'City';
            searchCriteriaCity.valueList = new List<String>{'City'};
            searchCriteriaList.add(searchCriteriaCity);
            
            PORTAL_SearchCriteria searchCriteriaCountry = new PORTAL_SearchCriteria();
            searchCriteriaCountry.searchForSelected = 'Country';
            searchCriteriaCountry.valueList = new List<String>{'Country'};
            searchCriteriaList.add(searchCriteriaCountry);

            PORTAL_SearchCriteria searchCriteriaState = new PORTAL_SearchCriteria();
            searchCriteriaState.searchForSelected = 'State';
            searchCriteriaState.valueList = new List<String>{'State'};
            searchCriteriaList.add(searchCriteriaState);

            PORTAL_SearchCriteria searchCriteriaPostal = new PORTAL_SearchCriteria();
            searchCriteriaPostal.searchForSelected = 'Postal Code';
            searchCriteriaPostal.valueList = new List<String>{'Postal'};
            searchCriteriaList.add(searchCriteriaPostal);

            PORTAL_SearchCriteria searchCriteriaDistance = new PORTAL_SearchCriteria();
            searchCriteriaDistance.searchForSelected = 'Distance';
            searchCriteriaDistance.valueList = new List<String>{'Distance'};
            searchCriteriaList.add(searchCriteriaDistance);



            Test.startTest();

            controller.parseSearchCriteriaForAddresses(searchCriteriaList);
            controller.parseSearchCriteriaForAddresses(null);

            Test.stopTest();
        }

        public virtual void testGetQueryClauseForSearchCriteriaInvalidInput() {
            PORTAL_DirectorySearch controller = new PORTAL_DirectorySearch.Builder().build();

            Test.startTest();

            String result = controller.getQueryClauseForSearchCriteria(null, null);
            System.assert(String.isBlank(result));

            Test.stopTest();
        }

        public virtual void testGetNonCachedContactIds() {
            setupData();

            Set<String> contactIdSet = new Set<String>{dummyContact.Id};
            PORTAL_SearchCriteria searchCriteria = new PORTAL_SearchCriteria();
            searchCriteria.searchForSelected = 'City';
            searchCriteria.valueList = new List<String>{'Test'}; 

            PORTAL_DirectorySearch controller = new PORTAL_DirectorySearch.Builder().build();

            Test.startTest();

            controller.getNonCachedContactIds(searchCriteria, contactIdSet);
            controller.getNonCachedContactIds(searchCriteria, null);

            Test.stopTest();
        }
    }

    public static testMethod void testSearch() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectorySearchTestClass().testSearch();
    }

    public static testMethod void testAddressSearch() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectorySearchTestClass().testAddressSearch();
    }

    public static testMethod void testQueryContactIdsFromSearchCategories() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectorySearchTestClass().testQueryContactIdsFromSearchCategories();
    }

    public static testMethod void testParseContactIdsFromSearch() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectorySearchTestClass().testParseContactIdsFromSearch();
    }

    public static testMethod void testGetQueryClauseForFieldSetting() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectorySearchTestClass().testGetQueryClauseForFieldSetting();
    }

    public static testMethod void testParseSearchCriteriaForAddresses() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectorySearchTestClass().testParseSearchCriteriaForAddresses();
    }

    public static testMethod void testGetNonCachedContactIds() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectorySearchTestClass().testGetNonCachedContactIds();
    }

    public static testMethod void testGetQueryClauseForSearchCriteriaInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectorySearchTestClass().testGetQueryClauseForSearchCriteriaInvalidInput();
    }
}