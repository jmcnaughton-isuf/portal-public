public class PORTAL_OnlineGivingControllerTestOR extends PORTAL_OnlineGivingControllerTest.TestClass{
    
    public override void testGetFeaturedDesignations() {
        ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
        designation.Name = '2704805';
        designation.ucinn_portal_Is_Display_On_Portal__c = true;
        designation.ucinn_portal_Display_Order__c = '1';
        designation.ucinn_ascendv2__External_System_Id__c = 'test';
        designation.ucinn_ascendv2__Override_Status__c  = true;
        designation.ASG_Ask_Remove_Fund__c = false;
        designation.Fund_Group__c = 'Endowment';
        designation.Fund_Purpose__c = 'Other';
        designation.FE_Program__c = 'Test';
        insert designation;
        ucinn_ascendv2__Designation__c designation2 = new ucinn_ascendv2__Designation__c();
        designation2.Name = '2704624';
        designation2.ucinn_portal_Is_Display_On_Portal__c = true;
        designation2.ucinn_portal_Display_Order__c = '2';
        designation2.ucinn_ascendv2__Override_Status__c  = true;
        designation2.ASG_Ask_Remove_Fund__c = false;
        designation2.Fund_Group__c = 'Endowment';
        designation2.Fund_Purpose__c = 'Other';
        designation2.FE_Program__c = 'Test';
        insert designation2;
        
        List<ucinn_ascendv2__Designation__c> desList = [SELECT id, name, ucinn_ascendv2__Status_Formula__c, ASG_Ask_Remove_Fund__c FROM ucinn_ascendv2__Designation__c];
        System.debug(desList);
        Map<String, Object> params =  new Map<String, Object>();
        params.put('designations', String.valueOf(designation.ucinn_ascendv2__External_System_Id__c));
        params.put('pageName', 'Online Giving');
        List<Map<String, Object>> designationList = PORTAL_OnlineGivingController.SERVER_getFeaturedDesignations(params);
        System.assert(designationList.size() == 1);
    }
    
    public override void testGetAllDesignations() {
        ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
        designation.Name = 'Test Designation';
        designation.ucinn_portal_Is_Display_On_Portal__c = true;
        designation.ucinn_portal_Display_Order__c = '1';
        designation.ucinn_ascendv2__Override_Status__c  = true;
        designation.ASG_Ask_Remove_Fund__c = false;
        designation.Fund_Group__c = 'Endowment';
        designation.Fund_Purpose__c = 'Other';
        designation.FE_Program__c = 'Test';
        insert designation;
        List<ucinn_ascendv2__Designation__c> desList = [SELECT id, name, ucinn_ascendv2__Status_Formula__c, ASG_Ask_Remove_Fund__c FROM ucinn_ascendv2__Designation__c];
        System.debug(desList);
        Map<String, Object> params =  new Map<String, Object>();
        params.put('pageName', 'Online Giving');
        List<Map<String, Object>> designationList = PORTAL_OnlineGivingController.SERVER_getAllDesignations(params);
        System.assert(designationList.size() == 1);
    }
    
    public override void testGetConstituentInformation() {
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com',
                                      ucinn_portal_Give_Page_Encryption__c = '123',
                                      ucinn_ascendv2__Donor_ID__c = '0001');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            Map<String, Object> returnMap = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(new Map<String, Object>{'donorId' => '0001', 'passcode' => '123'});
            
            System.runAs(communityUser) {
                returnMap = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(new Map<String, Object>());
            }
        }
    }
    
    public override void testOneTimeGift() {
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'gift');
            params.put('amount', '100');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyId', '34j4tjifg88');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
        }
    }
    
    
    public override void testPledge() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'pledge');
            params.put('amount', '100');
            params.put('startDate', Date.today().addMonths(1));
            params.put('frequency', 'Annual');
            params.put('numberOfInstallments', 10);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    
    public override void testPledgeSemiAnnual() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'pledge');
            params.put('amount', '100');
            params.put('startDate', Date.today().addMonths(1));
            params.put('frequency', 'Semi-Annual');
            params.put('numberOfInstallments', 10);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    
    public override void testPledgeQuarterly() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'pledge');
            params.put('amount', '100');
            params.put('startDate', Date.today().addMonths(1));
            params.put('frequency', 'Quarterly');
            params.put('numberOfInstallments', 10);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    
    public override void testPledgeMonthly() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'pledge');
            params.put('amount', '100');
            params.put('startDate', Date.today().addMonths(1));
            params.put('frequency', 'Monthly');
            params.put('numberOfInstallments', 10);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    
    public override void testPledgeBiWeekly() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'pledge');
            params.put('amount', '100');
            params.put('startDate', Date.today().addMonths(1));
            params.put('frequency', 'Bi-Weekly');
            params.put('numberOfInstallments', 10);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    
    public override void testPledgeWeekly() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'pledge');
            params.put('amount', '100');
            params.put('startDate', Date.today().addMonths(1));
            params.put('frequency', 'Weekly');
            params.put('numberOfInstallments', 10);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    public override void testPledgeWithPayment() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'pledge');
            params.put('amount', '100');
            params.put('startDate', Date.today());
            params.put('frequency', 'Annual');
            params.put('numberOfInstallments', 10);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    
    public override void testPledgeWithNoInstallments() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'pledge');
            params.put('amount', '100');
            params.put('startDate', Date.today().addMonths(1));
            params.put('frequency', 'Annual');
            params.put('numberOfInstallments', 0);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    
    public override void testRecurringGiftWithPayment() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        Account acct = new Account(name = 'ACME Co') ;
        insert acct;
        
        
        
        Contact con = new Contact(LastName = 'Test_Contact',
                                  AccountId = acct.Id,
                                  ucinn_portal_Is_Display_On_Portal__c = true,
                                  Email = 'testCommunityUsermig123@test.com');
        insert con;
        
        ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
        name.ucinn_ascendv2__Type__c = 'Full Name';
        name.ucinn_ascendv2__First_Name__c = 'Test';
        name.ucinn_ascendv2__Last_Name__c = 'Test';
        name.ucinn_ascendv2__Contact__c = con.Id;
        insert name;
        
        Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
        User communityUser = new User(alias = 'comUser',
                                      email = 'testCommunityUsermig123@test.com',
                                      emailencodingkey='UTF-8',
                                      lastname = 'Batman',
                                      languagelocalekey='en_US',
                                      localesidkey='en_US',
                                      profileid = profileId,
                                      IsActive = true,
                                      ContactId = con.Id,
                                      timezonesidkey='America/Los_Angeles',
                                      username = 'testCommunityUsermig123@test.com');
        insert communityUser;
        
        ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
        homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
        homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
        homePhone.ucinn_ascendv2__Is_Preferred__c = true;
        homePhone.ucinn_ascendv2__Status__c = 'Current';
        homePhone.ucinn_ascendv2__Contact__c = con.Id;
        homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
        homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
        insert homePhone;
        
        ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
        insert address;
        
        ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                               ucinn_ascendv2__Address__c = address.Id,
                                                                                               ucinn_ascendv2__Is_Preferred__c = true,
                                                                                               ucinn_ascendv2__Status__c = 'Current',
                                                                                               ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                               ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                               RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                               ucinn_ascendv2__Type__c = 'Home',
                                                                                               ucinn_portal_Is_Display_On_Portal__c = true);
        insert relation;
        
        ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                      ucinn_ascendv2__Contact__c = con.Id,
                                                                      ucinn_ascendv2__Status__c = 'Current',
                                                                      ucinn_ascendv2__Type__c = 'Business',
                                                                      ucinn_ascendv2__Is_Preferred__c = true,
                                                                      ucinn_portal_Is_Display_On_Portal__c = true);
        insert email;
        
        
        
        ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
        designation.Name = 'Test Designation';
        designation.ucinn_portal_Is_Display_On_Portal__c = true;
        designation.ucinn_portal_Display_Order__c = '1';
        insert designation;
        
        Map<Object, Object> designationMap = new Map<Object, Object>();
        designationMap.put('Id', designation.Id);
        designationMap.put('amount', 50);
        designationMap.put('Name', 'Test Designation');
        Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
        otherDesignationMap.put('Id', '');
        otherDesignationMap.put('Name', 'Other');
        otherDesignationMap.put('amount', 50);
        List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
        designations.add(designationMap);
        designations.add(otherDesignationMap);
        
        ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
        page.Name = 'Test Page';
        insert page;
        ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
        module.Name = 'Test Module';
        module.Content_Page__c = page.Id;
        insert module;
        
        ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
        text.Default_Value__c = 'Hello';
        text.Editable__c = true;
        text.Field_Order__c = 2;
        text.Field_Label__c = 'Text';
        text.ucinn_portal_Content_Module__c = module.Id;
        text.Field_Type__c = 'Text';
        text.Page_Name__c = 'Registrant';
        text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
        insert text;
        
        Map<String, Object> params = new Map<String, Object>();
        params.put('designations', designations);
        params.put('giftType', 'recurring');
        params.put('amount', '100');
        params.put('startDate', Date.today());
        params.put('frequency', 'Annual');
        params.put('numberOfInstallments', 0);
        
        Map<String, Object> stripeBillingInformation = new Map<String, Object>();
        stripeBillingInformation.put('name', 'Test Test');
        stripeBillingInformation.put('email', 'test@ucinnovation.com');
        Map<String, Object> addressMap = new Map<String, Object>();
        addressMap.put('city', 'Irvine');
        addressMap.put('state', 'CA');
        addressMap.put('country', 'US');
        addressMap.put('postal_code', '92602');
        addressMap.put('line1', '2855 Michelle Drive');
        stripeBillingInformation.put('address', addressMap);
        params.put('stripeBillingInformation', stripeBillingInformation);
        params.put('apiKeyName', 'Stripe Secret API Key');
        
        List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
        Map<String, Object> customField = new Map<String, Object>();
        customField.put('Id', text.Id);
        customField.put('value', 'test');
        additionalDetails.add(customField);
        params.put('additionalDetails', additionalDetails);
        params.put('paymentId', '8fgjf7fsdfj3lj34j');
        params.put('matchingCompanyName', 'UC Innovation');
        
        Map<String, Object> tributeInformation = new Map<String, Object>();
        tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
        tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
        tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
        tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
        tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
        tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
        tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
        tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
        tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
        params.put('tributeInformation', tributeInformation);
        params.put('paymentMethod', 'Stripe');
        params.put('pageSectionName', 'Online Giving');
        params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
        
        Test.startTest();
        System.runAs(communityUser) {
            Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
            params.put('billingInformation', billingInformation);
            PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
        }
        Test.stopTest();
    }
    
    
    public override void testRecurringGiftWithoutPayment() {
        
        PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
        Test.setMock(HttpCalloutMock.class, mockcallouts);
        
        PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();
        
        mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
        mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
        mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
        mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
        
        
        ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
        orgSettings.Name = 'Default Org Wide Config';
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
        orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
        
        insert orgSettings;
        
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                             ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                             ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                             ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                             ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
        ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                              ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                              ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                              ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                              ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
        insert addressSetting;
        insert addressSetting2;
        
        System.runAs(thisUser) {
            Account acct = new Account(name = 'ACME Co') ;
            insert acct;
            
            
            
            Contact con = new Contact(LastName = 'Test_Contact',
                                      AccountId = acct.Id,
                                      ucinn_portal_Is_Display_On_Portal__c = true,
                                      Email = 'testCommunityUsermig123@test.com',
                                      ucinn_portal_Stripe_Customer_ID__c = '9843534213');
            insert con;
            
            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;
            
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User communityUser = new User(alias = 'comUser',
                                          email = 'testCommunityUsermig123@test.com',
                                          emailencodingkey='UTF-8',
                                          lastname = 'Batman',
                                          languagelocalekey='en_US',
                                          localesidkey='en_US',
                                          profileid = profileId,
                                          IsActive = true,
                                          ContactId = con.Id,
                                          timezonesidkey='America/Los_Angeles',
                                          username = 'testCommunityUsermig123@test.com');
            insert communityUser;
            
            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Phone';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;
            
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                                ucinn_ascendv2__City__c = 'Irvine',
                                                                                ucinn_ascendv2__State__c = 'CA',
                                                                                ucinn_ascendv2__Country__c = 'US',
                                                                                ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;
            
            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                   ucinn_ascendv2__Address__c = address.Id,
                                                                                                   ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                   ucinn_ascendv2__Status__c = 'Current',
                                                                                                   ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                   ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                   RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                   ucinn_ascendv2__Type__c = 'Home',
                                                                                                   ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;
            
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            insert email;
            
            
            
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            
            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);
            
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;
            
            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'recurring');
            params.put('amount', '100');
            params.put('startDate', Date.today());
            params.put('frequency', 'Annual');
            params.put('numberOfInstallments', 0);
            
            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');
            
            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');
            
            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');
            
            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }
    }
    
    
}