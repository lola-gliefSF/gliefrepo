This document provides a detailed overview of the GLEIF API integration with Salesforce to retrieve and store Legal Entity data using Apex and Lightning Web Component (LWC). The integration allows users to fetch company details based on the Legal Entity Identifier (LEI).

The implementation consists of:

Custom Object(Legal Entity) created with external Id LEI (Legal Entity Identifier).
Custom App and tab created for the custom object Legal Entity.
Apex Integration api: Calls the GLEIF API, parses the response, and returns the object.
Apex Batch for automatization: Automatically fetches entity details with non empty lei field and stores it in a Salesforce custom object.
LWC Component: Provides a user-friendly interface for searching and displaying entity details. Here in apex controller I called Api method in order to get data in real time (as in assignment was asked to use for Api both approaches apex and lwc), but I also added the commented line in the code which data could be retrieved directly from Salesforce, as batch automation will assure data in Salesforce.
