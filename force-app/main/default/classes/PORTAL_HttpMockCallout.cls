public with sharing class PORTAL_HttpMockCallout implements HttpCalloutMock {

    public class PORTAL_HttpMockCalloutException extends Exception {}

    Map<String, HttpCalloutMock> requests = new Map<String, HttpCalloutMock>(); // can only hold one HttpCalloutMock per URL

    public void addRequest(Integer statusCode, String status, String body, Map<String, String> responseHeaders, String calloutURL) {
        SingleRequestMock mock = new SingleRequestMock(statusCode, status, body, responseHeaders);
        requests.put(calloutURL, mock);
    }

    public void addRequest(Integer statusCode, String status, String body, String calloutURL) {
        addRequest(statusCode, status, body, null, calloutURL);
    }

    public void addRequest(String status, String body, String calloutURL) {
        addRequest(200, status, body, null, calloutURL);
    }

    public void addRequest(String body, String calloutURL) {
        addRequest(200, '', body, null, calloutURL);
    }

    public void deleteAllRequests() {
        requests = new Map<String, HttpCalloutMock>();
    }

    public void getRequests(){
        System.debug(requests);
    }

    public HTTPResponse respond(HTTPRequest request) {
        HttpCalloutMock mockCallout = requests.get(request.getEndpoint());

        if (mockCallout != null) {
            return mockCallout.respond(request);
        }

        return null;

    }

    private class SingleRequestMock implements HttpCalloutMock {
        protected Integer statusCode;
        protected String status;
        protected String bodyAsString;
        protected Map<String, String> responseHeaders;

        public SingleRequestMock(Integer statusCode, String status, String body,
                                         Map<String, String> responseHeaders) {
            this.statusCode = statusCode;
            this.status = status;
            this.bodyAsString = body;
            this.responseHeaders = responseHeaders;
        }

        public SingleRequestMock( String status, String body,
                                         Map<String, String> responseHeaders) {
            this.statusCode = 200;
            this.status = status;
            this.bodyAsString = body;
            this.responseHeaders = responseHeaders;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(statusCode);
            response.setStatus(status);
            response.setBody(bodyAsString);

            if (responseHeaders != null) {
                for (String key : responseHeaders.keySet()) {
                    response.setHeader(key, responseHeaders.get(key));
                }
            }

            return response;
        }
    }
}