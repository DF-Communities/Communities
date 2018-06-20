/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.

 * The @isTest /*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            21-07-2016
     * @description     Test class for  BatchUpdateOrgEventsFriendsCount
*************************/
@isTest
private class BatchUpdateOrgEventsFriendsCount_Test {
    @testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }
    static testMethod void myUnitTest() {
          
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<DF_Contact__c> dfc  = [select id,Partner_Organisation_Id__c from DF_Contact__c where email__c = 'test.testcontact@myemail.com' limit 1];  
     DF_Event__c event = new DF_Event__c(Name='test12',Event_Description__c='test Description',Event_Status__c='Available',Event_Date_Time__c=system.now(),Street__c='teststreet',City__c='testcity',County__c='uk',Postcode__c='12345678912',Number_of_Places__c=1234,
                                 Session_Organiser__c=dfc[0].id,Comments__c ='testcommetns',Number_of_Attendees__c=1234,partner_organisation__c=partner[0].Id,recordtypeid=DF_Utils.getsObjectRecordTypeId('DF_Event__c','Dementia_Friend_Awareness_Session')); 
      insert event;
      
      BatchUpdateOrgEventsFriendsCount batch = new  BatchUpdateOrgEventsFriendsCount();
    
      test.starttest();
      Database.executeBatch( batch,4);
   
        
    }
}