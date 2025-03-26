/**
* @File Name : MockGleifApiInvalidLEITest.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : March 24, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | March 24, 2025 |   | Initial Version
**/
@isTest
public class MockGleifApiInvalidLEITest implements HttpCalloutMock { 
     public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"data": []}'); // Simulate no data found for invalid LEI.
        res.setStatusCode(200);
        return res;
    }
}