@isTest
public class PORTAL_HEP_ApiRepositoryTest {
    public virtual class TestClass extends PORTAL_TestClassBase{

        public virtual void getCompaniesParsesCorrectly() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_HEP_ApiRepositoryCalloutMock());

            PORTAL_HEP_CompanySearchResult response = PORTAL_HEP_ApiRepository.getCompaniesByName('disney', null);
            System.assertEquals(58, response.count);

            List<PORTAL_HEP_CompanySearchResult.Company> results = response.results;
            System.assert(!results.isEmpty());

            PORTAL_HEP_CompanySearchResult.Company company = results.get(0);
            System.assert(company.name == 'Disney Book Group (Walt Disney Company)');
            Test.stopTest();
        }

        public virtual void getCompaniesRetriesAndFailsGracefully() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_403ErrorCalloutMock());

            PORTAL_HEP_CompanySearchResult response = PORTAL_HEP_ApiRepository.getCompaniesByName('disney', null);
            List<PORTAL_HEP_CompanySearchResult.Company> results = response.results;
            System.assert(response.count == null);
            System.assert(results == null);
            Test.stopTest();
        }

        public virtual void getCompanyDetailsParsesCorrectly() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_HEP_ApiRepositoryCalloutMock());

            PORTAL_HEP_CompanyDetailsResult response = PORTAL_HEP_ApiRepository.getCompanyDetailsByID('12420000', null);
            System.assert(response.company_id == '12420000');
            Test.stopTest();
        }

        public virtual void getCompanyDetailsRetriesAndFailsGracefully() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_403ErrorCalloutMock());

            PORTAL_HEP_CompanyDetailsResult response = PORTAL_HEP_ApiRepository.getCompanyDetailsByID('12420000', null);
            System.assert(response.company_id == null);
            Test.stopTest();
        }

        public virtual void testCreatePortalDonorEntry() {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PORTAL_HEP_ApiRepositoryCalloutMock());

            Integer response = PORTAL_HEP_ApiRepository.createPortalDonorEntry('', '', '', '', '');
            System.assert(response == 0);

            Test.stopTest();
        }
    }

    @isTest static void getCompaniesParsesCorrectly() {
        PORTAL_TestClassFactory.getTestClassFactory().getHepApiRepositoryTestClass().getCompaniesParsesCorrectly();
    }

    @isTest static void getCompaniesRetriesAndFailsGracefully() {
        PORTAL_TestClassFactory.getTestClassFactory().getHepApiRepositoryTestClass().getCompaniesRetriesAndFailsGracefully();
    }

    @isTest static void getCompanyDetailsParsesCorrectly() {
        PORTAL_TestClassFactory.getTestClassFactory().getHepApiRepositoryTestClass().getCompanyDetailsParsesCorrectly();
    }

    @isTest static void getCompanyDetailsRetriesAndFailsGracefully() {
        PORTAL_TestClassFactory.getTestClassFactory().getHepApiRepositoryTestClass().getCompanyDetailsRetriesAndFailsGracefully();
    }

    @isTest static void testCreatePortalDonorEntry() {
        PORTAL_TestClassFactory.getTestClassFactory().getHepApiRepositoryTestClass().testCreatePortalDonorEntry();
    }
}