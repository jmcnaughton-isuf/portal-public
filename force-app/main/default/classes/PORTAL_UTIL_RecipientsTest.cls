@isTest
public class PORTAL_UTIL_RecipientsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testGetContentFiltersThatMatchConstituentAttributes() {
            Contact cont = new Contact(FirstName = 'First', MiddleName='Middle', LastName='Last', ucinn_ascendv2__Gender__c = 'F');
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;

            Account acct = new Account(Name = 'University');
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            ucinn_ascendv2__Degree_Information__c degree = new ucinn_ascendv2__Degree_Information__c();
            degree.ucinn_ascendv2__Degree__c = 'BS';
            degree.ucinn_ascendv2__Degree_Institution__c = acct.Id;
            degree.ucinn_ascendv2__Contact__c = cont.Id;
            degree = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => degree});
            insert degree;

            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__First_Name__c = 'First';
            name.ucinn_ascendv2__Last_Name__c = 'Last';
            name.ucinn_ascendv2__Middle_Name__c = 'Middle';
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__Contact__c = cont.Id;
            name = (ucinn_ascendv2__Contact_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => name});
            insert name;


            PORTAL_UTIL_Recipients.getContentFiltersThatMatchConstituentAttributes(new Map<String, Object>{PORTAL_UTIL_Recipients.CONTACT_ID => cont.Id});

            ucinn_portal_Recipient__c filterWithNoLogic = new ucinn_portal_Recipient__c();
            filterWithNoLogic.Filter_Logic__c = '';
            filterWithNoLogic = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterWithNoLogic});
            insert filterWithNoLogic;

            ucinn_portal_Recipient__c filterWithNoFilters = new ucinn_portal_Recipient__c();
            filterWithNoFilters.Filter_Logic__c = '1 AND 2 AND 3';
            filterWithNoFilters = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterWithNoFilters});
            insert filterWithNoFilters;

            ucinn_portal_Recipient__c filterWithOnlyOperators = new ucinn_portal_Recipient__c();
            filterWithOnlyOperators.Filter_Logic__c = '1 2 AND AND AND AND';
            filterWithOnlyOperators = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterWithOnlyOperators});
            insert filterWithOnlyOperators;

            ucinn_portal_Recipient__c filterWithOnlyOperands = new ucinn_portal_Recipient__c();
            filterWithOnlyOperands.Filter_Logic__c = '1 2 3 4';
            filterWithOnlyOperands = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterWithOnlyOperands});
            insert filterWithOnlyOperands;

            ucinn_portal_Recipient__c filterWithMissingOperand = new ucinn_portal_Recipient__c();
            filterWithMissingOperand.Filter_Logic__c = '1 AND AND AND 2 3';
            filterWithMissingOperand = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterWithMissingOperand});
            insert filterWithMissingOperand;

            ucinn_portal_Recipient__c filterWithOneOperand = new ucinn_portal_Recipient__c();
            filterWithOneOperand.Filter_Logic__c = '1';
            filterWithOneOperand = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterWithOneOperand});
            insert filterWithOneOperand;

            ucinn_portal_Recipient__c filterWithDegreeInformation = new ucinn_portal_Recipient__c();
            filterWithDegreeInformation.Filter_Logic__c = '1';
            filterWithDegreeInformation = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterWithDegreeInformation});
            insert filterWithDegreeInformation;

            ucinn_portal_Recipient__c filterWithContactField = new ucinn_portal_Recipient__c();
            filterWithContactField.Filter_Logic__c = '1 AND 2';
            filterWithContactField = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterWithContactField});
            insert filterWithContactField;

            ucinn_portal_Recipient__c goodFilter = new ucinn_portal_Recipient__c();
            goodFilter = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => goodFilter});
            insert goodFilter;

            ucinn_portal_Recipient__c orFilter = new ucinn_portal_Recipient__c();
            orFilter.Filter_Logic__c = '1 OR 2 OR 3';
            orFilter = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orFilter});
            insert orFilter;

            ucinn_portal_Recipient_Filter__c firstFilter = new ucinn_portal_Recipient_Filter__c();
            firstFilter.Field_API_Name__c = 'ucinn_ascendv2__First_Name__c';
            firstFilter.Field_Value__c = 'First';
            firstFilter.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            firstFilter.Order_Number__c = '1';
            firstFilter.Operator__c = '=';
            firstFilter.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            firstFilter.Recipient__c = goodFilter.Id;
            firstFilter = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => firstFilter});
            insert firstFilter;

            ucinn_portal_Recipient_Filter__c secondFilter = new ucinn_portal_Recipient_Filter__c();
            secondFilter.Field_API_Name__c = 'ucinn_ascendv2__Middle_Name__c';
            secondFilter.Field_Value__c = 'Middle';
            secondFilter.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            secondFilter.Order_Number__c = '2';
            secondFilter.Operator__c = '=';
            secondFilter.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            secondFilter.Recipient__c = goodFilter.Id;
            secondFilter = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => secondFilter});
            insert secondFilter;

            ucinn_portal_Recipient_Filter__c thirdFilter = new ucinn_portal_Recipient_Filter__c();
            thirdFilter.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            thirdFilter.Order_Number__c = '3';
            thirdFilter.Has_Multiple_Fields__c = true;
            thirdFilter.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            thirdFilter.Recipient__c = goodFilter.Id;
            thirdFilter = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => thirdFilter});
            insert thirdFilter;


            ucinn_portal_Recipient_Filter_Field__c firstField = new ucinn_portal_Recipient_Filter_Field__c();
            firstField.Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c';
            firstField.Field_Value__c = 'Last';
            firstField.Operator__c = '=';
            firstField.Recipient_Filter__c = thirdFilter.Id;
            firstField = (ucinn_portal_Recipient_Filter_Field__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => firstField});
            insert firstField;

            ucinn_portal_Recipient_Filter_Field__c secondField = new ucinn_portal_Recipient_Filter_Field__c();
            secondField.Field_API_Name__c = 'ucinn_ascendv2__First_Name__c';
            secondField.Field_Value__c = 'First';
            secondField.Operator__c = '=';
            secondField.Recipient_Filter__c = thirdFilter.Id;
            secondField = (ucinn_portal_Recipient_Filter_Field__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => secondField});
            insert secondField;

            ucinn_portal_Recipient_Filter__c firstFilterOR = new ucinn_portal_Recipient_Filter__c();
            firstFilterOR.Field_API_Name__c = 'ucinn_ascendv2__First_Name__c';
            firstFilterOR.Field_Value__c = 'First';
            firstFilterOR.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            firstFilterOR.Order_Number__c = '1';
            firstFilterOR.Operator__c = '=';
            firstFilterOR.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            firstFilterOR.Recipient__c = orFilter.Id;
            firstFilterOR = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => firstFilterOR});
            insert firstFilterOR;

            ucinn_portal_Recipient_Filter__c secondFilterOR = new ucinn_portal_Recipient_Filter__c();
            secondFilterOR.Field_API_Name__c = 'ucinn_ascendv2__Middle_Name__c';
            secondFilterOR.Field_Value__c = 'Middle';
            secondFilterOR.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            secondFilterOR.Order_Number__c = '2';
            secondFilterOR.Operator__c = '=';
            secondFilterOR.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            secondFilterOR.Recipient__c = orFilter.Id;
            secondFilterOR = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => secondFilterOR});
            insert secondFilterOR;

            ucinn_portal_Recipient_Filter__c thirdFilterOR = new ucinn_portal_Recipient_Filter__c();
            thirdFilterOR.Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c';
            thirdFilterOR.Field_Value__c = 'Last';
            thirdFilterOR.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            thirdFilterOR.Order_Number__c = '3';
            thirdFilterOR.Operator__c = '=';
            thirdFilterOR.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            thirdFilterOR.Recipient__c = orFilter.Id;
            thirdFilterOR = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => thirdFilterOR});
            insert thirdFilterOR;

            ucinn_portal_Recipient_Filter__c filterForNoLogic = new ucinn_portal_Recipient_Filter__c();
            filterForNoLogic.Field_API_Name__c = 'ucinn_ascendv2__First_Name__c';
            filterForNoLogic.Field_Value__c = 'First';
            filterForNoLogic.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            filterForNoLogic.Order_Number__c = '1';
            filterForNoLogic.Operator__c = '=';
            filterForNoLogic.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            filterForNoLogic.Recipient__c = filterWithNoLogic.Id;
            filterForNoLogic = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterForNoLogic});
            insert filterForNoLogic;

            ucinn_portal_Recipient_Filter__c filterForOnlyOperands = new ucinn_portal_Recipient_Filter__c();
            filterForOnlyOperands.Field_API_Name__c = 'ucinn_ascendv2__First_Name__c';
            filterForOnlyOperands.Field_Value__c = 'First';
            filterForOnlyOperands.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            filterForOnlyOperands.Order_Number__c = '1';
            filterForOnlyOperands.Operator__c = '=';
            filterForOnlyOperands.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            filterForOnlyOperands.Recipient__c = filterWithOnlyOperands.Id;
            filterForOnlyOperands = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterForOnlyOperands});
            insert filterForOnlyOperands;

            ucinn_portal_Recipient_Filter__c filterForOnlyOperators = new ucinn_portal_Recipient_Filter__c();
            filterForOnlyOperators.Field_API_Name__c = 'ucinn_ascendv2__First_Name__c';
            filterForOnlyOperators.Field_Value__c = 'First';
            filterForOnlyOperators.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            filterForOnlyOperators.Order_Number__c = '1';
            filterForOnlyOperators.Operator__c = '=';
            filterForOnlyOperators.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            filterForOnlyOperators.Recipient__c = filterWithOnlyOperators.Id;
            filterForOnlyOperators = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterForOnlyOperators});
            insert filterForOnlyOperators;

            ucinn_portal_Recipient_Filter__c filterForMissingOperand = new ucinn_portal_Recipient_Filter__c();
            filterForMissingOperand.Field_API_Name__c = 'ucinn_ascendv2__First_Name__c';
            filterForMissingOperand.Field_Value__c = 'First';
            filterForMissingOperand.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            filterForMissingOperand.Order_Number__c = '1';
            filterForMissingOperand.Operator__c = '=';
            filterForMissingOperand.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            filterForMissingOperand.Recipient__c = filterWithMissingOperand.Id;
            filterForMissingOperand = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterForMissingOperand});
            insert filterForMissingOperand;

            ucinn_portal_Recipient_Filter__c filterForOneOperand = new ucinn_portal_Recipient_Filter__c();
            filterForOneOperand.Field_API_Name__c = 'ucinn_ascendv2__First_Name__c';
            filterForOneOperand.Field_Value__c = 'First';
            filterForOneOperand.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            filterForOneOperand.Order_Number__c = '1';
            filterForOneOperand.Operator__c = '=';
            filterForOneOperand.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Contact_Names_Contact__r';
            filterForOneOperand.Recipient__c = filterWithOneOperand.Id;
            filterForOneOperand = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterForOneOperand});
            insert filterForOneOperand;

            ucinn_portal_Recipient_Filter__c filterForContactField = new ucinn_portal_Recipient_Filter__c();
            filterForContactField.Field_API_Name__c = 'ucinn_ascendv2__Gender__c';
            filterForContactField.Field_Value__c = 'F';
            filterForContactField.Object_API_Name__c = 'Contact';
            filterForContactField.Order_Number__c = '1';
            filterForContactField.Operator__c = '=';
            filterForContactField.Contact_Relationship_API_Name__c = '';
            filterForContactField.Recipient__c = filterWithContactField.Id;
            filterForContactField = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterForContactField});
            insert filterForContactField;

            ucinn_portal_Recipient_Filter__c filterForContactField2 = new ucinn_portal_Recipient_Filter__c();
            filterForContactField2.Field_API_Name__c = 'ucinn_ascendv2__Preferred_Spouse__r.Name';
            filterForContactField2.Field_Value__c = 'F';
            filterForContactField2.Object_API_Name__c = 'Contact';
            filterForContactField2.Order_Number__c = '2';
            filterForContactField2.Operator__c = '=';
            filterForContactField2.Contact_Relationship_API_Name__c = '';
            filterForContactField2.Recipient__c = filterWithContactField.Id;
            filterForContactField2 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterForContactField2});
            insert filterForContactField2;

            ucinn_portal_Recipient_Filter__c filterForDegreeInformamtion = new ucinn_portal_Recipient_Filter__c();
            filterForDegreeInformamtion.Field_API_Name__c = 'ucinn_ascendv2__Degree_Institution__r.Name';
            filterForDegreeInformamtion.Field_Value__c = 'University';
            filterForDegreeInformamtion.Object_API_Name__c = 'ucinn_ascendv2__Degree_Information__c';
            filterForDegreeInformamtion.Order_Number__c = '1';
            filterForDegreeInformamtion.Operator__c = '=';
            filterForDegreeInformamtion.Contact_Relationship_API_Name__c = 'ucinn_ascendv2__Degree_Information_Contact__r';
            filterForDegreeInformamtion.Recipient__c = filterWithDegreeInformation.Id;
            filterForDegreeInformamtion = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterForDegreeInformamtion});
            insert filterForDegreeInformamtion;

            PORTAL_UTIL_Recipients.getContentFiltersThatMatchConstituentAttributes(new Map<String, Object>{PORTAL_UTIL_Recipients.CONTACT_ID => ''});
            PORTAL_UTIL_Recipients.getContentFiltersThatMatchConstituentAttributes(new Map<String, Object>{PORTAL_UTIL_Recipients.CONTACT_ID => cont.Id});

            goodFilter.Filter_Logic__c = '1 AND 2 AND Test';
            update goodFilter;

            filterWithContactField.Filter_Logic__c = '1 AND 2 AND AND AND';
            update filterWithContactField;

            PORTAL_UTIL_Recipients.getContentFiltersThatMatchConstituentAttributes(new Map<String, Object>{PORTAL_UTIL_Recipients.CONTACT_ID => cont.Id});
            PORTAL_UTIL_Recipients.getContentFiltersThatMatchConstituentAttributes(new Map<String, Object>{PORTAL_UTIL_Recipients.CONTACT_ID => cont.Id,
                                                                                                           PORTAL_UTIL_Recipients.TICKET_TYPE_ID_SET => new Set<String>()});
            PORTAL_UTIL_Recipients.evaluateFilterFieldCriteriaWithMultipleFields(null, null, null);
        }
    }
    @isTest
    private static void testGetContentFiltersThatMatchConstituentAttributes() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_RecipientsTestClass().testGetContentFiltersThatMatchConstituentAttributes();
    }
}