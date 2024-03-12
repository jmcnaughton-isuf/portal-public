public with sharing class PORTAL_ContactWrapper {
    public static final String FIRST_NAME = 'firstName';
    public static final String LAST_NAME = 'lastName';
    public static final String PHONE_NUMBER = 'phoneNumber';
    public static final String PHONE_TYPE = 'phoneType';
    public static final String EMAIL_ADDRESS = 'emailAddress';
    public static final String EMAIL_TYPE = 'emailType';
    public static final String ADDRESS_STREET_LINE_1 = 'addressLine1';
    public static final String ADDRESS_STREET_LINE_2 = 'addressLine2';
    public static final String ADDRESS_CITY = 'addressCity';
    public static final String ADDRESS_STATE = 'addressState';
    public static final String ADDRESS_POSTAL_CODE = 'addressPostalCode';
    public static final String ADDRESS_COUNTRY = 'addressCountry';
    public static final String ADDRESS_TYPE = 'addressType';

    @AuraEnabled
    public String firstName {get; set;}
    @AuraEnabled
    public String lastName {get; set;}
    @AuraEnabled
    public String phoneNumber {get; set;}
    @AuraEnabled
    public String phoneType {get; set;}
    @AuraEnabled
    public String emailAddress {get; set;}
    @AuraEnabled
    public String emailType {get; set;}
    @AuraEnabled
    public String addressLine1 {get; set;}
    @AuraEnabled
    public String addressLine2 {get; set;}
    @AuraEnabled
    public String addressCity {get; set;}
    @AuraEnabled
    public String addressState {get; set;}
    @AuraEnabled
    public String addressPostalCode {get; set;}
    @AuraEnabled
    public String addressCountry {get; set;}
    @AuraEnabled
    public String addressType {get; set;}

    public PORTAL_ContactWrapper() {}

    public PORTAL_ContactWrapper(Contact contactRecord) {
        if (contactRecord == null) {
            return;
        }

        ucinn_ascendv2__Phone__c phone = contactRecord.ucinn_ascendv2__Phones_Contact__r?.isEmpty() ? null : contactRecord.ucinn_ascendv2__Phones_Contact__r[0];
        ucinn_ascendv2__Email__c email = contactRecord.ucinn_ascendv2__Emails_Contact__r?.isEmpty() ? null : contactRecord.ucinn_ascendv2__Emails_Contact__r[0];
        ucinn_ascendv2__Address_Relation__c addressRelation = contactRecord.ucinn_ascendv2__Address_Relations_Contact__r?.isEmpty() ? null : contactRecord.ucinn_ascendv2__Address_Relations_Contact__r[0];

        this.firstName = contactRecord.FirstName;
        this.lastName = contactRecord.LastName;
        this.phoneNumber = phone?.ucinn_ascendv2__Phone_Number__c;
        this.phoneType = phone?.ucinn_ascendv2__Type__c;
        this.emailAddress = email?.ucinn_ascendv2__Email_Address__c;
        this.emailType = email?.ucinn_ascendv2__Type__c;
        this.addressLine1 = addressRelation?.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_1__c;
        this.addressLine2 = addressRelation?.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_2__c;
        this.addressCity = addressRelation?.ucinn_ascendv2__Address__r.ucinn_ascendv2__City__c;
        this.addressState = addressRelation?.ucinn_ascendv2__Address__r.ucinn_ascendv2__State__c;
        this.addressPostalCode = addressRelation?.ucinn_ascendv2__Address__r.ucinn_ascendv2__Postal_Code__c;
        this.addressCountry = addressRelation?.ucinn_ascendv2__Address__r.ucinn_ascendv2__Country__c;
        this.addressType = addressRelation?.ucinn_ascendv2__Type__c;
    }
}