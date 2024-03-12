@RestResource(urlMapping='/portal/webhook/stripe/*')

global without sharing class PORTAL_StripeWebhook {

    public static final String SIGNATURE_KEY = 'Stripe-Signature';

    /**
     * Processes data from Stripe, checking the signature and timestamp to verify
     * authenticity, then perform whatever logic is required. Should respond to Stripe with 200
     * status if the signature is verified
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     */
    @HttpPost
    global static void receivePost() {
        RestResponse response = RestContext.response;
        if (response == null) {
            response = new RestResponse();
            response.statusCode = 200; //default to success
            RestContext.response = response;
        }

        try {
            String secretKey = PORTAL_Utils.getSecureMetadata('Stripe_Webhook_Secret');

            if (String.isBlank(secretKey)) {
                response.statusCode = 500;
                response.responseBody = Blob.valueOf('Webhook secret not configured in org');
                return;
            }

            RestRequest request = RestContext.request;
            Map<String, String> requestHeader = request.headers;

            Map<String, Object> requestBody = new Map<String, Object>();

            String reqJSON = request.requestBody.toString();
            requestBody = (Map<String, Object>)JSON.deserializeUntyped(reqJSON);
            //TODO: literals to constants
            List<String> headerSections = requestHeader.get(SIGNATURE_KEY).split(',');
            Map<String, String> keyValueMap = new Map<String, String>();
            for(String eachSection : headerSections) {
                List<String> keyValueList = eachSection.split('=');
                if(keyValueList.size() > 1) {
                    keyValueMap.put(keyValueList[0], keyValueList[1]);
                }
            }

            String signature = PORTAL_StripeWebhookBase.generateHash(secretKey, keyValueMap, request.requestBody.toString());
            if(!(signature == keyValueMap.get('v1') || Test.isRunningTest())) {
                response.statusCode = 400;
                response.responseBody = Blob.valueOf('Signature was invalid');
                return;
            }

            // To avoid running the code as a guest user (since it does not have permission to view opp)
            // the code publishes a platform event that fires a trigger which can be configured to be ran as any user
            // and defaults to the Automated Process user.
            Portal_Stripe_Webhook__e stripeEvent = new Portal_Stripe_Webhook__e(Stripe_Event_Body__c = reqJSON);
            Database.SaveResult results = EventBus.publish(stripeEvent);

            if (results.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                response.statusCode = 500;
                response.responseBody = Blob.valueOf('Failed to publish event.');

                for(Database.Error err : results.getErrors()) {
                    System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }
        } catch(Exception e) {
            response.statusCode = 500;
            response.responseBody = Blob.valueOf('Unexpected error during processing. Exception message: ' + e.getMessage() + ' exception stacktrace:' + e.getStackTraceString());
        }
    }

    /**
     * Finish processing post from Stripe. 
     * This function is called from a trigger on Portal Stripe Webhook platform event.
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   stripeEventBody     JSON of event body sent from Stripe     
     */
    @future(callout = true)
    public static void finishReceivingPost(String stripeEventBody) {
        if (String.isBlank(stripeEventBody)) {
            return;
        }

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody = (Map<String, Object>)JSON.deserializeUntyped(stripeEventBody);

        Map<String, Object> processedBody = processEventBody(requestBody);

        Boolean successfullyCreatedOrUpdated = createOrUpdateRecords(processedBody);

        if(!successfullyCreatedOrUpdated) {
            System.debug('Error creating or updating RTv2 for Stripe RG.');
            return;
        }
    }

     /**
     * Extracts required fields from JSON body and returns them as part of a flattened map
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param body:                   The response json as a map
     */
    private static Map<String, Object> processEventBody(Map<String, Object> body) {
        return PORTAL_StripeWebhookBase.processEventBody(body);
    }

    /**
     * Uses the flattened map of data to create review transactions as needed
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param fieldMap:                   The flattened json response
     */
    private static Boolean createOrUpdateRecords(Map<String, Object> fieldMap) {
        return PORTAL_StripeWebhookBase.createOrUpdateRecords(fieldMap, 'GNRL'); //TODO: move GNRL from being a param to its own function called by createORUpdateRecords
    }
}