@isTest
public class WEBManageMySessions_Test {
	@testsetup  static void mytestdata(){   
        DF_DataFactory_Test.getTestData();
     	 /*Select DF_Event__c RecordTypeId for "Dementia Friend Awareness Session" .
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
        DF_Event__c dfEvent1 = new DF_Event__c(RecordTypeId = rTypedf.id, Name = 'Test DFEvent1', Session_Organiser__c = df.Id, Event_Date_Time__c = system.now());
        
        DF_Event__c dfEvent2 = new DF_Event__c(RecordTypeId = rTypedf.id, Name = 'Test DFEvent2', Session_Organiser__c = df.Id, Event_Date_Time__c = system.now());
        
        DF_Event__c dfEvent3 = new DF_Event__c(RecordTypeId = rTypedf.id, Name = 'Test DFEvent3', Session_Organiser__c = df.Id, Event_Date_Time__c = system.now());
        
        DF_Event__c dfEvent4 = new DF_Event__c(RecordTypeId = rTypedf.id, Name = 'Test DFEvent4', Session_Organiser__c = df.Id, Event_Date_Time__c = system.now());
        
        DF_Event__c dfEvent5 = new DF_Event__c(RecordTypeId = rTypedf.id, Name = 'Test DFEvent5', Session_Organiser__c = df.Id, Event_Date_Time__c = system.now());
        
   		
        insert (new List<DF_Event__c>{dfEvent1,dfEvent2, dfEvent3, dfEvent4, dfEvent5});*/
    }
    
    @isTest
    static void testManagesession() {
        RecordType rTypedfc = [Select Id from RecordType where DeveloperName ='Dementia_Friend_Champion' and SobjectType = 'DF_Contact__c'];
        DF_Contact__c champDfContact = [SELECT Id,Email__c, Portal_User__c,RecordTypeId 
                     FROM DF_Contact__c
                     WHERE Email__c = 'test.testcontact2@myemail.com'
                     LIMIT 1];
        User u = [SELECT Id FROM User WHERE UserName = :champDfContact.Email__c limit 1];
		champDfContact.Type_of_Champion__c = 'Super Champion';
        champDfContact.RecordTypeId = rTypedfc.Id;
        update champDfContact;
        
        Test.setCurrentPage( new PageReference('/apex/WEBChampionManageMySessions'));
        //User admin = new User(Id = champDfContact.Portal_User__c);
        System.runAs(u){
            //System.assertEquals(UserInfo.getUserType() , 'Guest', 'Not Logged in');
            WEBManageMySessions manage = new WEBManageMySessions();
            List<DF_Event__c> upcoming = manage.upcomingRequestedEvents;
            List<DF_Event__c> reqFeedback = manage.requestedEventsRequiringFeedback;
            List<DF_Event__c> unapproved = manage.unapprovedRequestedEvents;
            List<DF_Event__c> upcomingCreated = manage.upcomingCreatedEvents;
            List<DF_Event__c> pastCreated = manage.pastCreatedEvents;
            List<DF_Event__c> createdReqFeedback = manage.createdEventsRequiringFeedback;
            try{
            Page_Snippet__c totalSnippet = manage.totalFriendsSnippet;
            }catch(exception exp){}
        }
    	
    }
    
    
}