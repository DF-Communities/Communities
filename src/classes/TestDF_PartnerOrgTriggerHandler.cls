@isTest
public with sharing class TestDF_PartnerOrgTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test Class for DF_PartnerOrgTriggerHandler Trigger.
 *  Author  : Ian Smith
 *  Date    : 21-03-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:  Apex Class to test DF_PartnerOrgTriggerHandler trigger on the Partner_Organisation__c object. 
 *               
 *  Modification History
 *  Date          Who      Description 
 *  dd-mm-yyyy    ??    ??
 *                             
*******************************************************************************************/

    static testMethod void testInsert(){
              
    //New Partner_Organisation__c Record to be added to the test Data.
    Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123');
    
        //Now insert data causing the Partner_Organisation__c trigger to fire. 
        Test.startTest();
    insert pa;
        Test.stopTest(); 
    }
    
    
    
  static testMethod void testBulkInsert(){
              
    //New Partner_Organisation__c Record to be added to the test Data.
        Partner_Organisation__c[] PartnerOrgsToCreate = new Partner_Organisation__c[]{};
      
        //Create 200 new Partner_Organisation__c Records for a Bulk test.
        for(Integer i=0; i< 200; i++){
            Partner_Organisation__c pa = new Partner_Organisation__c(Name = 'Test DF Org',
        DFC_Code__c = 'ABC' + i
      );
            PartnerOrgsToCreate.add(pa);
        }
        
        //Now insert data causing the Partner_Organisation__c trigger to fire. 
        Test.startTest();  
        insert PartnerOrgsToCreate;
        Test.stopTest();  
    }    
    
    
    
    static testMethod void testUpdate(){
      
    // New Partner_Organisation__c Record to be added to the test Data.
    Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
    insert pa;              
        
    Test.startTest();  // Start Executing the test.

    pa.Name = 'Test Org1';
    pa.DFC_Code__c = 'ABC321';
    update pa;
            
        Test.stopTest();  // Stops the test execution.
                
        System.assertEquals('Test Org1', [select Name from Partner_Organisation__c where id =: pa.id].Name);
  }
  
  
  
  static testMethod void testBulkUpdate(){
      
    //New Batch of Partner_Organisation__c Records to be added to the test Data.
    List<Partner_Organisation__c> lstPartnerOrg = new List<Partner_Organisation__c>();

    //Create 200 new Partner_Organisation__c Records for a Bulk test.
    for (Integer i=0 ; i <200; i++) {
           Partner_Organisation__c pa = new Partner_Organisation__c(Name = 'Test DF Org',
        DFC_Code__c = 'ABC' + i        
      );  
            lstPartnerOrg.add(pa);
        }

    List<Partner_Organisation__c> lstToUpdate = [select Id, Name from Partner_Organisation__c where Name = 'Test DF Org'];
    for(Partner_Organisation__c df : lstToUpdate){
            df.Name = 'TestDFOrg';
        }
   
    Test.startTest();  // Start Executing the test.   
    update lstToUpdate;
        Test.stopTest();  // Stops the test execution.
  }
    
    
    
    static testMethod void testDelete(){

    //New Partner_Organisation__c Record to be added to the test Data.
    Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
    insert pa;              
    
    Test.startTest();  // Start Executing the test.           
    delete pa;
    Test.stopTest();  // Stops the test execution.
  }    
}