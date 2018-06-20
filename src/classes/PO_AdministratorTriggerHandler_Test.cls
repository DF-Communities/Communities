/************************************************************************************************
*Alzheimer's Society

     * @author          Lakshmi Vasudevan 
     * @date            24-05-2016
     * @description     Test class for PO_AdministratorTriggerHandler
***********************************************************************************************/

@isTest
private class PO_AdministratorTriggerHandler_Test {
	
	@testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }
    
    static testMethod void myUnitTest() {
    
     List<PO_Administrator__c> invite = [select id,invited_email__c,invited_name__c from PO_Administrator__c where status__c ='Invited' limit 1];
     List<PO_Administrator__c> lisPOAdmin =new List<PO_Administrator__c>();
     lisPOAdmin.add(invite[0]);
     test.starttest();
     PO_AdministratorTriggerHandler handler = new PO_AdministratorTriggerHandler();
    
    }
}