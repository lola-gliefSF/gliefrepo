//Testing: Apex Test Class // Lola testing test from test class 11
@isTest
public class ApiGleifIntegrationTest {

    @isTest
    static void testFetchLegalEntityData() {
        // Create a new LegalEntity__c record with a sample LEI.
        LegalEntity__c legalEntity = new LegalEntity__c(LEI__c = '549300I7Q8PYYF1R8D46');
        insert legalEntity;  // Insert the record into the database.

        // Set up a mock HTTP response for the GLEIF API call.
        Test.setMock(HttpCalloutMock.class, new MockGleifApiTest());
        // Call the method to fetch and update the LegalEntity__c record.
        ApiGleifIntegration.fetchLegalEntityData(legalEntity.Id);

        // Retrieve the updated LegalEntity__c record from the database.
        LegalEntity__c updatedEntity = [SELECT name, Country__c, RegistrationDate__c, Status__c, Jurisdiction__c, LegalForm__c, InitialRegistrationDate__c,
                                                LastUpdateDate__c, ExpirationDate__c, PostalCode__c
                                         FROM LegalEntity__c WHERE Id = :legalEntity.Id]; 

        // Assert that the fields were updated correctly.
        System.assertEquals('test', updatedEntity.name);
        System.assertEquals('DE', updatedEntity.Country__c);
        System.assertEquals('60325', updatedEntity.PostalCode__c);
        System.assertEquals(Date.newInstance(2012, 09, 28), updatedEntity.RegistrationDate__c);
        System.assertEquals('ISSUED', updatedEntity.Status__c);
        System.assertEquals('DE', updatedEntity.Jurisdiction__c);
        System.assertEquals('Corporation', updatedEntity.LegalForm__c);
        System.assertEquals(Date.newInstance(2012, 09, 28), updatedEntity.InitialRegistrationDate__c);
        System.assertEquals(Date.newInstance(2024, 02, 28), updatedEntity.LastUpdateDate__c);
        System.assertEquals(Date.newInstance(2025, 02, 28), updatedEntity.ExpirationDate__c);
    }

    @isTest
    static void testFetchLegalEntityData_InvalidLEI() {
        // Create a LegalEntity__c record with an invalid LEI.
        LegalEntity__c legalEntity = new LegalEntity__c(LEI__c = 'INVALID_LEI');
        insert legalEntity;

        // Set up a mock HTTP response for an invalid LEI.
        Test.setMock(HttpCalloutMock.class, new MockGleifApiInvalidLEITest());
        try{
            // Call the method, which should throw an exception.
            ApiGleifIntegration.fetchLegalEntityData(legalEntity.Id);
        } catch(CalloutException e){
            // Assert that the exception message is correct.
            System.assert(e.getMessage().contains('Failed to call GLEIF API'), 'Exception should be about invalid LEI');
        }

    }
}
