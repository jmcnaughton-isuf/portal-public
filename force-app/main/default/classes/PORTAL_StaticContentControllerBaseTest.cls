@isTest
public class PORTAL_StaticContentControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Content_Page__c contentPage;
        public ucinn_portal_Content_Page__c contentPageWithCSS;
        public ucinn_portal_Content_Page__c contentPageWithWildCard;
        public ucinn_portal_Content_Module__c contentModule;
        public ucinn_portal_Content_Module__c badContentModule;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            contentPage = new ucinn_portal_Content_Page__c(Name = 'test');
            contentPage = (ucinn_portal_Content_Page__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentPage});
            insert contentPage;

            contentModule = new ucinn_portal_Content_Module__c(Name = 'test', Content_Page__c = contentPage.Id, Content_Module_Metadata__c = '{}');
            contentModule = (ucinn_portal_Content_Module__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentModule});
            insert contentModule;

            badContentModule = new ucinn_portal_Content_Module__c(Name = 'bad test', Content_Page__c = contentPage.Id, Content_Module_Metadata__c = '{');
            badContentModule = (ucinn_portal_Content_Module__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => badContentModule});
            insert badContentModule;

            contentPageWithCSS = new ucinn_portal_Content_Page__c(Name = 'test1', Page_URL__c = '/ascendportal/s/test1', Page_CSS_Classes__c = 'test-class');
            contentPageWithCSS = (ucinn_portal_Content_Page__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentPageWithCSS});
            insert contentPageWithCSS;

            contentPageWithWildCard = new ucinn_portal_Content_Page__c(Name = 'test-wildcard', Page_URL__c = '/ascendportal/s/test2*', Page_CSS_Classes__c = 'test-class-wildcard');
            contentPageWithWildCard = (ucinn_portal_Content_Page__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentPageWithWildCard});
            insert contentPageWithWildCard;
        }

        public virtual void getContentModuleMetadataTest() {
            setupData();

            PORTAL_StaticContentControllerBase controller = new PORTAL_StaticContentControllerBase();
            controller.getContentModuleMetadata(null);
            controller.getContentModuleMetadata(new Map<String, Object>());
            controller.getContentModuleMetadata(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_PAGE_NAME => 'test',
                                                                        PORTAL_StaticContentControllerBase.PARAM_MODULE_NAME => 'test',
                                                                        PORTAL_StaticContentControllerBase.PARAM_ZONE_NAME => 'test'});

            controller.getContentModuleMetadata(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_PAGE_NAME => 'test',
                                                                        PORTAL_StaticContentControllerBase.PARAM_MODULE_NAME => 'test',
                                                                        PORTAL_StaticContentControllerBase.PARAM_ZONE_NAME => ''});
            try {
                controller.getContentModuleMetadata(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_PAGE_NAME => 'test',
                                                                            PORTAL_StaticContentControllerBase.PARAM_MODULE_NAME => 'bad test',
                                                                            PORTAL_StaticContentControllerBase.PARAM_ZONE_NAME => ''});
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void getContentModuleTemplateTest() {
            PORTAL_StaticContentControllerBase controller = new PORTAL_StaticContentControllerBase();
            try {
                controller.getContentModuleTemplateList(null);
                PORTAL_StaticContentControllerBase.forceException = true;
                controller.getContentModuleTemplateList(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void getContentModuleByRecordIdTest() {
            setupData();

            PORTAL_StaticContentControllerBase controller = new PORTAL_StaticContentControllerBase();

            controller.getContentModuleByRecordId(null);
            controller.getContentModuleByRecordId(new Map<String, Object>());
            controller.getContentModuleByRecordId(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_RECORD_ID => contentModule.Id});
            String idString = contentModule.Id;
            delete contentModule;
            controller.getContentModuleByRecordId(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_RECORD_ID => idString});
        }

        public virtual void saveContentModuleTest() {
            setupData();

            PORTAL_StaticContentControllerBase controller = new PORTAL_StaticContentControllerBase();
            controller.saveContentModule(null);
            controller.saveContentModule(new Map<String, Object>());
            controller.saveContentModule(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_RECORD_ID => contentModule.Id,
                                                                 PORTAL_StaticContentControllerBase.PARAM_LWC_NAME => 'test',
                                                                 PORTAL_StaticContentControllerBase.PARAM_CONTENT_MODULE_METADATA => '{}'});

            controller.saveContentModule(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_RECORD_ID => 'invalidId',
                                                                 PORTAL_StaticContentControllerBase.PARAM_LWC_NAME => 'test',
                                                                 PORTAL_StaticContentControllerBase.PARAM_CONTENT_MODULE_METADATA => '{}'});
        }

        public virtual void getContentPageCSSClassesTest() {
            setupData();

            PORTAL_StaticContentControllerBase controller = new PORTAL_StaticContentControllerBase();
            System.assert(String.isBlank(controller.getContentPageCSSClasses(null)));
            System.assert(String.isBlank(controller.getContentPageCSSClasses(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_PAGE_URL => null})));
            System.assert(String.isBlank(controller.getContentPageCSSClasses(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_PAGE_URL => '/ascendportal/s/test3-management'})));
            System.assertEquals('test-class', controller.getContentPageCSSClasses(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_PAGE_URL => '/ascendportal/s/test1'}));
            System.assertEquals('test-class-wildcard', controller.getContentPageCSSClasses(new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_PAGE_URL => '/ascendportal/s/test2-management'}));
        }
    }

    static testMethod void getContentModuleMetadataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getStaticContentControllerBaseTestClass().getContentModuleMetadataTest();
    }

    static testMethod void getContentModuleTemplateTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getStaticContentControllerBaseTestClass().getContentModuleTemplateTest();
    }

    static testMethod void getContentModuleByRecordIdTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getStaticContentControllerBaseTestClass().getContentModuleByRecordIdTest();
    }

    static testMethod void saveContentModuleTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getStaticContentControllerBaseTestClass().saveContentModuleTest();
    }

    static testMethod void getContentPageCSSClassesTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getStaticContentControllerBaseTestClass().getContentPageCSSClassesTest();
    }
}