/************************************************************************************************
*Alzheimer's Society

     * @author          Lakshmi Vasudevan 
     * @date            24-05-2016
     * @description     Test class for DF_Lead_TriggerHandler
***********************************************************************************************/
@isTest
private class DF_Lead_TriggerHandler_Test {

   @testsetup  static void mytestdata(){
   
   DFP_DataFactory_Test.TestDataCreation();
   
   }

    static testMethod void myUnitTest() {
 
    List<Contact> c  = [select id,FirstName,LastName from Contact where email='test.testcontact@myemail.com' limit 1]; 
    List<DF_Contact__c> DFc  = [select id from DF_Contact__c where email__c='test.testcontact@myemail.com' limit 1] ;
    List<Lead> lead = [select id from lead limit 1];
        // create a Lead
    test.starttest();
                 
   
   Database.LeadConvert lc = new database.LeadConvert();
   lc.setLeadId(lead[0].id);
   lc.setDoNotCreateOpportunity(true);
   LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
   lc.setConvertedStatus(convertStatus.MasterLabel);
   
   Database.LeadConvertResult lcr = Database.convertLead(lc);
   System.assert(lcr.isSuccess());
        
    }
}