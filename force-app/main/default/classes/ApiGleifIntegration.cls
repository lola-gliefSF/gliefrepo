/**
* @File Name : ApiGleifIntegration.cls
* @Description :
* @Author : Lola
* @Last Modified By :
* @Last Modified On : March 24, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | March 24, 2025 |   | Initial Version
**/

public with sharing class ApiGleifIntegration {
 
    //  using callout=true to make an external callout to GLEIF API.
    @future(callout=true)
    public static void fetchLegalEntityData(Id legalEntityId) {
        // Retrieve the LegalEntity__c record based on the provided Id.
        LegalEntity__c legalEntity = [SELECT LEI__c FROM LegalEntity__c WHERE Id = :legalEntityId];

        // Check if the LEI__c field is populated.  The API call is dependent on this.
        if (legalEntity.LEI__c != null) {
            // Construct the endpoint URL for the GLEIF API.
            //  It includes the LEI to filter the results and retrieve the specific legal entity data.
            String endpoint = 'https://api.gleif.org/api/v1/lei-records?filter[lei]=' + EncodingUtil.urlEncode(legalEntity.LEI__c, 'UTF-8');

            // Create an HttpRequest object to define the details of the API request.
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);  // Set the endpoint URL.
            req.setMethod('GET');        // Specify the HTTP method as GET.
            req.setTimeout(120000); // Set the timeout to 120 seconds (in milliseconds).

            try {
                // Create an Http object to send the request.
                Http http = new Http();
                // Send the HTTP request and get the response.
                HttpResponse res = http.send(req);

                // Check if the API call was successful (status code 200 indicates success).
                if (res.getStatusCode() == 200) {
                    // Deserialize the JSON response into a Map.  The structure is nested, so we use Map<String, Object>.
                    Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                    // Extract the 'data' array from the response. This array contains the actual entity data.
                    List<Object> data = (List<Object>) responseMap.get('data');
                    
                    System.debug('datashka: ' + data);

                    // Check if the 'data' array is not empty.
                    if (!data.isEmpty()) {
                        // Get the first element of the 'data' array, which represents the legal entity.
                        Map<String, Object> entityData = (Map<String, Object>) data[0];

                        // Extract the 'attributes' map, which contains the entity's attributes.
                        Map<String, Object> attributes = (Map<String, Object>) entityData.get('attributes');

                        // Extract the 'entity' map, which contains core entity information.
                        Map<String, Object> entity = (Map<String, Object>) attributes.get('entity');

                        // Extract the 'registration' map, containing registration details.
                        Map<String, Object> registration = (Map<String, Object>) attributes.get('registration');

                        // Extract the 'legalForm' map
                        Map<String, Object> legalForm = (Map<String, Object>)entity.get('legalForm');

                        Map<String, Object> initialRegistration = (Map<String, Object>) registration.get('initialRegistration');
                        // Update the LegalEntity__c record with the data from the API response.
                        //legalEntity.name = (String) entity.get('legalName').get('name');
                        //legalEntity.Country__c = (String) entity.get('legalAddress').get('country');
                       // legalEntity.PostalCode__c = (String) entity.get('legalAddress').get('postalCode');
                        legalEntity.RegistrationDate__c = Date.parse((String) registration.get('registrationDate'));
                        legalEntity.Status__c = (String) attributes.get('status');
                        legalEntity.Jurisdiction__c = (String) entity.get('jurisdiction');
                        legalEntity.LegalForm__c = legalForm != null ? (String) legalForm.get('name') : null;
                        legalEntity.InitialRegistrationDate__c = initialRegistration != null ? Date.parse((String) initialRegistration.get('date') ): null;
                        legalEntity.LastUpdateDate__c = Date.parse((String) attributes.get('lastUpdate'));
                       // legalEntity.ExpirationDate__c = attributes.get('expiration') != null ? Date.parse((String) attributes.get('expiration').get('date') ): null;


                        // Update the LegalEntity__c record in the database. 
                        update legalEntity;
                    }
                } else {
                    // Handle unsuccessful API calls.  Log the error and throw an exception.
                    System.debug('API call failed: ' + res.getStatusCode() + ' - ' + res.getStatus());
                    // Handle API errors appropriately (e.g., log, notify admins)
                    throw new CalloutException('Failed to call GLEIF API: ' + res.getStatus() + ' - ' + res.getBody());
                }
            } catch (Exception e) {
                // Handle exceptions that occur during the API call or data processing.
                System.debug('Exception during API call: ' + e.getMessage());
                // Handle exceptions appropriately
                throw new CalloutException('Error calling GLEIF API: ' + e.getMessage());
            }
        }
    }
}
