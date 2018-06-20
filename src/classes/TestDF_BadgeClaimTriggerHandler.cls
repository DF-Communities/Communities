@isTest
public with sharing class TestDF_BadgeClaimTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test Class for DF_BadgeClaimTriggerHandler Trigger.
 *  Author  : Ian Smith
 *  Date    : 21-03-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:  Apex Class to test DF_BadgeClaimTriggerHandler trigger on the Badge_Claim__c object. 
 *               
 *  Modification History
 *  Date          Who      Description 
 *  dd-mm-yyyy    ??    ??
 *                             
*******************************************************************************************/

    static testMethod void testInsert(){
           
    //New DF_Contact__c Record to be added to the Badge_Claim__c test Data.
    DF_Contact__c df = new DF_Contact__c(Name='Test DFC', Contact_Ext_Id__c = 12345678
                                         ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                         ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');
    insert df;
              
    //New Badge_Claim__c Record to be added to the test Data.
    Badge_Claim__c bc = new Badge_Claim__c(Town_City__c='Test City', Street__c='37 Test Street', DF_Contact__c=df.Id);
 
        //Now insert data causing the Badge_Claim__c trigger to fire. 
        Test.startTest();
    insert bc;
        Test.stopTest(); 
    }
    
    
    
  static testMethod void testBulkInsert(){
              
    //New DF_Contact__c Record to be added to the Badge_Claim__c test Data.
    DF_Contact__c df = new DF_Contact__c(Name='Test DFC', Contact_Ext_Id__c = 12345678
                                         ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                         ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');
    insert df;
    
    //New Badge_Claim__c Record to be added to the test Data.
        Badge_Claim__c[] badgeClaimToCreate = new Badge_Claim__c[]{};
        
        //Create 200 new DF_Contact Records for a Bulk test.
        for(Integer i=0; i< 200; i++){
            Badge_Claim__c bc = new Badge_Claim__c(Town_City__c = 'Test City',
        Street__c='37 Test Street', 
        DF_Contact__c = df.Id
      );
            badgeClaimToCreate.add(bc);
        }
        
        //Now insert data causing the Badge_Claim__c trigger to fire. 
        Test.startTest();  
        insert badgeClaimToCreate;
        Test.stopTest();  
    }    
    
    
    
    static testMethod void testUpdate(){
      
    //New DF_Contact__c Record to be added to the Badge_Claim__c test Data.
    DF_Contact__c df = new DF_Contact__c(Name='Test DFC', Contact_Ext_Id__c = 12345678
                                             ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                         ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');              
    insert df;
    
    //New Badge_Claim__c Record to be added to the test Data.
    Badge_Claim__c bc = new Badge_Claim__c(Town_City__c='Test City', Street__c='37 Test Street', DF_Contact__c=df.Id);
    insert bc;
    
    Test.startTest();  // Start Executing the test.

    bc.Town_City__c = 'TestCity';
    bc.Street__c = '36 Test Street';
    update bc;
            
        Test.stopTest();  // Stops the test execution.
                
        System.assertEquals('TestCity', [select Town_City__c from Badge_Claim__c where id =: bc.id].Town_City__c);
  }
  
  
  
  static testMethod void testBulkUpdate(){
      
    //New DF_Contact__c Record to be added to the Badge_Claim__c test Data.
    DF_Contact__c df = new DF_Contact__c(Name='Test DFC', Contact_Ext_Id__c = 12345678                                         ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                         ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');              
    insert df;
    
    //New Badge_Claim__c Record to be added to the test Data.
        Badge_Claim__c[] badgeClaimToCreate = new Badge_Claim__c[]{};
        
        //Create 200 new DF_Contact Records for a Bulk test.
        for(Integer i=0; i< 200; i++){
            Badge_Claim__c bc = new Badge_Claim__c(Town_City__c = 'Test City',
        Street__c='37 Test Street', 
        DF_Contact__c=df.Id
      );
            badgeClaimToCreate.add(bc);
        }      
      
    List<Badge_Claim__c> lstToUpdate = [select Id, Town_City__c from Badge_Claim__c where Town_City__c = 'Test City'];
    for(Badge_Claim__c bc : lstToUpdate){
            bc.Street__c = 'TestStreet';
        }
   
    Test.startTest();  // Start Executing the test.   
    update lstToUpdate;
        Test.stopTest();  // Stops the test execution.
  }
    
    
    
    static testMethod void testDelete(){

    //New DF_Contact__c Record to be added to the Badge_Claim__c test Data.
    DF_Contact__c df = new DF_Contact__c(Name='Test DFC', Contact_Ext_Id__c = 12345678                                         ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                         ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');              
    insert df;
    
    //New Badge_Claim__c Record to be added to the test Data.
    Badge_Claim__c bc = new Badge_Claim__c(Town_City__c='Test City', Street__c='37 Test Street', DF_Contact__c=df.Id);
    insert bc;
    
    Test.startTest();  // Start Executing the test.           
    delete bc;
    Test.stopTest();  // Stops the test execution.
  }   
}