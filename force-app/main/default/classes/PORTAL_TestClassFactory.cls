public inherited sharing virtual class PORTAL_TestClassFactory {
    public static final String APEX_TEST_CLASS_FACTORY_NAME = 'Apex_Test_Class_Factory_Name';
    public static final String ID_CONST = 'Id';
    public static final String VALUE_FIELD = 'Value__c';
    public static final String PORTAL_ORGANIZATION_SETTINGS_CMT = 'Portal_Organization_Setting__mdt';

    public virtual PORTAL_ActionOnContentBaseTest.TestClass getActionOnContentBaseTestClass() {
        return new PORTAL_ActionOnContentBaseTest.TestClass();
    }

    public virtual PORTAL_ActionOnContentControllerTest.TestClass getActionOnContentControllerTestClass(){
        return new PORTAL_ActionOnContentControllerTest.TestClass();
    }

    public virtual PORTAL_AddressWrapperTest.TestClass getAddressWrapperTestClass(){
        return new PORTAL_AddressWrapperTest.TestClass();
    }

    public virtual PORTAL_API_ConstantContactTest.TestClass getAPIConstantContactTestClass(){
        return new PORTAL_API_ConstantContactTest.TestClass();
    }

    public virtual PORTAL_API_EmailHubBaseTest.TestClass getAPIEmailHubBaseTestClass(){
        return new PORTAL_API_EmailHubBaseTest.TestClass();
    }

    public virtual PORTAL_API_MailGunTest.TestClass getMailGunTestClass(){
        return new PORTAL_API_MailGunTest.TestClass();
    }

    public virtual PORTAL_API_TestEmailApiTest.TestClass getTestEmailApiTestClass(){
        return new PORTAL_API_TestEmailApiTest.TestClass();
    }

    public virtual PORTAL_ArcGisApiTest.TestClass getArcGisApiTestClass(){
        return new PORTAL_ArcGisApiTest.TestClass();
    }

    public virtual PORTAL_BATCH_AddressGeocodingTest.TestClass getAddressGeocodingTestClass(){
        return new PORTAL_BATCH_AddressGeocodingTest.TestClass();
    }

    public virtual PORTAL_BATCH_AddZoneMembershipsTest.TestClass getAddZoneMembershipTestClass(){
        return new PORTAL_BATCH_AddZoneMembershipsTest.TestClass();
    }
    //^^10
    public virtual PORTAL_BATCH_DeleteJobApplicationsTest.TestClass getDeleteJobApplicationsTestClass(){
        return new PORTAL_BATCH_DeleteJobApplicationsTest.TestClass();
    }

    public virtual PORTAL_BATCH_DeleteNewsletterTagTest.TestClass getDeleteNewsletterTagTestClass(){
        return new PORTAL_BATCH_DeleteNewsletterTagTest.TestClass();
    }

    public virtual PORTAL_BATCH_EmailApiContactsTest.TestClass getEmailApiContactsTestClass(){
        return new PORTAL_BATCH_EmailApiContactsTest.TestClass();
    }

    public virtual PORTAL_BATCH_EmailApiZonesTest.TestClass getEmailApiZonesTestClass(){
        return new PORTAL_BATCH_EmailApiZonesTest.TestClass();
    }

    public virtual PORTAL_BATCH_EventWaitlistDeletionTest.TestClass getEventWaitlistDeletionTestClass(){
        return new PORTAL_BATCH_EventWaitlistDeletionTest.TestClass();
    }

    public virtual PORTAL_BATCH_NewsletterCampaignTest.TestClass getNewsletterCampaignTestClass(){
        return new PORTAL_BATCH_NewsletterCampaignTest.TestClass();
    }

    public virtual PORTAL_BATCH_NewsletterFilterTest.TestClass getNewsletterFilterTestClass(){
        return new PORTAL_BATCH_NewsletterFilterTest.TestClass();
    }

    public virtual PORTAL_BATCH_NewUserCreationTest.TestClass getNewUserCreationTestClass(){
        return new PORTAL_BATCH_NewUserCreationTest.TestClass();
    }

    public virtual PORTAL_BATCH_PopulateFYContributionTest.TestClass getPopulateFYContributionTestClass(){
        return new PORTAL_BATCH_PopulateFYContributionTest.TestClass();
    }

    public virtual PORTAL_BATCH_RegistrationSessionCUTest.TestClass getRegistrationSessionCUTest(){
        return new PORTAL_BATCH_RegistrationSessionCUTest.TestClass();
    }
    // ^20

    public virtual PORTAL_BATCH_SendNewsletterTest.TestClass getSendNewsletterTestClass(){
        return new PORTAL_BATCH_SendNewsletterTest.TestClass();
    }

    public virtual PORTAL_BATCH_SendVolunteerEmailsTest.TestClass getSendVolunteerEmailsTestClass(){
        return new PORTAL_BATCH_SendVolunteerEmailsTest.TestClass();
    }

    public virtual PORTAL_BATCH_UpdateNewsletterMetricsTest.TestClass getUpdateNewsletterMetricsTestClass(){
        return new PORTAL_BATCH_UpdateNewsletterMetricsTest.TestClass();
    }

    public virtual PORTAL_BATCH_VolunteerReminderEmailsTest.TestClass getVolunteerReminderEmailsTestClass(){
        return new PORTAL_BATCH_VolunteerReminderEmailsTest.TestClass();
    }

    public virtual PORTAL_CommunityUserControllerTest.TestClass getCommunityUserControllerTestClass(){
        return new PORTAL_CommunityUserControllerTest.TestClass();
    }

    public virtual PORTAL_CommunityUtilsTest.TestClass getCommunityUtilsTestClass(){
        return new PORTAL_CommunityUtilsTest.TestClass();
    }

    public virtual PORTAL_ContentSubmissionCtrlBaseTest.TestClass getContentSubmissionCtrlBaseTestClass(){
        return new PORTAL_ContentSubmissionCtrlBaseTest.TestClass();
    }

    public virtual PORTAL_CybersourcePaymentGatewayTest.TestClass getCybersourcePaymentGatewayTestClass(){
        return new PORTAL_CybersourcePaymentGatewayTest.TestClass();
    }

    public virtual PORTAL_DirectoryControllerBaseTest.TestClass getDirectoryControllerBaseTestClass(){
        return new PORTAL_DirectoryControllerBaseTest.TestClass();
    }

    public virtual PORTAL_DirectorySearchTest.TestClass getDirectorySearchTestClass(){
        return new PORTAL_DirectorySearchTest.TestClass();
    }
// ^^30
    public virtual PORTAL_DMLWrapperTest.TestClass getDMLWrapperTestClass(){
        return new PORTAL_DMLWrapperTest.TestClass();
    }

    public virtual PORTAL_ErrorEmailHandlerTest.TestClass getErrorEmailHandlerTestClass(){
        return new PORTAL_ErrorEmailHandlerTest.TestClass();
    }

    public virtual PORTAL_EventManagementControllerBaseTest.TestClass getEventManagementControllerBaseTestClass(){
        return new PORTAL_EventManagementControllerBaseTest.TestClass();
    }

    public virtual PORTAL_EventRegistrationCtrlBaseTest.TestClass getEventRegistrationCtrlBaseTestClass(){
        return new PORTAL_EventRegistrationCtrlBaseTest.TestClass();
    }

    public virtual PORTAL_EventWaitlistCtrlBaseTest.TestClass getEventWaitlistCtrlBaseTestClass(){
        return new PORTAL_EventWaitlistCtrlBaseTest.TestClass();
    }

    public virtual PORTAL_GeolocationHubTest.TestClass getGeolocationHubTestClass(){
        return new PORTAL_GeolocationHubTest.TestClass();
    }

    public virtual PORTAL_GivingHistoryControllersTest.TestClass getGivingHistoryControllersTestClass(){
        return new PORTAL_GivingHistoryControllersTest.TestClass();
    }

    public virtual PORTAL_GivingSocietiesControllerBaseTest.TestClass getGivingSocietiesControllerBaseTestClass(){
        return new PORTAL_GivingSocietiesControllerBaseTest.TestClass();
    }

    public virtual PORTAL_GivingSocietiesControllerTest.TestClass getGivingSocietiesControllerTestClass(){
        return new PORTAL_GivingSocietiesControllerTest.TestClass();
    }

    public virtual PORTAL_GoogleGeocodingApiTest.TestClass getGoogleGeocodingApiTestClass(){
        return new PORTAL_GoogleGeocodingApiTest.TestClass();
    }
    //^^40
    public virtual PORTAL_HEP_ApiRepositoryTest.TestClass getHepApiRepositoryTestClass(){
        return new PORTAL_HEP_ApiRepositoryTest.TestClass();
    }

    public virtual PORTAL_HonorRollControllerBaseTest.TestClass getHonorRollControllerBaseTestClass(){
        return new PORTAL_HonorRollControllerBaseTest.TestClass();
    }

    public virtual PORTAL_JobBoardControllerBaseTest.TestClass getJobBoardControllerBaseTestClass(){
        return new PORTAL_JobBoardControllerBaseTest.TestClass();
    }

    public virtual PORTAL_JobBoardControllerTest.TestClass getJobBoardControllerTestClass(){
        return new PORTAL_JobBoardControllerTest.TestClass();
    }

    public virtual PORTAL_ListingChangeStatusCtrlTest.TestClass getListingChangeStatusCtrlTestClass(){
        return new PORTAL_ListingChangeStatusCtrlTest.TestClass();
    }

    public virtual PORTAL_ListingControllerBaseTest.TestClass getListingControllerBaseTestClass(){
        return new PORTAL_ListingControllerBaseTest.TestClass();
    }

    public virtual PORTAL_ListingCreateDraftCtrlTest.TestClass getListingCreateDraftCtrlTestClass(){
        return new PORTAL_ListingCreateDraftCtrlTest.TestClass();
    }

    public virtual PORTAL_LWC_ContentSubmissionCtrlTest.TestClass getLwcContentSubmissionCtrlTestClass(){
        return new PORTAL_LWC_ContentSubmissionCtrlTest.TestClass();
    }

    public virtual PORTAL_LWC_EditContentModuleCtrlTest.TestClass getLwcEditContentModuleCtrlTestClass(){
        return new PORTAL_LWC_EditContentModuleCtrlTest.TestClass();
    }

    public virtual PORTAL_LWC_EventManagementControllerTest.TestClass getLwcEventManagementControllerTestClass(){
        return new PORTAL_LWC_EventManagementControllerTest.TestClass();
    }
    // ^^50
    public virtual PORTAL_LWC_EventRegistrationCtrlTest.TestClass getLwcEventRegistrationCtrlTestClass(){
        return new PORTAL_LWC_EventRegistrationCtrlTest.TestClass();
    }

    public virtual PORTAL_LWC_EventWaitlistFormCtrlTest.TestClass getLwcEventWaitlistFormCtrlTestClass(){
        return new PORTAL_LWC_EventWaitlistFormCtrlTest.TestClass();
    }

    public virtual PORTAL_LWC_HonorRollControllerTest.TestClass getLwcHonorRollControllerTestClass(){
        return new PORTAL_LWC_HonorRollControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_ListingControllerTest.TestClass getLwcListingControllerTestClass(){
        return new PORTAL_LWC_ListingControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_ListingSearchControllerTest.TestClass getLwcListingSearchControllerTestClass(){
        return new PORTAL_LWC_ListingSearchControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_MassEmailVolunteersTest.TestClass getLwcMassEmailVolunteersTestClass(){
        return new PORTAL_LWC_MassEmailVolunteersTest.TestClass();
    }

    public virtual PORTAL_LWC_MembershipControllerTest.TestClass getLwcMembershipControllerTestClass(){
        return new PORTAL_LWC_MembershipControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_MembershipPurchaseCtrlTest.TestClass getLwcMembershipPurchaseCtrlTestClass(){
        return new PORTAL_LWC_MembershipPurchaseCtrlTest.TestClass();
    }

    public virtual PORTAL_LWC_MyInformationV2ControllerTest.TestClass getLwcMyInfoV2ControllerTestClass(){
        return new PORTAL_LWC_MyInformationV2ControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_NewsletterControllerTest.TestClass getLwcNewsletterControllerTestClass(){
        return new PORTAL_LWC_NewsletterControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_PaymentHubControllerTest.TestClass getLwcPaymentHubControllerTestClass(){
        return new PORTAL_LWC_PaymentHubControllerTest.TestClass();
    }
    //^^60^^
    public virtual PORTAL_LWC_ShoppingCartControllerTest.TestClass getLwcShoppingCartControllerTestClass(){
        return new PORTAL_LWC_ShoppingCartControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_StaticContentControllerTest.TestClass getLwcStaticContentControllerTestClass(){
        return new PORTAL_LWC_StaticContentControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_SubmittedContentCtrlTest.TestClass getLwcSubmittedContentCtrlTestClass(){
        return new PORTAL_LWC_SubmittedContentCtrlTest.TestClass();
    }

    public virtual PORTAL_LWC_VolunteerControllerTest.TestClass getLwcVolunteerControllerTestClass(){
        return new PORTAL_LWC_VolunteerControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_VolunteerEditFormTest.TestClass getLwcVolunteerEditFormTestClass(){
        return new PORTAL_LWC_VolunteerEditFormTest.TestClass();
    }

    public virtual PORTAL_LWC_VolunteerInformationTest.TestClass getLwcVolunteerInformationTestClass(){
        return new PORTAL_LWC_VolunteerInformationTest.TestClass();
    }

    public virtual PORTAL_LWC_VolunteerReminderEmailTest.TestClass getLwcVolunteerReminderEmailTestClass(){
        return new PORTAL_LWC_VolunteerReminderEmailTest.TestClass();
    }

    public virtual PORTAL_LWC_VolunteerReportHoursFormTest.TestClass getLwcVolunteerReportHoursFormTestClass(){
        return new PORTAL_LWC_VolunteerReportHoursFormTest.TestClass();
    }

    public virtual PORTAL_LWC_VolunteerSuggestionsTest.TestClass getLwcVolunteerSuggestionsTestClass(){
        return new PORTAL_LWC_VolunteerSuggestionsTest.TestClass();
    }

    public virtual PORTAL_LWC_VolunteerTableCtrlTest.TestClass getLwcVolunteerTableCtrlTestClass(){
        return new PORTAL_LWC_VolunteerTableCtrlTest.TestClass();
    }
    //^^70
    public virtual PORTAL_MembershipControllerTest.TestClass getMembershipControllerTestClass(){
        return new PORTAL_MembershipControllerTest.TestClass();
    }

    public virtual PORTAL_ML_PossibilityCalculationTest.TestClass getMlPossibilityCalculationTestClass(){
        return new PORTAL_ML_PossibilityCalculationTest.TestClass();
    }

    public virtual PORTAL_MyGivingHistoryControllerBaseTest.TestClass getMyGivingHistoryControllerBaseTestClass(){
        return new PORTAL_MyGivingHistoryControllerBaseTest.TestClass();
    }

    public virtual PORTAL_MyInformationControllerBaseTest.TestClass getMyInformationControllerBaseTestClass(){
        return new PORTAL_MyInformationControllerBaseTest.TestClass();
    }

    public virtual PORTAL_MyInformationControllerTest.TestClass getMyInformationControllerTestClass(){
        return new PORTAL_MyInformationControllerTest.TestClass();
    }

    public virtual PORTAL_MyInformationViewControllerTest.TestClass getMyInformationViewControllerTestClass(){
        return new PORTAL_MyInformationViewControllerTest.TestClass();
    }

    public virtual PORTAL_NewsletterControllerBaseTest.TestClass getNewsletterControllerBaseTestClass(){
        return new PORTAL_NewsletterControllerBaseTest.TestClass();
    }

    public virtual PORTAL_NewsletterControllerTest.TestClass getNewsletterControllerTestClass(){
        return new PORTAL_NewsletterControllerTest.TestClass();
    }

    public virtual PORTAL_OnlineGivingControllerTest.TestClass getOnlineGivingControllerTestClass(){
        return new PORTAL_OnlineGivingControllerTest.TestClass();
    }

    public virtual PORTAL_PageSectionAdapterTest.TestClass getPageSectionAdapterTestClass(){
        return new PORTAL_PageSectionAdapterTest.TestClass();
    }

    public virtual PORTAL_PageSectionElementGeneratorTest.TestClass getPageSectionElementGeneratorTestClass(){
        return new PORTAL_PageSectionElementGeneratorTest.TestClass();
    }
    // 80
    public virtual PORTAL_PageSectionFormSubmitterTest.TestClass getPageSectionFormSubmitterTestClass(){
        return new PORTAL_PageSectionFormSubmitterTest.TestClass();
    }

    public virtual PORTAL_PaymentHubControllerBaseTest.TestClass getPaymentHubControllerBaseTestClass(){
        return new PORTAL_PaymentHubControllerBaseTest.TestClass();
    }

    public virtual PORTAL_RecordNameUpdaterTest.TestClass getPortalRecordNameUpdaterTestClass(){
        return new PORTAL_RecordNameUpdaterTest.TestClass();
    }

    public virtual PORTAL_ProcessInterimEmploymentTest.TestClass getProcessInterimEmploymentTestClass(){
        return new PORTAL_ProcessInterimEmploymentTest.TestClass();
    }

    public virtual PORTAL_ProfilePictureControllerTest.TestClass getProfilePictureControllerTestClass(){
        return new PORTAL_ProfilePictureControllerTest.TestClass();
    }

    public virtual PORTAL_SearchFilterCacheUpdaterTest.TestClass getSearchFilterCacheUpdaterTestClass(){
        return new PORTAL_SearchFilterCacheUpdaterTest.TestClass();
    }

    public virtual PORTAL_ShoppingCartControllerBaseTest.TestClass getShoppingCartControllerBaseTestClass(){
        return new PORTAL_ShoppingCartControllerBaseTest.TestClass();
    }

    public virtual PORTAL_SObjectInfoPoolTest.TestClass getSObjectInfoPoolTestClass(){
        return new PORTAL_SObjectInfoPoolTest.TestClass();
    }

    public virtual PORTAL_SObjectWrapperTest.TestClass getSObjectWrapperTestClass(){
        return new PORTAL_SObjectWrapperTest.TestClass();
    }

    public virtual PORTAL_SocialLoginControllerTest.TestClass getSocialLoginControllerTestClass(){
        return new PORTAL_SocialLoginControllerTest.TestClass();
    }

    public virtual PORTAL_SpreedlyPaymentGatewayTest.TestClass getSpreedlyPaymentGatewayTestClass(){
        return new PORTAL_SpreedlyPaymentGatewayTest.TestClass();
    }
    //^^90
    public virtual PORTAL_StaticContentControllerBaseTest.TestClass getStaticContentControllerBaseTestClass(){
        return new PORTAL_StaticContentControllerBaseTest.TestClass();
    }

    public virtual PORTAL_StripePaymentGatewayTest.TestClass getStripePaymentGatewayTestClass(){
        return new PORTAL_StripePaymentGatewayTest.TestClass();
    }

    public virtual PORTAL_StripePaymentElementGatewayTest.TestClass getStripePaymentElementGatewayTestClass(){
        return new PORTAL_StripePaymentElementGatewayTest.TestClass();
    }

    public virtual PORTAL_StripeWebhookTest.TestClass getStripeWebhookTestClass(){
        return new PORTAL_StripeWebhookTest.TestClass();
    }

    public virtual PORTAL_TRIG_ActionOnContentHandlerTest.TestClass getTRIG_ActionOnContentHandlerTestClass(){
        return new PORTAL_TRIG_ActionOnContentHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_AffiliationHandlerTest.TestClass getTRIG_AffiliationHandlerTestClass(){
        return new PORTAL_TRIG_AffiliationHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_CaseHandlerTest.TestClass getTRIG_CaseHandlerTestClass(){
        return new PORTAL_TRIG_CaseHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_CaseTest.TestClass getTRIG_CaseTestClass(){
        return new PORTAL_TRIG_CaseTest.TestClass();
    }

    public virtual PORTAL_TRIG_ContactHandlerTest.TestClass getTRIG_ContactHandlerTestClass(){
        return new PORTAL_TRIG_ContactHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_DegreeInfoHandlerTest.TestClass getTRIG_DegreeInfoHandlerTestClass(){
        return new PORTAL_TRIG_DegreeInfoHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_EventWaitlistEntryTest.TestClass getTRIG_EventWaitlistEntryTestClass(){
        return new PORTAL_TRIG_EventWaitlistEntryTest.TestClass();
    }

    public virtual PORTAL_TRIG_JobHandlerTest.TestClass getTRIG_JobHandlerTestClass(){
        return new PORTAL_TRIG_JobHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_ListingHandlerTest.TestClass getTRIG_ListingHandlerTestClass(){
        return new PORTAL_TRIG_ListingHandlerTest.TestClass();
    }
    //^^100
    public virtual PORTAL_TRIG_SocietyMembershipHandlerTest.TestClass getTRIG_SocietyMembershipHandlerTestClass(){
        return new PORTAL_TRIG_SocietyMembershipHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_TicketTypeHandlerTest.TestClass getTRIG_TicketTypeHandlerTestClass(){
        return new PORTAL_TRIG_TicketTypeHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_VolunteerHandlerTest.TestClass getTRIG_VolunteerHandlerTestClass(){
        return new PORTAL_TRIG_VolunteerHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_VolunteerJobHandlerTest.TestClass getTRIG_VolunteerJobHandlerTestClass(){
        return new PORTAL_TRIG_VolunteerJobHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_VolunteerShiftHandlerTest.TestClass getTRIG_VolunteerShiftHandlerTestClass(){
        return new PORTAL_TRIG_VolunteerShiftHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_ZoneHandlerTest.TestClass getTRIG_ZoneHandlerTestClass(){
        return new PORTAL_TRIG_ZoneHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_ZoneMembershipHandlerTest.TestClass getTRIG_ZoneMembershipHandlerTestClass(){
        return new PORTAL_TRIG_ZoneMembershipHandlerTest.TestClass();
    }

    public virtual PORTAL_UTIL_DocumentImageHelperTest.TestClass getUTIL_DocumentImageHelperTestClass(){
        return new PORTAL_UTIL_DocumentImageHelperTest.TestClass();
    }

    public virtual PORTAL_UTIL_EventsTest.TestClass getUTIL_EventsTestClass(){
        return new PORTAL_UTIL_EventsTest.TestClass();
    }

    public virtual PORTAL_UTIL_GivingURLSettingTest.TestClass getUTIL_GivingURLSettingTestClass(){
        return new PORTAL_UTIL_GivingURLSettingTest.TestClass();
    }
    //^^110

    public virtual PORTAL_UTIL_HonorRollTest.TestClass getUTIL_HonorRollTestClass(){
        return new PORTAL_UTIL_HonorRollTest.TestClass();
    }

    public virtual PORTAL_UTIL_PageSectionSettingTest.TestClass getUTIL_PageSectionSettingTestClass(){
        return new PORTAL_UTIL_PageSectionSettingTest.TestClass();
    }

    public virtual PORTAL_UTIL_RecipientsTest.TestClass getUTIL_RecipientsTestClass(){
        return new PORTAL_UTIL_RecipientsTest.TestClass();
    }

    public virtual PORTAL_UTIL_TestClassUtilTest.TestClass getUTIL_TestClassUtilTestClass(){
        return new PORTAL_UTIL_TestClassUtilTest.TestClass();
    }

    public virtual PORTAL_UTIL_VolunteersTest.TestClass getUTIL_VolunteersTestClass(){
        return new PORTAL_UTIL_VolunteersTest.TestClass();
    }

    public virtual PORTAL_UtilsTest.TestClass getUtilsTestClass(){
        return new PORTAL_UtilsTest.TestClass();
    }

    public virtual PORTAL_VF_GiftReceiptControllerTest.TestClass getVF_GiftReceiptControllerTestClass(){
        return new PORTAL_VF_GiftReceiptControllerTest.TestClass();
    }

    public virtual PORTAL_VF_YearEndTaxReceiptTest.TestClass getVF_YearEndTaxReceiptTestClass(){
        return new PORTAL_VF_YearEndTaxReceiptTest.TestClass();
    }

    public virtual PORTAL_VolunteerControllerBaseTest.TestClass getVolunteerControllerBaseTestClass(){
        return new PORTAL_VolunteerControllerBaseTest.TestClass();
    }

    public virtual PORTAL_ZoneControllerBaseTest.TestClass getZoneControllerBaseTestClass(){
        return new PORTAL_ZoneControllerBaseTest.TestClass();
    }
    //^^120
    public virtual PORTAL_ZoneMembershipControllerTest.TestClass getZoneMembershipControllerTestClass(){
        return new PORTAL_ZoneMembershipControllerTest.TestClass();
    }

    public virtual PORTAL_UTIL_DataCreationTest.TestClass getUTIL_DataCreationTestClass(){
        return new PORTAL_UTIL_DataCreationTest.TestClass();
    }

    public virtual PORTAL_ZoneMemTableControllerBaseTest.TestClass getZoneMembershipTableControllerBaseTestClass() {
        return new PORTAL_ZoneMemTableControllerBaseTest.TestClass();
    }

    public virtual PORTAL_ZoneSearchControllerBaseTest.TestClass getZoneSearchControllerBaseTestClass() {
        return new PORTAL_ZoneSearchControllerBaseTest.TestClass();
    }

    public virtual PORTAL_LWC_ZoneSearchControllerTest.TestClass getLwcZoneSearchControllerTestClass() {
        return new PORTAL_LWC_ZoneSearchControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_ZoneControllerTest.TestClass getLwcZoneControllerTestClass() {
        return new PORTAL_LWC_ZoneControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_ZoneMemTableControllerTest.TestClass getLwcZoneMemTableControllerTestClass() {
        return new PORTAL_LWC_ZoneMemTableControllerTest.TestClass();
    }

    public virtual PORTAL_UTIL_ListingTest.TestClass getUTIL_ListingTestClass() {
        return new PORTAL_UTIL_ListingTest.TestClass();
    }

    public virtual PORTAL_UTIL_CommunityUserTest.TestClass getUTIL_CommunityUserTestClass() {
        return new PORTAL_UTIL_CommunityUserTest.TestClass();
    }

    public virtual PORTAL_BATCH_DeleteTemporaryListingsTest.TestClass getBatchDeleteTemporaryListingsTestClass() {
        return new PORTAL_BATCH_DeleteTemporaryListingsTest.TestClass();
    }
    //^^130
    public virtual PORTAL_BATCH_InitializeDirCacheTest.TestClass getBatchInitializeDirCacheTestClass() {
        return new PORTAL_BATCH_InitializeDirCacheTest.TestClass();
    }

    public virtual PORTAL_BATCH_MLRecommendationCalcTest.TestClass getBatchMLRecommendationCalcTestClass() {
        return new PORTAL_BATCH_MLRecommendationCalcTest.TestClass();
    }

    public virtual PORTAL_CyberSourceFormControllerTest.TestClass getCyberSourceFormControllerTestClass() {
        return new PORTAL_CyberSourceFormControllerTest.TestClass();
    }

    public virtual PORTAL_DirectoryDatabaseCacheTest.TestClass getDirectoryDatabaseCacheTestClass() {
        return new PORTAL_DirectoryDatabaseCacheTest.TestClass();
    }

    public virtual PORTAL_LoginFormControllerTest.TestClass getPortalLoginFormControllerTestClass() {
        return new PORTAL_LoginFormControllerTest.TestClass();
    }

    public virtual PORTAL_LookupControllerTest.TestClass getLookupControllerTestClass() {
        return new PORTAL_LookupControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_DirectoryControllerTest.TestClass getLwcDirectoryControllerTestClass() {
        return new PORTAL_LWC_DirectoryControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_DirectoryProfileCtrlTest.TestClass getLwcDirectoryProfileCtrlTestClass() {
        return new PORTAL_LWC_DirectoryProfileCtrlTest.TestClass();
    }

    public virtual PORTAL_LWC_ListingDetailControllerTest.TestClass getLwcListingDetailControllerTestClass() {
        return new PORTAL_LWC_ListingDetailControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_LookupControllerTest.TestClass getLwcLookupControllerTestClass() {
        return new PORTAL_LWC_LookupControllerTest.TestClass();
    }
    //^^140
    public virtual PORTAL_SCHEDULER_DeleteJobAppTest.TestClass getSchedulerDeleteJobAppTestClass() {
        return new PORTAL_SCHEDULER_DeleteJobAppTest.TestClass();
    }

    public virtual PORTAL_SCHEDULER_InstallmentPaymentTest.TestClass getSchedulerInstallmentPaymentTestClass() {
        return new PORTAL_SCHEDULER_InstallmentPaymentTest.TestClass();
    }

    public virtual PORTAL_SCHEDULER_InterimEmploymentTest.TestClass getSchedulerInterimEmploymentTestClass() {
        return new PORTAL_SCHEDULER_InterimEmploymentTest.TestClass();
    }

    public virtual PORTAL_SCHEDULER_MLRecommendationEngTest.TestClass getSchedulerMLRecommendationEngTestClass() {
        return new PORTAL_SCHEDULER_MLRecommendationEngTest.TestClass();
    }

    public virtual PORTAL_SCHEDULER_NewUserCreationTest.TestClass getSchedulerNewUserCreationTestClass() {
        return new PORTAL_SCHEDULER_NewUserCreationTest.TestClass();
    }

    public virtual PORTAL_SCHEDULER_RecurringGiftPayTest.TestClass getSchedulerRecurringGiftPayTestClass() {
        return new PORTAL_SCHEDULER_RecurringGiftPayTest.TestClass();
    }

    public virtual PORTAL_SpreedlyACHFormControllerTest.TestClass getSpreedlyACHFormControllerTestClass() {
        return new PORTAL_SpreedlyACHFormControllerTest.TestClass();
    }

    public virtual PORTAL_SpreedlyCreditCardFormCtrlTest.TestClass getSpreedlyCreditCardFormCtrlTestClass() {
        return new PORTAL_SpreedlyCreditCardFormCtrlTest.TestClass();
    }

    public virtual PORTAL_StripeCreditCardFormCtrlTest.TestClass getStripeCreditCardFormCtrlTestClass() {
        return new PORTAL_StripeCreditCardFormCtrlTest.TestClass();
    }

    public virtual PORTAL_DonorStoriesControllerTest.TestClass getDonorStoriesControllerTestClass() {
        return new PORTAL_DonorStoriesControllerTest.TestClass();
    }
    //^^150
    public virtual PORTAL_LookupControllerBaseTest.TestClass getLookupControllerBaseTestClass() {
        return new PORTAL_LookupControllerBaseTest.TestClass();
    }

    public virtual PORTAL_XmlParserTest.TestClass getXmlParserTestClass() {
        return new PORTAL_XmlParserTest.TestClass();
    }

    public virtual PORTAL_FormSubmitterTest.TestClass getFormSubmitterTestClass() {
        return new PORTAL_FormSubmitterTest.TestClass();
    }

    public virtual PORTAL_TRIG_UserHandlerTest.TestClass getTrigUserHandlerTestClass() {
        return new PORTAL_TRIG_UserHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_NewsletterSectionHandlerTest.TestClass getTrigNewsletterSectionHandlerTestClass() {
        return new PORTAL_TRIG_NewsletterSectionHandlerTest.TestClass();
    }

    public virtual PORTAL_TRIG_ContentDocumentLinkHdlrTest.TestClass getTrigContentDocumentLinkHdlrTestClass() {
        return new PORTAL_TRIG_ContentDocumentLinkHdlrTest.TestClass();
    }

    public virtual PORTAL_FormRowWrapperTest.TestClass getFormRowWrapperTestClass() {
        return new PORTAL_FormRowWrapperTest.TestClass();
    }

    public virtual PORTAL_SearchCriteriaTest.TestClass getSearchCriteriaTestClass() {
        return new PORTAL_SearchCriteriaTest.TestClass();
    }

    public virtual PORTAL_FormWrapperTest.TestClass getFormWrapperTestClass() {
        return new PORTAL_FormWrapperTest.TestClass();
    }

    public virtual PORTAL_UTIL_TrigHandlerCreationTest.TestClass getPortalUtilTrigHandlerCreationTestClass() {
        return new PORTAL_UTIL_TrigHandlerCreationTest.TestClass();
    }
    
    public virtual PORTAL_UTIL_GivingTest.TestClass getUTIL_GivingTestClass() {
        return new PORTAL_UTIL_GivingTest.TestClass();
    }

    public virtual PORTAL_RecaptchaControllerTest.TestClass getPortalRecaptchaControllerTestClass() {
        return new PORTAL_RecaptchaControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_RecaptchaControllerTest.TestClass getLwcRecaptchaControllerTestClass() {
        return new PORTAL_LWC_RecaptchaControllerTest.TestClass();
    }

    public virtual PORTAL_DoubleTheDonationControllerTest.TestClass getDoubleTheDonationControllerTestClass() {
        return new PORTAL_DoubleTheDonationControllerTest.TestClass();
    }
    
    public virtual PORTAL_ApplePayControllerTest.TestClass getApplePayControllerTestClass() {
        return new PORTAL_ApplePayControllerTest.TestClass();
    }

    public virtual PORTAL_LWC_AddressServiceHubCtrlTest.TestClass getLwcAddressServiceHubCtrlTestClass() {
        return new PORTAL_LWC_AddressServiceHubCtrlTest.TestClass();
    }

    public virtual PORTAL_AddressServiceHubCtrlBaseTest.TestClass getAddressServiceHubCtrlBaseTestClass() {
        return new PORTAL_AddressServiceHubCtrlBaseTest.TestClass();
    }

    public virtual PORTAL_SmartyStreetsAddressServiceTest.TestClass getSmartyStreetsAddressServiceTestClass() {
        return new PORTAL_SmartyStreetsAddressServiceTest.TestClass();
    }

    public virtual PORTAL_AutocompleteAddressWrapperTest.TestClass getAutocompleteAddressWrapperTestClass() {
        return new PORTAL_AutocompleteAddressWrapperTest.TestClass();
    }

    public virtual PORTAL_GlobalAttributesTest.TestClass getGlobalAttributesTestClass() {
        return new PORTAL_GlobalAttributesTest.TestClass();
    }

    public virtual PORTAL_TouchNetPaymentGatewayTest.TestClass getTouchNetPaymentGatewayTestClass() {
        return new PORTAL_TouchNetPaymentGatewayTest.TestClass();
    }

    public virtual PORTAL_MyInformationEditCtrlBaseTest.TestClass getMyInformationEditCtrlBaseTestClass() {
        return new PORTAL_MyInformationEditCtrlBaseTest.TestClass();
    }

    public virtual PORTAL_MyInfoSaveTest.TestClass getMyInfoSaveTestClass() {
        return new PORTAL_MyInfoSaveTest.TestClass();
    }

    public virtual PORTAL_LWC_FileDownloadControllerTest.TestClass getLwcFileDownloadControllerTestClass() {
        return new PORTAL_LWC_FileDownloadControllerTest.TestClass();
    }

    public virtual PORTAL_TRIG_DownloadableContentTest.TestClass getTRIG_DownloadableContentTestClass() {
        return new PORTAL_TRIG_DownloadableContentTest.TestClass();
    }

    public static PORTAL_TestClassFactory getTestClassFactory() {
        List<Portal_Organization_Setting__mdt> portalOrganizationSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{ID_CONST, VALUE_FIELD},
            PORTAL_Utils.SOBJECT_NAME => PORTAL_ORGANIZATION_SETTINGS_CMT,
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{APEX_TEST_CLASS_FACTORY_NAME}
        });

        if (portalOrganizationSettingList == null || portalOrganizationSettingList.isEmpty()) {
            return new PORTAL_TestClassFactory();
        } else {
            Type testClassFactoryType = Type.forName(portalOrganizationSettingList.get(0).Value__c);

            return (PORTAL_TestClassFactory)testClassFactoryType.newInstance();
        }
    }

}