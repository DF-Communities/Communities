/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            15-07-2016
     * @description     Test class for BatchUpdateOldFriendCountsByChamps
*************************/
@isTest
private class BatchUpdateOldFriendCountsByChamps_Test {

     @testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }
    static testMethod void myUnitTest() {
          
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<DF_Contact__c> dfc  = [select id,Partner_Organisation_Id__c from DF_Contact__c where email__c = 'test.testcontact@myemail.com' limit 1]; 
     dfc[0].Partner_Organisation_Id__c =  partner[0].Id;
     dfc[0].Total_No_of_Friends_Created__c = 8;
     dfc[0].RecordTypeId = DF_Utils.getsObjectRecordTypeId('DF_Contact__c','Dementia_Friend_Champion');
     update dfc[0];
   
     BatchUpdateOldFriendCountsByChamps batch = new BatchUpdateOldFriendCountsByChamps();
    
     test.starttest();
    Database.executeBatch( batch,4);
   
        
    }
}