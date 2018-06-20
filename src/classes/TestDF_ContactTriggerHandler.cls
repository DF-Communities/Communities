@isTest
public with sharing class TestDF_ContactTriggerHandler{
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test Class for DF_ContactTriggerHandler Trigger.
 *  Author  : Ian Smith
 *  Date    : 23-01-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Apex Class to test DF_ContactTriggerHandler trigger on the DF_Contact__c object. 
 *               
 *  Modification History
 *  Date            Who     Description 
 *  dd-mm-yyyy      ??      ??
 *  12-03-2014      MT      Update for new routines for update stats
 *  11-04-2014      MT      Updated to add First & Last name whicha are now required.  Email has to be unique.  
 *                             
*******************************************************************************************/

    static testMethod void testInsert(){
        //record for champion
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'Dementia Friend Champion' AND isActive = TRUE];
        //record for RSO
        RecordType rtRSO = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'RSO' AND isActive = TRUE];
              
        //RSO
        DF_Contact__c dfRSO = new DF_Contact__c(Name='Test RSO',First_Name__c = 'Test', Last_Name__c ='RSO', Postcode__c='NW1 2XX', recordtypeid=rtRSO.id, Email__c='test.test'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alzheimers.org.uk');
        insert dfRSO;
        
        //RSO Area Lookup
        RSO_AreaLookup__c dfAreaLookup = new RSO_AreaLookup__c(Name='Test RSO',DFContactId__c=dfRSO.id,Postcode_Supported__c='NW,SE');
        insert dfAreaLookup; 
               
        //New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(Name='Test DFC',First_Name__c = 'Test', Last_Name__c ='DFC', 
                                            Contact_Ext_Id__c = 12345678, Postcode__c='NW1 2XX', recordtypeid=rt.id, Email__c='test.testDFC'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alzheimers.org.uk');
        
        //Now insert data causing the DF_Contact__c trigger to fire. 
        Test.startTest();
        insert df;
        Test.stopTest(); 
    }
    
    
    
   /* static testMethod void testBulkInsert(){
              
        //New Partner_Organisation__c Record to be added to the DF_Contact__c test Data.
        Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
      
        insert pa;              
        
        //New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c[] dfConToCreate = new DF_Contact__c[]{};
        
        //Create 200 new DF_Contact Records for a Bulk test.
        for(Integer i=0; i< 200; i++){
            DF_Contact__c df = new DF_Contact__c(Name = 'Test DF Con',
                First_Name__c = 'Test',
                Last_Name__c ='DFC',
                Email__c= 'email'+datetime.now().format('YYYYMMDDhhmmsshhmm')+i+'@test.com',
                Contact_Ext_Id__c = i,
                Partner_Organisation_ID__c = pa.id
            );
            dfConToCreate.add(df);
        }
        
        //Now insert data causing the DF_Contact__c trigger to fire. 
         Test.startTest();   
        insert dfConToCreate;
        Test.stopTest();    
    }  */  
    
    
    
    static testMethod void testUpdate(){
       //record for champion
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'Dementia Friend Champion' AND isActive = TRUE];
        //record for RSO
        RecordType rtRSO = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'RSO' AND isActive = TRUE];
                            
        //RSO
        DF_Contact__c dfRSO = new DF_Contact__c(Name='Test RSO',First_Name__c = 'Test', Last_Name__c ='RSO',Postcode__c='NW1 2XX', recordtypeid=rtRSO.id, Email__c='test.test'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alzheimers.org.uk');
        insert dfRSO;
        
        //RSO Area Lookup
        RSO_AreaLookup__c dfAreaLookup = new RSO_AreaLookup__c(Name='Test RSO',DFContactId__c=dfRSO.id,Postcode_Supported__c='NW,SE');
        insert dfAreaLookup;        
        
        // New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(Name='Test DFC', First_Name__c = 'Test', Last_Name__c ='DFC', Contact_Ext_Id__c = 12345678, Postcode__c='NW1 2XX', recordtypeid=rt.id, Email__c='test.testDFC'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alzheimers.org.uk');
         insert df;  
         
        Test.startTest();  // Start Executing the test.

        df.Name = 'TestDFC';
        df.First_Name__c = 'Test FirstName';
        df.Last_Name__c = 'Test LastName';
        df.Postcode__c='NW1 2YY';  
        update df;
                
        Test.stopTest();  // Stops the test execution.
                
        System.assertEquals('Test FirstName Test LastName', [select Name from DF_Contact__c where id =: df.id].Name);
    }
    
    //2014-06-25 : CSL : Test method for testing DFContactTriggerMethods.dedupeDFContacts(inDFContacts)
    static testMethod void testDedupe(){
       //record for champion
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'Dementia Friend Champion' AND isActive = TRUE];
        //record for RSO
        RecordType rtRSO = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'RSO' AND isActive = TRUE];
                            
        //RSO
        DF_Contact__c dfRSO = new DF_Contact__c(Name='Test RSO',First_Name__c = 'Test', Last_Name__c ='RSO',Postcode__c='NW1 2XX', recordtypeid=rtRSO.id, Email__c='test.test'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alzheimers.org.uk');
        insert dfRSO;
        
        //RSO Area Lookup
        RSO_AreaLookup__c dfAreaLookup = new RSO_AreaLookup__c(Name='Test RSO',DFContactId__c=dfRSO.id,Postcode_Supported__c='NW,SE');
        insert dfAreaLookup;        
        
        // New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(Name='Test DFC', First_Name__c = 'Test', Last_Name__c ='DFC', Contact_Ext_Id__c = 12345678, Postcode__c='NW1 2XX', recordtypeid=rt.id, Email__c='test.testDFC@alzheimers.org.uk');
         insert df;  
         
        Test.startTest();  // Start Executing the test.

		List<DF_Contact__c> dfContactList = new List<DF_Contact__c>();
		dfContactList.add(new DF_Contact__c(Name='Test DFC', First_Name__c = 'Test', Last_Name__c ='DFC', Contact_Ext_Id__c = 12345678, Postcode__c='NW1 2XX', recordtypeid=rt.id, Email__c='test.testDFC@alzheimers.org.uk'));
		DFContactTriggerMethods.dedupeDFContacts(dfContactList);		
                
        Test.stopTest();  // Stops the test execution.
        
    }
  
    static testMethod void testChangeOfRTUpdate(){
       //record for champion
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'Dementia Friend Champion' AND isActive = TRUE];
      //record for friend
        RecordType rtDF = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'Dementia Friend' AND isActive = TRUE];
         //record for RSO
        RecordType rtRSO = [SELECT Id, Name FROM RecordType WHERE sObjectType =: 'DF_Contact__c' AND Name =: 'RSO' AND isActive = TRUE];
                           
        //RSO
        DF_Contact__c dfRSO = new DF_Contact__c(Name='Test RSO',First_Name__c = 'Test', Last_Name__c ='RSO', Postcode__c='NW1 2XX', recordtypeid=rtRSO.id, Email__c='test.test'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alzheimers.org.uk');
        insert dfRSO;
        
        //RSO Area Lookup
        RSO_AreaLookup__c dfAreaLookup = new RSO_AreaLookup__c(Name='Test RSO',DFContactId__c=dfRSO.id,Postcode_Supported__c='NW,SE');
        insert dfAreaLookup;        
        
        // New DF_Contact__c Record to be added to the test Data.
        //DF_Contact__c df = new DF_Contact__c(Name='Test DFC Con', Partner_Organisation_ID__c = pa.id, Contact_Ext_Id__c = 12345678, Postcode__c='NW1 2XX', recordtypeid=rtDF.id, Email__c='test.test'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@alzheimers.org.uk', Total_No_of_Friends_Created__c=1);
        //insert df;  

        //New Batch of DF_Contact__c Records to be added to the test Data.
        DF_Contact__c[] lstDFContact = new DF_Contact__c[]{};

        //Create THREE new DF_Contact Records for a Bulk test.
        for (Integer i=0 ; i <3; i++) {
            DF_Contact__c df = new DF_Contact__c(
                Name = 'Test DF Con',
                First_Name__c = 'Test',
                Last_Name__c ='DF Con',
                Email__c= 'emailadfkajfdkj'+datetime.now().format('YYYYMMDDhhmmsshhmm')+i+'@test.com',
                Contact_Ext_Id__c = i
            );  
            lstDFContact.add(df);
        }
        insert lstDFContact;
        
        Test.startTest();  // Start Executing the test.
        List<DF_Contact__c> lstToUpdate = [select Id, Name from DF_Contact__c where Name = 'Test DF Con'];

        for(DF_Contact__c df : lstToUpdate){
            df.Name = 'TestDFC';
            df.First_Name__c = 'Test FirstName';
            df.Last_Name__c = 'Test LastName';
            df.Postcode__c='NW1 2YY';  
            df.recordtypeid=rt.id;                //change of record type to Champion
        }
        update lstToUpdate;

        for(DF_Contact__c df : lstToUpdate){
            df.recordtypeid=rtDF.id;
        }
        update lstToUpdate;

        //df.Partner_Organisation_ID__c =pa2.id;
        for(DF_Contact__c df : lstToUpdate){
            df.recordtypeid=rt.id;                //change of record type to Champion
        }
        update lstToUpdate;
              
        Test.stopTest();  // Stops the test execution.

    }
   
  
    static testMethod void testBulkUpdate(){
        
        //New Partner_Organisation__c Record to be added to the DF_Contact__c test Data.
        Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
        insert pa;              
        
        //New Batch of DF_Contact__c Records to be added to the test Data.
        List<DF_Contact__c> lstDFContact = new List<DF_Contact__c>();

        //Create 200 new DF_Contact Records for a Bulk test.
        for (Integer i=0 ; i <200; i++) {
            DF_Contact__c df = new DF_Contact__c(
                Name = 'Test DF Con',
                First_Name__c = 'Test',
                Last_Name__c ='DFC',
                Email__c= 'emailadfkajfdkj'+datetime.now().format('YYYYMMDDhhmmsshhmm')+i+'@test.com',
                Contact_Ext_Id__c = i,
                Partner_Organisation_ID__c = pa.id
            );  
            lstDFContact.add(df);
        }

        List<DF_Contact__c> lstToUpdate = [select Id, Name from DF_Contact__c where Name = 'Test DF Con'];
        for(DF_Contact__c df : lstToUpdate){
            df.Name = 'TestDFcon';
        }
     
        Test.startTest();  // Start Executing the test.  
        update lstToUpdate;
        Test.stopTest();  // Stops the test execution.
    }
    
    
    
    static testMethod void testDelete(){

        //New Partner_Organisation__c Record to be added to the DF_Contact__c test Data.
        Partner_Organisation__c pa = new Partner_Organisation__c(Name='Test Org', DFC_Code__c='ABC123', Partner_External_Id__c=1234);
        insert pa;              
        
        //New DF_Contact__c Record to be added to the test Data.
        DF_Contact__c df = new DF_Contact__c(Name='Test DFC', 
                                            First_Name__c = 'Test', Last_Name__c ='DFC', 
                                            Email__c= 'emailadfkajfdkjDFC'+datetime.now().format('YYYYMMDDhhmmsshhmm')+'@test.com',
                                            Partner_Organisation_ID__c = pa.id, Contact_Ext_Id__c = 12345678,Total_No_of_Friends_Created__c=10);
        insert df;
        
        Test.startTest();  // Start Executing the test.            
        delete df;
        Test.stopTest();  // Stops the test execution.
  }    
    
 
 
}