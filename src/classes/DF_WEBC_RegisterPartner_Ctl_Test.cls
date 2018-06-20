/************************************************************************************************
*Alzheimer's Society

     * @author          Lakshmi Vasudevan 
     * @date            24-05-2016
     * @description     Test class for DF_WEBC_RegisterPartner_Controller
***********************************************************************************************/

@isTest
private class DF_WEBC_RegisterPartner_Ctl_Test {
	
	@testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();   
    }
    
    static testMethod void myUnitTest() {
    
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
     PageReference pageRef = Page.DF_WEBC_RegisterPartner;
     test.setCurrentPage(pageRef);
        
     system.runAs(u[0]){
     
     test.starttest();  
     DF_WEBC_RegisterPartner_Controller controller = new DF_WEBC_RegisterPartner_Controller();
      controller.orgName ='Test'; 
      controller.orgStreet ='Test street';
      controller.orgTelephone='01234567890';
      controller.orgCounty='Essex';
      controller.orgCity='test city';
      controller.orgCountry='England';
      controller.orgPostCode='TE1 4LE';
      controller.employees='8';
      controller.sector='other';
      controller.sectorOther='test'; 
      
      System.assertNotEquals(null,controller.register());
      System.assertNotEquals(null,controller.cancel());
        
    }
   }
}