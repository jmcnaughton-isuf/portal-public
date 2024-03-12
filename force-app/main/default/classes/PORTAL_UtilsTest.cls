@isTest
global class PORTAL_UtilsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetHandlerClassDefinition() {
            PORTAL_Utils.getHandlerClassDefinition(null);
            PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => PORTAL_LookupControllerBase.Class});
            PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => PORTAL_LookupControllerBase.Class});
            PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => PORTAL_MyInformationControllerBase.Class});
        }

        public virtual void testGetCustomMetadataRecordList() {
            PORTAL_Utils.getCustomMetadataRecordList(null);
            PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object> {PORTAL_Utils.QUERY_STRING => 'SELECT id, DeveloperName FROM Portal_Organization_Setting__mdt'});
            PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object> {PORTAL_Utils.FIELD_SET => new Set<String>{'Id, Label'}, PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt'});
            PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object> {PORTAL_Utils.FIELD_SET => new Set<String>{'Id, Label'}, PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt', PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Package_Version'}});
        }
    }
    @isTest
    static void testGetHandlerClassDefinition() {
        PORTAL_TestClassFactory.getTestClassFactory().getUtilsTestClass().testGetHandlerClassDefinition();
    }

    @isTest
    static void testGetCustomMetadataRecordList() {
        PORTAL_TestClassFactory.getTestClassFactory().getUtilsTestClass().testGetCustomMetadataRecordList();
    }
}