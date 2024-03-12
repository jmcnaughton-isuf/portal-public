@isTest
global class PORTAL_403ErrorCalloutMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request) {
        final HttpResponse response = new HttpResponse();
        response.setStatusCode(403);
        return response;
    }
}