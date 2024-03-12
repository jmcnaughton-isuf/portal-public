/**
 * A class used to interface with the HEPData API,
 * Documented here: https://developer.hepdata.com/
 *
 * All accessToken parameters are optional; if supplied, the Apirepository will first attempt to authenticate
 * using the provided token. Otherwise, the ApiRepository will fetch a new access/refresh token pair
 * in order to service the request. All methods may attach an accessToken property to their returned values,
 * that consumers can present for future calls.
 *
 * All API calls should be retried once; in the event of a non-200 response, this class attempts
 * to provision a new access token before retrying.
 *
 * @author      Phong Huynh
 * @version     1.0
 * @since       1.0
 */
public with sharing class PORTAL_HEP_ApiRepository {
    private static final String BASE_URL = 'https://gpc.matchinggifts.com';
    private static final String API_BASE_URL = BASE_URL + '/api';
    private static final String OAUTH_BASE_URL = BASE_URL + '/o';

    private static final String HEP_UN = 'Hep Username Here';
    private static final String HEP_PASS = 'Hep Password Here';
    private static final String CONSUMER_KEY = 'HEP Consumer Key Here';
    private static final String CONSUMER_SECRET = 'HEP Secret Key Here';


    private static final Integer MAXIMUM_TRIES = 3;

    /**
     * Fetches a list of companies from the HEPData API by a given name.
     * Intended to be used to deliver live, dyanmic search results.
     * @param name  The company name to query for.
     * @return      A representation of the response body as JSON.
     *              Most interesting information is in the results property.
     */
    @AuraEnabled(cacheable=true)
    public static PORTAL_HEP_CompanySearchResult getCompaniesByName(String name, Integer retries) {
        if (retries == null) {
            retries = MAXIMUM_TRIES;
        }

        final List<QueryParam> params = new List<QueryParam>();
        params.add(new QueryParam('name', name));

        final HttpRequest request = createApiRequest('GET', API_BASE_URL + '/V2/company_name_search_dynamic_result/', params);

        final Http h = new Http();
        final HttpResponse response = h.send(request);

        if (200 <= response.getStatusCode() && response.getStatusCode() < 300) {
            final PORTAL_HEP_CompanySearchResult result = PORTAL_HEP_CompanySearchResult.parse(response.getBody());
            return result;
        }
        else if (retries > 0) {
            return getCompaniesByName(name, --retries);
        }
        else {
            return new PORTAL_HEP_CompanySearchResult();
        }
    }

    /**
     * Fetches detailed information about a specific company.
     * @param companyId The ID associated with the desired company
     * @return          A representation of the company as JSON.
     */
    @AuraEnabled(cacheable=true)
    public static PORTAL_HEP_CompanyDetailsResult getCompanyDetailsByID(String companyId, Integer retries) {
        if (retries == null) {
            retries = MAXIMUM_TRIES;
        }

        final List<QueryParam> params = new List<QueryParam>();
        final HttpRequest request = createApiRequest('GET', API_BASE_URL + '/V2/company_details_by_id/' + companyId + '/', params);

        final Http h = new Http();
        final HttpResponse response = h.send(request);

        if (200 <= response.getStatusCode() && response.getStatusCode() < 300) {
            final PORTAL_HEP_CompanyDetailsResult result = PORTAL_HEP_CompanyDetailsResult.parse(response.getBody());
            return result;
        }
        else if (retries > 0) {
            return getCompanyDetailsByID(companyId, --retries);
        }
        else {
            return new PORTAL_HEP_CompanyDetailsResult();
        }
    }

    /**
     * Fetches detailed information about a specific company.
     * @param name              The donor's name
     * @param companyName       The company's name
     * @param email             Donor's email address?
     * @param amount            Donation amount
     * @param foundationId      The company's foundation ID
     * @return                  A HTTP Status Code bubbled up from the underlying HEPData API
     */
    @AuraEnabled
    public static Integer createPortalDonorEntry(String name, String companyName, String email, String amount, String foundationId) {
        final List<QueryParam> params = new List<QueryParam>();
        final HttpRequest request = createApiRequest('POST', API_BASE_URL + '/portal/donation/', params);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        final String body = JSON.serialize(new PortalDonorEntryBody(name, companyName, email, amount, foundationId));
        request.setBody(body);

        final Http h = new Http();
        final HttpResponse response = h.send(request);
        return response.getStatusCode();
    }

    /**
     * POJO used to represent a POST body.
     * Use with JSON.serialize.
     */
    private class PortalDonorEntryBody {
        public String name;
        public String company_name;
        public String email;
        public String amount;
        public String foundation_id;

        /**
         * Class constructor; all parameters map directly to
         * the PortalDonorEntryBody object expected by the createPortalDonorEntry endpoint.
         * @param name          The donor's name
         * @param companyName   The company's name
         * @param email         The donor's email
         * @param amount        The donoation amount
         * @param foundationId  A foundation ID retrieved from a company search/details operation
         */
        public PortalDonorEntryBody(String name, String companyName, String email, String amount, String foundationId) {
            this.name = name;
            this.company_name = companyName;
            this.email = email;
            this.amount = amount;
            this.foundation_id = foundationId;
        }
    }

    /**
     * Attaches authorization headers to a given request.
     * Takes care of fetching access tokens.
     * @param request       The request to decorate
     */
    private static void decorateRequestWithAuthHeaders(HttpRequest request) {
        final String accessToken = fetchAuthToken();
        request.setHeader('Authorization', 'Bearer ' + accessToken);
    }

    /**
     * Generates an HttpRequest targeting a specific endpoint, with query parameters provided.
     * Also decorates the request with common headers.
     * @param method        The HTTP method to invoke (ie 'GET', 'PUT', etc.)
     * @param endpoint      The full REST endpoint to target
     * @param params        An optional list of query parameter KVPs.
     */
    private static HttpRequest createApiRequest(String method, String endpoint, List<QueryParam> params) {
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setHeader('accept', 'application/json');
        req.setEndpoint(endpoint + compileQueryParameters(params));
        decorateRequestWithAuthHeaders(req);
        return req;
    }

    /**
     * Converts a list of query parameter KVPs to a representation
     * that can be appended to a URL.
     * @param params        The query parameters to serialize
     * @return              The serialized query parameters
     */
    private static String compileQueryParameters(List<QueryParam> params) {
        if (params.isEmpty()) {
            return '';
        }
        else {
            List<String> stringified = new List<String>();
            for (QueryParam param : params) {
                stringified.add(param.toString());
            }

            return '?' + String.join(stringified, '&');
        }
    }

    /**
     * A simple wrapper class with a toString() override to make it suitable
     * for easy compilation of URL query parameters
     */
    private class QueryParam {
        public final String key;
        public final String value;

        /**
         * Class constructor; properties are public, but readonly.
         * If modifications need to be made, create a new QueryParam instance.
         * @param key   The query parameter's name
         * @param value The value associated with this query parameter
         */
        QueryParam(String key, String value) {
            this.key = key;
            this.value = value;
        }

        /**
         * @return A string representation of the query parameter of the form "key=value"
         */
        public override String toString() {
            return key + '=' + value;
        }
    }

    /**
     * Adapted from Stela's example:
     * Makes a callout and provisions a fresh access token.
     * @return      A bearer access token to be used in Authorization headers
     */

    private static String fetchAuthToken() {
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        // set the endPoint
        req.setEndpoint(OAUTH_BASE_URL + '/token/');

        // set the header
        Blob authorizationValue = Blob.valueOf(CONSUMER_KEY + ':' + CONSUMER_SECRET);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(authorizationValue);
        req.setHeader('Authorization', authorizationHeader);

        // set the body
        req.setBody('grant_type=password&username=' + HEP_UN + '&password=' + HEP_PASS);

        // set the method
        req.setMethod('POST');
        HttpResponse res = h.send(req);


        Integer statusCode = res.getStatusCode();
        // JSON Parser
        JSONParser parser = JSON.createParser(res.getBody());


        String retval = null;
        if (statusCode == 200) {
            while (parser.nextToken()!= null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if (fieldName == 'access_token') {
                        retval = parser.getText();
                    }
               }
            }
        }
        else {
            System.debug('Error ' + statusCode + ': ' + res.getStatus());
        }

        return retval;
    }
}