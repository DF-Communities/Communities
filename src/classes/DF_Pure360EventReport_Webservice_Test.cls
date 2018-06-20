/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DF_Pure360EventReport_Webservice_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
     String JsonMsg=JSON.serialize('{"fake": "response"}');
       Test.startTest();

  //As Per Best Practice it is important to instantiate the Rest Context 
  
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = 'https://dfdev-dfdev.cs18.force.com/services/apexrest/pure360EventReport/';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    DF_Pure360EventReport_Webservice.doPost();   
        
    }
}