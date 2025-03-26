// Mock Class // from lola vs
@isTest
public class MockGleifApiTest implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest req) {
        // Create a mock HttpResponse object.
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        // Set the body of the response to simulate a successful API response.
        res.setBody('{ "data": [ { "attributes": { "entity": { "legalName": { "name": "KREDITANSTALT FUER WIEDERAUFBAU" }, "legalAddress": { "country": "DE", "postalCode": "60325" }, "jurisdiction": "DE", "legalForm": { "name": "Corporation" } }, "registration": { "registrationDate": "2012-09-28", "initialRegistration": { "date": "2012-09-28" } }, "status": "ISSUED", "lastUpdate": "2024-02-28T15:42:55.000Z", "expiration": { "date": "2025-02-28" } } ] }');
        res.setStatusCode(200);  // Set the status code to 200 (OK).
        return res;  // Return the mock response.
    }
}