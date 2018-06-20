@isTest
public with sharing class TestDF_EventAttendeeTriggerHandler{
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test Class for DF_EventAttendeeTriggerHandler Trigger.
 *  Author  : Ian Smith
 *  Date    : 29-01-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:  Apex Class to test DF_EventAttendeeTriggerHandler trigger on the DF_EventAttendee__c object. 
 *               
 *  Modification History
 *  Date          Who      Description 
 *  dd-mm-yyyy    ??    ??
 *                             
*******************************************************************************************/

    static testMethod void testInsert(){

    //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session".
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
        
    //New DF_Event__c Record to be added to the test Data.
    DF_EventAttendee__c dfEventAtt = new DF_EventAttendee__c(DF_Contact__c = df.Id, DF_Event__c = dfEvent.Id, DF_EntAtExt_Id__c = 1234);
        
        //Now insert data causing the DF_Event__c trigger to fire. 
        Test.startTest();
    insert dfEventAtt;
        Test.stopTest(); 
    }
    
    
    
  static testMethod void testBulkInsert(){
              
    //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session".
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
        
    //New DF_EventAttendee__c Records to be added to the test Data.
    DF_EventAttendee__c[] dfEventAttToCreate = new DF_EventAttendee__c[]{};
        
        for(Integer i=0; i< 200; i++){
            DF_EventAttendee__c dfEventAtt = new DF_EventAttendee__c(DF_Contact__c = df.Id, 
              DF_Event__c = dfEvent.Id, 
              DF_EntAtExt_Id__c = i
      );
            dfEventAttToCreate.add(dfEventAtt);
        }
        
        //Now insert data causing the DF_EventAttendee__c trigger to fire. 
        Test.startTest();
        insert dfEventAttToCreate;
        Test.stopTest(); 
    }    
    
    
    
    static testMethod void testUpdate(){
      
    //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session".
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
        
    //New DF_Event__c Record to be added to the test Data.
    DF_EventAttendee__c dfEventAtt = new DF_EventAttendee__c(DF_Contact__c = df.Id, DF_Event__c = dfEvent.Id, DF_EntAtExt_Id__c = 1234);
        insert dfEventAtt;
        
    Test.startTest();  //Start Executing the test.

    dfEventAtt.DF_EntAtExt_Id__c = 1235;
    update dfEventAtt;
            
        Test.stopTest();  //Stops the test execution.
                
        System.assertEquals(1235, [select DF_EntAtExt_Id__c from DF_EventAttendee__c where id =: dfEventAtt.id].DF_EntAtExt_Id__c);
  }
  
  
  
  static testMethod void testBulkUpdate(){
    
    //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session".
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
        
    //New Batch of DF_EventAttendee__c Records to be added to the test Data.
    List<DF_EventAttendee__c> lstDFEventAtt = new List<DF_EventAttendee__c>();

    for (Integer i=0 ; i <200; i++) {
      DF_EventAttendee__c dfEventAtt = new DF_EventAttendee__c(DF_Contact__c = df.Id, 
              DF_Event__c = dfEvent.Id, 
              DF_EntAtExt_Id__c = i
      );  
            lstDFEventAtt.add(dfEventAtt);
        }
        insert lstDFEventAtt;

    Integer i = 0;

    List<DF_EventAttendee__c> lstToUpdate = [select Id, DF_EntAtExt_Id__c from DF_EventAttendee__c where DF_EntAtExt_Id__c = 1234];
    for(DF_EventAttendee__c dfe : lstToUpdate){
            dfe.DF_EntAtExt_Id__c = i + 1;
        }
   
    Test.startTest();  //Start Executing the test.   
    update lstToUpdate;
        Test.stopTest();  //Stops the test execution.
  }
    
    
    
    static testMethod void testDelete(){
      
    //Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session".
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
        
    //New DF_Event__c Record to be added to the test Data.
    DF_EventAttendee__c dfEventAtt = new DF_EventAttendee__c(DF_Contact__c = df.Id, DF_Event__c = dfEvent.Id, DF_EntAtExt_Id__c = 1234);
        insert dfEventAtt; 
    
    Test.startTest();  //Start Executing the test.           
    delete dfEventAtt;
    Test.stopTest();  //Stops the test execution.
  }    
    
 
 
}