@isTest
public class PORTAL_DMLWrapperTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testDmlWrapper() {
            PORTAL_DMLWrapper dmlWrapper = new PORTAL_DMLWrapper();

            dmlWrapper.getInsertMap();
            dmlWrapper.getUpdateMap();
            dmlWrapper.getUpsertMap();
            dmlWrapper.getDeleteMap();

            dmlWrapper.setInsertMap(null);
            dmlWrapper.setUpdateMap(null);
            dmlWrapper.setUpsertMap(null);
            dmlWrapper.setDeleteMap(null);

            ucinn_portal_Skill_Value__c skillValue = new ucinn_portal_Skill_Value__c(Name = 'test');

            dmlWrapper.addRecordForDML('ucinn_portal_Skill_Value__c', skillValue, PORTAL_DMLWrapper.DmlOperation.INSERT_OP);
            dmlWrapper.performDmlOperations();

            dmlWrapper = new PORTAL_DMLWrapper();
            dmlWrapper.addRecordForDML('ucinn_portal_Skill_Value__c', skillValue, PORTAL_DMLWrapper.DmlOperation.UPSERT_OP);
            dmlWrapper.performDmlOperations();

            dmlWrapper = new PORTAL_DMLWrapper();
            dmlWrapper.addRecordForDML('ucinn_portal_Skill_Value__c', skillValue, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
            dmlWrapper.performDmlOperations();

            dmlWrapper = new PORTAL_DMLWrapper();
            dmlWrapper.addRecordForDML('ucinn_portal_Skill_Value__c', skillValue, PORTAL_DMLWrapper.DmlOperation.DELETE_OP);
            dmlWrapper.performDmlOperations();
        }
    }
    static testMethod void testDmlWrapper() {
        PORTAL_TestClassFactory.getTestClassFactory().getDMLWrapperTestClass().testDmlWrapper();
    }
}