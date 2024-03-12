@isTest
public class PORTAL_TRIG_DegreeInfoHandlerTest {
    public virtual class TestClass {
        public virtual void setupTriggerHandler(){
            ucinn_ascendv2__Trigger_Handler__c trigHandler = new ucinn_ascendv2__Trigger_Handler__c(
                Name = 'PORTAL_TRIG_DegreeInfoHandler',
                ucinn_ascendv2__Class__c = 'PORTAL_TRIG_DegreeInfoHandler',
                ucinn_ascendv2__Is_Active__c = true,
                ucinn_ascendv2__Object__c = 'ucinn_ascendv2__Degree_Information__c',
                ucinn_ascendv2__Trigger_Action__c = 'BeforeInsert;BeforeUpdate'
            );
            insert trigHandler;
        }

        public virtual void setupAccount(){
            Account institution = new Account(
                Name = 'UCLA'
            );

            Account dummyInstitution = new Account(
                Name = 'Dummy Employer Organization *DO NOT DELETE*'
            );

            insert new List<Account>{institution, dummyInstitution};
        }

        public virtual void testDegreeInstitutionPopulation() {
            setupTriggerHandler();
            setupAccount();

            Contact testContact = new Contact(
                Lastname = 'Test'
            );
    
            insert testContact;
    
            ucinn_ascendv2__Degree_Information__c degreeInfo = new ucinn_ascendv2__Degree_Information__c(
                ucinn_portal_Degree_Institution_Text__c = 'UCLA',
                Name = 'Test Degree Info',
                ucinn_ascendv2__Contact__c = testContact.Id
            );
    
            insert degreeInfo;
    
            ucinn_ascendv2__Degree_Information__c queriedDegree = [SELECT ID,ucinn_ascendv2__Degree_Institution__c 
                                                                    FROM ucinn_ascendv2__Degree_Information__c WHERE ID =: degreeInfo.Id];
    
    
            System.assertNotEquals(queriedDegree.ucinn_ascendv2__Degree_Institution__c, null, 'Degree Institution should be populated.');
            
            queriedDegree.ucinn_portal_Degree_Institution_Text__c = 'UCSD';
            update queriedDegree;
    
            ucinn_ascendv2__Degree_Information__c updatedDegree = [SELECT ID,ucinn_ascendv2__Degree_Institution__c 
                                                                    FROM ucinn_ascendv2__Degree_Information__c WHERE ID =: degreeInfo.Id];
        }
    }

    static testMethod void testDegreeInstitutionPopulation() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_DegreeInfoHandlerTestClass().testDegreeInstitutionPopulation();
    }
}