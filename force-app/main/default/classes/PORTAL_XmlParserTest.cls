@isTest
public class PORTAL_XmlParserTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetXMLAttribute() {
            DOM.Document doc = new DOM.Document();
            DOM.XmlNode node = doc.createRootElement('Test', 'Test', 'Test');

            Test.startTest();

            PORTAL_XmlParser parser = new PORTAL_XmlParser(node);
            String result = parser.getXMLAttribute(new List<String>());
            System.assertNotEquals(null, result);

            Test.stopTest();
        }

        public virtual void testGetXMLAttributeInvalidInput() {
            List<String> params = new List<String>();
            params.add('Test');

            Test.startTest();

            String result = PORTAL_XmlParser.getXMLAttribute(params, null);
            System.assertEquals(null, result);

            Test.stopTest();
        }

        public virtual void testGetXMLAttributeRecursiveCase() {
            DOM.Document doc = new DOM.Document();
            DOM.XmlNode node = doc.createRootElement('Test', 'Test', 'Test');
            node.addChildElement('Test', 'Test', 'Test');
            List<String> params = new List<String>();
            params.add('Test');

            Test.startTest();

            String result = PORTAL_XmlParser.getXMLAttribute(params, node);

            Test.stopTest();
        }
    }


    static testMethod void testGetXMLAttribute() {
        PORTAL_TestClassFactory.getTestClassFactory().getXmlParserTestClass().testGetXMLAttribute();
    }

    static testMethod void testGetXMLAttributeInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getXmlParserTestClass().testGetXMLAttributeInvalidInput();
    }

    static testMethod void testGetXMLAttributeRecursiveCase() {
        PORTAL_TestClassFactory.getTestClassFactory().getXmlParserTestClass().testGetXMLAttributeRecursiveCase();
    }
}