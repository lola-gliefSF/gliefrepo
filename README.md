This document provides a detailed overview of the GLEIF API integration with Salesforce to retrieve and store Legal Entity data using Apex and Lightning Web Component (LWC). The integration allows users to fetch company details based on the Legal Entity Identifier (LEI).

The implementation consists of:

1. Custom Object(Legal Entity) created with external Id LEI (Legal Entity Identifier).
2. Custom App and tab created for the custom object Legal Entity.
3. Apex Integration api: Calls the GLEIF API, parses the response, and returns the object.
4. Apex Batch for automatization: Automatically fetches entity details with non empty lei field and stores it in a Salesforce custom object.
5. LWC Component: Provides a user-friendly interface for searching and displaying entity details. Here in apex controller I called Api method in order to get data in real time (as in assignment was asked to use for Api both approaches apex and lwc), but I also added the commented line in the code which data could be retrieved directly from Salesforce, as batch automation will assure data in Salesforce.

# You can find technical documentation and eng user guide under docs folder
docs/GliefTechDocGuide.pdf
docs/GliefEnUserGuide.pdf
