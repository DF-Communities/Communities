/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : test class for DF_LeadConvert_Controller class
 *  Author  : Lakshmi Vasudevan
 *  Date    : Jun 2016
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 

*******************************************************************************************/ 

@isTest
private class DF_LeadConvert_Controller_Test {
	
	@testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }

    static testMethod void myUnitTest() {
      List<Lead> lead = [select id,partner_code__c  from lead limit 1];
        // create a Lead
    test.starttest();
    ApexPages.StandardController sc = new ApexPages.StandardController(lead[0]);
    DF_LeadConvert_Controller controller = new DF_LeadConvert_Controller(sc);
    controller.convertLead();
    controller.cancel();
        
    }
}