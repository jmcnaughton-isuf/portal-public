global inherited sharing class PORTAL_API_TestEmailApi extends PORTAL_EmailInterface  {

    //this class implements all the email interface functions and either does nothing in each

    global override Boolean isTransactionalEmailAPI(Map<String, Object> params) { return false; }

    global override void performDML(Map<String, Object> params) { }

    global override void updateMetrics(Map<String, Object> params) { }

    global override String getUnsubscribeUrl(Map<String, Object> params) { return ''; }

    global override void sendTransactionalEmail(Map<String, Object> params) {}

    global override void sendCampaignEmails(Map<String, Object> params) { }

    global override void addOrUpdateContactsToExternalApi(Map<String, Object> params) { }

    global override void removeContactsFromExternalApi(Map<String, Object> params) { }

    global override void createOrUpdateExternalMailingLists(Map<String, Object> params) { }
}