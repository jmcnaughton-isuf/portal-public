@isTest
public class PORTAL_TRIG_AffiliationHandlerTest {
    public virtual class TestClass {
        public virtual void setupTriggerHandler(){
            ucinn_ascendv2__Trigger_Handler__c trigHandler = new ucinn_ascendv2__Trigger_Handler__c(
                Name = 'PORTAL_TRIG_AffiliationHandler',
                ucinn_ascendv2__Class__c = 'PORTAL_TRIG_AffiliationHandler',
                ucinn_ascendv2__Is_Active__c = true,
                ucinn_ascendv2__Object__c = 'ucinn_ascendv2__Affiliation__c',
                ucinn_ascendv2__Trigger_Action__c = 'BeforeInsert;BeforeUpdate'
            );
            insert trigHandler;
        }

        public virtual void setupAccount(){
            Account Employer = new Account(
                Name = 'Google'
            );

            Account dummyEmployer = new Account(
                Name = 'Dummy Employer Organization *DO NOT DELETE*'
            );

            insert new List<Account>{Employer, dummyEmployer};
        }

        public virtual void testEmployerPopulation() {
            setupTriggerHandler();
            setupAccount();

            Contact testContact = new Contact(
                Lastname = 'Test'
            );
    
            insert testContact;
    
            ucinn_ascendv2__Affiliation__c affiliation = new ucinn_ascendv2__Affiliation__c(
                ucinn_portal_Employer_Text__c = 'Google',
                Name = 'Test Affiliation',
                ucinn_ascendv2__Contact__c = testContact.Id
            );
    
            insert affiliation;
    
            ucinn_ascendv2__Affiliation__c queriedAffil = [SELECT ID,ucinn_ascendv2__Account__c 
                                                                    FROM ucinn_ascendv2__Affiliation__c WHERE ID =: affiliation.Id];
    
    
            System.assertNotEquals(queriedAffil.ucinn_ascendv2__Account__c, null, 'Employer should be populated.');
            
            queriedAffil.ucinn_portal_Employer_Text__c = 'Amazon';
            update queriedAffil;
        }
    }

    static testMethod void testEmployerPopulation() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_AffiliationHandlerTestClass().testEmployerPopulation();
    }
}