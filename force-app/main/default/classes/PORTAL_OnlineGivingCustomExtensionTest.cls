@isTest
public class PORTAL_OnlineGivingCustomExtensionTest {
	@TestSetup
    static void createDate() {
        ucinn_ascendv2__Review_Transaction_v2__c RTRec = new ucinn_ascendv2__Review_Transaction_v2__c();
        RTRec.ucinn_ascendv2__External_System_ID__c = 'GNRL-test-123';
        insert RTRec;
        
        Contact contactRec = new Contact(FirstName='Test FN', LastName='Test LN');
        insert contactRec;

        ucinn_ascendv2__Session__c session = new ucinn_ascendv2__Session__c();
        session.ucinn_ascendv2__Is_Ready_for_G_L__c = true;
        insert session;

		Opportunity newGift = new Opportunity();
        newGift.ucinn_ascendv2__External_System_ID__c = 'test-123';
        newGift.Name = 'newGift';
        newGift.StageName = 'New';
        newGift.CloseDate = system.today();
        newGift.ucinn_ascendv2__Contact__c = contactRec.Id;
        newGift.Amount = 10;
        insert newGift;
		
        ucinn_ascendv2__Academic_Organization__c academicOrg = new ucinn_ascendv2__Academic_Organization__c();
        academicOrg.Name = 'Test Academic Org2';
        insert academicOrg;
        
        ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
        designation.Name = 'Test DesignationMain';
        designation.ucinn_portal_Is_Display_On_Portal__c = true;
        designation.ucinn_portal_Display_Order__c = '1';
        designation.ucinn_ascendv2__X1_Academic_Org__c = academicOrg.Id;
        insert designation;
        
        ucinn_ascendv2__Designation__c designationRec = new ucinn_ascendv2__Designation__c(Name='Test Des');
        insert designationRec;

        ucinn_ascendv2__Designation_Detail__c dd = new ucinn_ascendv2__Designation_Detail__c();
        dd.ucinn_ascendv2__Contact__c = contactrec.Id;
        dd.ucinn_ascendv2__Designation__c = designationRec.Id;
        dd.ucinn_ascendv2__Opportunity__c = newGift.Id;
        dd.ucinn_ascendv2__Amount__c = 10;
        insert dd;
        
        ucinn_ascendv2__Payment__c payment = new ucinn_ascendv2__Payment__c();
        payment.ucinn_ascendv2__Contact__c = contactRec.Id;
        payment.ucinn_ascendv2__Opportunity__c = newGift.Id;
        payment.ucinn_ascendv2__Designation_Detail__c = dd.Id;
       	payment.ucinn_ascendv2__Session__c = session.Id;
        payment.ucinn_ascendv2__External_System_ID__c = 'testing-123';
        payment.ucinn_ascendv2__Review_Transaction_v2__c = RTRec.Id;
        insert payment;

        ucinn_ascendv2__Hard_and_Soft_Credit__c credit = new ucinn_ascendv2__Hard_and_Soft_Credit__c();
        credit.ucinn_ascendv2__Contact__c = contactRec.Id;
        credit.ucinn_ascendv2__Opportunity__c = newGift.Id;
        credit.ucinn_ascendv2__Designation_Detail__c = dd.Id;
       	credit.ucinn_ascendv2__Session__c = session.Id;
		credit.ucinn_ascendv2__Credit_Type__c = 'Hard';
        credit.ucinn_ascendv2__Credit_Amount__c = 10;
        insert credit;
        
        Portal_Section_Field_Setting__mdt fullNameSetting = new Portal_Section_Field_Setting__mdt();
        fullNameSetting.Label = 'Name - Full Name Last Name';
        fullNameSetting.Field_API_Name__c = 'Name';
        fullNameSetting.Field_Type__c = 'text';
        fullNameSetting.Is_Display_On_Portal__c = true;
        fullNameSetting.Is_Disabled__c = false;
        fullNameSetting.Has_Toggle__c = true;
        //fullNameSetting.Filter_Value__c = 'ucinn_ascendv2__Type__c';
        //fullNameSetting.Filter_Field__c = 'Full Name';
        fullNameSetting.Front_End_Field_Label__c = 'Name';
        fullNameSetting.Field_Order_For_Duplicate_Logic__c = '1';
        fullNameSetting.Is_Create_New_Record__c = true;
        fullNameSetting.Is_Create_Staging_Record_On_Field_Change__c = true;
        //fullNameSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c';
        fullNameSetting.Static_Value_For_Staging_Field__c = '';
        fullNameSetting.Staging_Field_Population_Condition_Value__c = '';
        fullNameSetting.Front_End_Field_Id__c = 'Name';
        fullNameSetting.Front_End_Field_Only__c = false;
        fullNameSetting.Lookup_SObject_Name__c = '';
        fullNameSetting.Lookup_Filter_Clause__c = '';
        fullNameSetting.Lookup_Field_Name__c = '';
        fullNameSetting.Has_Report_Update_Link__c = true;
        
        Portal_Section_Field_Setting__mdt prefixSetting = new Portal_Section_Field_Setting__mdt();
        prefixSetting.Label = 'Name - Full Name Prefix';
        prefixSetting.Field_API_Name__c = 'ucinn_ascendv2__Prefix__c';
        prefixSetting.Field_Type__c = 'picklist';
        prefixSetting.Is_Display_On_Portal__c = true;
        prefixSetting.Is_Disabled__c = false;
        prefixSetting.Has_Toggle__c = true;
        prefixSetting.Filter_Value__c = 'ucinn_ascendv2__Type__c';
        prefixSetting.Filter_Field__c = 'Full Name';
        prefixSetting.Front_End_Field_Label__c = 'Prefix';
        prefixSetting.Field_Order_For_Duplicate_Logic__c = '1';
        prefixSetting.Is_Create_New_Record__c = true;
        prefixSetting.Is_Create_Staging_Record_On_Field_Change__c = true;
        prefixSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Prefix__c';
        prefixSetting.Static_Value_For_Staging_Field__c = '';
        prefixSetting.Staging_Field_Population_Condition_Value__c = '';
        prefixSetting.Front_End_Field_Id__c = 'prefix';
        prefixSetting.Front_End_Field_Only__c = false;
        prefixSetting.Lookup_SObject_Name__c = '';
        prefixSetting.Lookup_Filter_Clause__c = '';
        prefixSetting.Lookup_Field_Name__c = '';
        prefixSetting.Has_Report_Update_Link__c = true;
        
        Portal_Page_Section_Setting__mdt nameSetting = new Portal_Page_Section_Setting__mdt();
        nameSetting.Label = 'Online Giving - Designations Test';
        nameSetting.SObject_API_Name__c = 'ucinn_ascendv2__Designation__c';
        nameSetting.Staging_Record_Controlling_Parent_Field__c = '';
        //nameSetting.Controlling_Parent_Field_API_Name__c = 'ucinn_ascendv2__Contact__c';
        nameSetting.Page_Main_Section__c = 'Designations';
        nameSetting.Is_Display_Section__c = true;
        nameSetting.Is_Disabled__c = true;
        nameSetting.Is_Display_Toggle_On_Section__c = true;
        nameSetting.Is_Display_Toggle_Per_Record__c = true;
        nameSetting.Where_Clause__c = '';
        nameSetting.Order_By_Clause__c = '';
        nameSetting.Is_Create_Staging_Record_Upon_Edit__c = true;
        nameSetting.Is_Create_Staging_Record_Upon_Creation__c = true;
        nameSetting.Is_Create_Staging_Record_Using_Fields__c  = true;
        nameSetting.Create_Staging_Record_Condition_Field__c = '';
        nameSetting.Create_Staging_Record_Condition_Value__c = '';
        nameSetting.Create_Staging_Record_Condition_Operator__c = '';
        //nameSetting.Staging_sObject_API_Name__c = 'ucinn_ascendv2__Interim__c';
        nameSetting.Has_Duplicate_Logic__c = true;
        nameSetting.Has_Report_Update_Link__c = true;
        nameSetting.Duplicate_Field_Logic__c = '1';
        nameSetting.Inactive_Record_Field_Map__c = '';
        nameSetting.Active_Record_Field_Map__c = '';
        nameSetting.Is_Hard_Delete_Records__c = true;
        nameSetting.Staging_Record_Where_Clause__c = '';
        nameSetting.Page_Name__c = 'Online Giving';
        nameSetting.Max_Number_of_Query_Records__c = 1;
        nameSetting.Front_End_Section_Id__c = 'designations';
        nameSetting.Front_End_Section_Label__c = 'Name';
        nameSetting.Is_Child__c = false;
        nameSetting.Group_By_Clause__c = 'GROUP BY ucinn_ascendv2__X1_Academic_Org__r.ISUF_Portal_Academic_Org__c';
        nameSetting.SObject_Relationship_API_Name__c = '';
        nameSetting.Relationship_Wrapper_Id__c = '';
        Map<String, Object> nameSettingAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(nameSetting));
        nameSettingAsMap.put('Portal_Section_Field_Settings__r', new Map<String, Object>{'records' => new List<Portal_Section_Field_Setting__mdt>{fullNameSetting, prefixSetting}});
        nameSetting = (Portal_Page_Section_Setting__mdt) System.JSON.deserialize(System.JSON.serialize(nameSettingAsMap), Portal_Page_Section_Setting__mdt.class);
      
    }
    
	@IsTest
    public static void getAllContacts(){
        Map<String, Object> params =  new Map<String, Object>();
            params.put('PAGE_NAME', 'Online Giving');
            params.put('KEYWORD_KEY', 'keyword');
        Test.startTest();
        PORTAL_OnlineGivingCustomExtension.SERVER_getAllContacts(params);
        Test.stopTest();
    }    
    
    @IsTest
    public static void getSearchDesignations(){
        Map<String, Object> params =  new Map<String, Object>();
            params.put('pageName', 'Online Giving');
            params.put('keyword', 'College');
        	params.put('offset', 0);
        Test.startTest();
        PORTAL_OnlineGivingCustomExtension.searchDesignations(params);
        Test.stopTest();
    }    
    
    @IsTest
    public static void getDesignationsByCategory(){
        ucinn_ascendv2__Academic_Organization__c academicOrg = new ucinn_ascendv2__Academic_Organization__c();
        academicOrg.Name = 'Test Academic Org';
        insert academicOrg;
        
        ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
        designation.Name = 'Test Designation';
        designation.ucinn_portal_Is_Display_On_Portal__c = true;
        designation.ucinn_portal_Display_Order__c = '1';
        designation.ucinn_ascendv2__X1_Academic_Org__c = academicOrg.Id;
        insert designation;
        Map<String, Object> params =  new Map<String, Object>();
        params.put('pageName', 'Online Giving');
        
        Test.startTest();
        PORTAL_OnlineGivingCustomExtension.SERVER_getDesignationsByCategory(params);
        Test.stopTest();
    }  
    
    @IsTest
    public static void getDesignationsByCategoryNoPageName(){
        Map<String, Object> params =  new Map<String, Object>();
        
        Test.startTest();
        PORTAL_OnlineGivingCustomExtension.SERVER_getDesignationsByCategory(params);
        Test.stopTest();
    }  
    
    @IsTest
    public static void getSearchCategoryNoPageName(){
        Map<String, Object> params =  new Map<String, Object>();
        
        Test.startTest();
        PORTAL_OnlineGivingCustomExtension.searchDesignations(params);
        Test.stopTest();
    }  
    
    @IsTest
    public static void getDesignationsByCategoryMap(){
        ucinn_ascendv2__Academic_Organization__c academicOrg = new ucinn_ascendv2__Academic_Organization__c();
        academicOrg.Name = 'Test Academic Org';
        insert academicOrg;
        
        ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
        designation.Name = 'Test Designation';
        designation.ucinn_portal_Is_Display_On_Portal__c = true;
        designation.ucinn_portal_Display_Order__c = '1';
        designation.ucinn_ascendv2__X1_Academic_Org__c = academicOrg.Id;
        insert designation;
        
       	String query = 'SELECT Id, Name FROM ucinn_ascendv2__Designation__c';
        List<AggregateResult> designations = [SELECT ucinn_ascendv2__X1_Academic_Org__c FROM ucinn_ascendv2__Designation__c group by ucinn_ascendv2__X1_Academic_Org__c Limit 1];
        Portal_Page_Section_Setting__mdt sectionSetting = [SELECT Where_Clause__c, Order_By_Clause__c, Group_By_Clause__c,(SELECT Field_API_Name__c, Front_End_Field_Id__c FROM Portal_Section_Field_Settings__r)  FROM Portal_Page_Section_Setting__mdt Limit 1];
        system.debug('sectionSetting:: '+sectionSetting);
        Map<String, Object> params =  new Map<String, Object>();
            params.put('pageName', 'Online Giving');
            params.put('KEYWORD_KEY', 'keyword');
        	params.put('groupBy', 'ucinn_ascendv2__X1_Academic_Org__c');
        
        Test.startTest();
        PORTAL_OnlineGivingCustomExtension.createDesignationCategoryMap(designations,sectionSetting);
        Test.stopTest();
    }    
    
    @IsTest
    public static void getDonorId(){
        Map<String, Object> params =  new Map<String, Object>();
            params.put('PAGE_NAME', 'Online Giving');
            params.put('KEYWORD_KEY', 'keyword');
        Test.startTest();
        PORTAL_OnlineGivingCustomExtension.SERVER_getDonorIdConstituentInformation(params);
        Test.stopTest();
    }  

    @isTest
    public static void testServer_CreateReviewTransaction(){
        Map<String, Object> params =  new Map<String, Object>();
            params.put('PAGE_NAME', 'Online Giving');
            params.put('KEYWORD_KEY', 'keyword');
        Test.startTest();
        try{
            PORTAL_OnlineGivingCustomExtension.Server_CreateReviewTransaction(params);
        }catch(Exception ex){

        }
        
        Test.stopTest();
    }  
    
}