@isTest
public with sharing class TestDF_ThirdPartiesTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test Class for DF_ThirdPartiesTriggerHandler Trigger.
 *  Author  : Ian Smith
 *  Date    : 21-03-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:  Apex Class to test DF_ThirdPartiesTriggerHandler trigger on the DF_Third_Parties__c object. 
 *               
 *  Modification History
 *  Date          Who      Description 
 *  dd-mm-yyyy    ??    ??
 *                             
*******************************************************************************************/

    static testMethod void testInsert(){
              
    //New DF_Third_Parties__c Record to be added to the test Data.
    DF_Third_Parties__c tp = new DF_Third_Parties__c(Third_Party_Name__c = 'Test3rdParty',Dementia_Friends_Total__c = 10);
 
        //Now insert data causing the DF_Third_Parties__c trigger to fire. 
        Test.startTest();
    insert tp;
        Test.stopTest(); 

    }
    
    static testMethod void testUpdate(){
      
    //New DF_Third_Parties__c Record to be added to the test Data.
    DF_Third_Parties__c tp = new DF_Third_Parties__c(Third_Party_Name__c = 'Test3rdParty',Dementia_Friends_Total__c = 10);
    insert tp;
        
    Test.startTest();  // Start Executing the test.

    tp.Dementia_Friends_Total__c = 20;
    update tp;
            
        Test.stopTest();  // Stops the test execution.
                
        System.assertEquals(20, [select Dementia_Friends_Total__c from DF_Third_Parties__c where id =: tp.id].Dementia_Friends_Total__c);
  }   
    
  static testMethod void testDelete(){

    //New DF_Third_Parties__c Record to be added to the test Data.
    DF_Third_Parties__c tp = new DF_Third_Parties__c(Third_Party_Name__c = 'Test3rdParty',Dementia_Friends_Total__c = 10);
    insert tp;
    
    Test.startTest();  // Start Executing the test.           
    delete tp;
    Test.stopTest();  // Stops the test execution.
  }
}