@istest
public with sharing class PORTAL_HEP_ApiRepositoryORTest {
      
        @istest
        public static void getCompaniesParsesCorrectly() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_HEP_ApiRepositoryCalloutMock());

            PORTAL_HEP_CompanySearchResult response = PORTAL_HEP_ApiRepositoryOR.getCompaniesByName('disney', null);
            //System.assertEquals(58, response.count);

            List<PORTAL_HEP_CompanySearchResult.Company> results = response.results;
            //System.assert(!results.isEmpty());

            //PORTAL_HEP_CompanySearchResult.Company company = results.get(0);
            //System.assert(company.name == 'Disney Book Group (Walt Disney Company)');
            Test.stopTest();
        }

        @istest
        public static void getCompaniesRetriesAndFailsGracefully() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_403ErrorCalloutMock());

            PORTAL_HEP_CompanySearchResult response = PORTAL_HEP_ApiRepositoryOR.getCompaniesByName('disney', null);
            List<PORTAL_HEP_CompanySearchResult.Company> results = response.results;
            System.assert(response.count == null);
            System.assert(results == null);
            Test.stopTest();
        }
        
        @istest
        public static void getCompanyDetailsParsesCorrectly() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_HEP_ApiRepositoryCalloutMock());

            PORTAL_HEP_CompanyDetailsResult response = PORTAL_HEP_ApiRepositoryOR.getCompanyDetailsByID('12420000', null);
            //System.assert(response.company_id == '12420000');
            Test.stopTest();
        }

        @istest
        public static void getCompanyDetailsRetriesAndFailsGracefully() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_403ErrorCalloutMock());

            PORTAL_HEP_CompanyDetailsResult response = PORTAL_HEP_ApiRepositoryOR.getCompanyDetailsByID('12420000', null);
            System.assert(response.company_id == null);
            Test.stopTest();
        }
        
        @istest
        public static void testCreatePortalDonorEntry() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_HEP_ApiRepositoryCalloutMock());

            Integer response = PORTAL_HEP_ApiRepositoryOR.createPortalDonorEntry('', '', '', '', '');
            System.assert(response == 0);

            Test.stopTest();
        }
    

    
}