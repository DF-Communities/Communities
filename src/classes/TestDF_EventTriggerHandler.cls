@isTest
public with sharing class TestDF_EventTriggerHandler{
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test Class for DF_EventTriggerHandler Trigger.
 *  Author  : Ian Smith
 *  Date    : 29-01-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Apex Class to test DF_EventTriggerHandler trigger on the DF_Event__c object. 
 *               
 *  Modification History
 *
 *  Date            Who     Description 
 *  dd-mm-yyyy      ??      ??
 *                             
*******************************************************************************************/

    static testMethod void testInsert(){

        //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session" .
        RecordType rTypedf = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Awareness_Session' and SobjectType = 'DF_Event__c'];

        //Select DF_Contact__c RecordTypeId for "Dementia Friend Champion".
        RecordType rTypedfc = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Champion' and SobjectType = 'DF_Contact__c'];
              
        //New Partner_Organisation__c Record to be added to the DF_Contact__c test Data.
        Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
        insert pa; 
        
        //New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(RecordTypeId = rTypedfc.id, Name='Test DFC', Partner_Organisation_ID__c = pa.id, Contact_Ext_Id__c = 12345678
                                             ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                             ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');
        insert df;
        
        //New DF_Event__c Record to be added to the test Data.
        DF_Event__c dfEvent = new DF_Event__c(RecordTypeId = rTypedf.id, Name = 'Test DFEvent', Session_Organiser__c = df.Id, Event_Date_Time__c = system.now());
        
        //Now insert data causing the DF_Event__c trigger to fire. 
        Test.startTest();
        insert dfEvent;
        Test.stopTest(); 
    }
    
    
    
    static testMethod void testBulkInsert(){
              
        //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session" .
        RecordType rTypedf = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Awareness_Session' and SobjectType = 'DF_Event__c'];

        //Select DF_Contact__c RecordTypeId for "Dementia Friend Champion".
        RecordType rTypedfc = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Champion' and SobjectType = 'DF_Contact__c'];
              
        //New Partner_Organisation__c Record to be added to the DF_Contact__c test Data.
        Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
        insert pa; 
        
        //New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(RecordTypeId = rTypedfc.id, Name='Test DFC', Partner_Organisation_ID__c = pa.id, Contact_Ext_Id__c = 12345678
                                                 ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                         ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');
        insert df;
        
        //New DF_Event__c Records to be added to the test Data.
        DF_Event__c[] dfEventToCreate = new DF_Event__c[]{};
        
        for(Integer i=0; i< 200; i++){
            DF_Event__c dfEvent = new DF_Event__c(RecordTypeId = rTypedf.id, 
                Name = 'Test DFEvent',
                Event_Ext_Id__c = i, 
                Event_Status__c = 'Completed',
                Session_Organiser__c = df.Id                
            );
            dfEventToCreate.add(dfEvent);
        }
        
        //Now insert data causing the DF_Event__c trigger to fire. 
        Test.startTest();
        insert dfEventToCreate;
        Test.stopTest(); 
    }    
    
    
    
    static testMethod void testUpdate(){
        
        //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session" .
        RecordType rTypedf = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Awareness_Session' and SobjectType = 'DF_Event__c'];

        //Select DF_Contact__c RecordTypeId for "Dementia Friend Champion".
        RecordType rTypedfc = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Champion' and SobjectType = 'DF_Contact__c'];
              
        //New Partner_Organisation__c Record to be added to the DF_Contact__c test Data.
        Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
        insert pa; 
        
        //New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(RecordTypeId = rTypedfc.id, Name='Test DFC', Partner_Organisation_ID__c = pa.id, Contact_Ext_Id__c = 12345678
                                             ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                             ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');
        insert df;
        
        //New DF_Event__c Record to be added to the test Data.
        DF_Event__c dfEvent = new DF_Event__c(RecordTypeId = rTypedf.id, Requested_Info_Session__c = true, Name = 'Test DFEvent', Session_Organiser__c = df.Id, Event_Date_Time__c = system.now());
        insert dfEvent;                 
            
        Test.startTest();  //Start Executing the test.

        dfEvent.Name = 'TestDFEvent';
        dfEvent.Street__c = 'Test Street';
        dfEvent.City__c = 'Test City'; 
        dfEvent.Event_Status__c = 'Completed';
        dfEvent.Public_Event__c = true;
        update dfEvent;

        dfEvent.Event_Status__c = 'Completed';
        dfEvent.Public_Event__c = false;
        update dfEvent;

        dfEvent.Event_Status__c = 'Available';
        update dfEvent;

        dfEvent.Event_Status__c = 'Cancelled';
        update dfEvent;        

        Test.stopTest();  //Stops the test execution.
                
        System.assertEquals('TestDFEvent', [select Name from DF_Event__c where id =: dfEvent.id].Name);
    }
  
  
  
    static testMethod void testBulkUpdate(){
        
        //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session" .
        RecordType rTypedf = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Awareness_Session' and SobjectType = 'DF_Event__c'];

        //Select DF_Contact__c RecordTypeId for "Dementia Friend Champion".
        RecordType rTypedfc = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Champion' and SobjectType = 'DF_Contact__c'];
                      
        //New Partner_Organisation__c Record to be added to the DF_Contact__c test Data.
        Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
        insert pa; 
        
        //New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(RecordTypeId = rTypedfc.id, Name='Test DFC', Partner_Organisation_ID__c = pa.id, Contact_Ext_Id__c = 12345678
                                             ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                             ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');
        insert df;
        
        // New Batch of DF_Event__c Records to be added to the test Data.
        List<DF_Event__c> lstDFEvent = new List<DF_Event__c>();

        for (Integer i=0 ; i <200; i++) {
            DF_Event__c dfEvent = new DF_Event__c(RecordTypeId = rTypedf.id, 
                Name = 'Test DFEvent',
                Event_Ext_Id__c = i, 
                Session_Organiser__c = df.Id,
                Event_Date_Time__c = system.now()    
            );  
            lstDFEvent.add(dfEvent);
        }
        insert lstDFEvent;

        List<DF_Event__c> lstToUpdate = [select Id, Name from DF_Event__c where Name = 'Test DFEvent'];
        for(DF_Event__c dfe : lstToUpdate){
            dfe.Name = 'TestDFEvent';
        }
     
        Test.startTest();  //Start Executing the test.   
        update lstToUpdate;
        Test.stopTest();  //Stops the test execution.
    }
    
    
    
    static testMethod void testDelete(){

        //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session" .
        RecordType rTypedf = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Awareness_Session' and SobjectType = 'DF_Event__c'];

        //Select DF_Contact__c RecordTypeId for "Dementia Friend Champion".
        RecordType rTypedfc = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Champion' and SobjectType = 'DF_Contact__c'];
              
        //New Partner_Organisation__c Record to be added to the DF_Contact__c test Data.
        Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
        insert pa; 
        
        //New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(RecordTypeId = rTypedfc.id, Name='Test DFC', Partner_Organisation_ID__c = pa.id, Contact_Ext_Id__c = 12345678
                                             ,First_Name__c = 'Test', Last_Name__c ='DFC'
                                             ,email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alztest.com');
        insert df;
        
        //New DF_Event__c Record to be added to the test Data.
        DF_Event__c dfEvent = new DF_Event__c(RecordTypeId = rTypedf.id, Name = 'Test DFEvent', Session_Organiser__c = df.Id, Event_Date_Time__c = system.now());
        insert dfEvent;  
        
        Test.startTest();  //Start Executing the test.             
        delete dfEvent;
        Test.stopTest();  //Stops the test execution.
  }    
    
 
 
}