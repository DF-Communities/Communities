@isTest
 public class WEBChampionCreateEditSession_Test{

 static testmethod  void tesWEBChampionCreate() 
   {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Profile p1 = [SELECT Id FROM profile WHERE name='DF HVCP'];
        
        Page_Snippet__c  pagesnipp=new Page_Snippet__c(name__c='sample',Body_Text__c='SampleText',Unique_Name__c='DementiaFriendsTotalSnippet');
        Insert  pagesnipp;
        Page_Snippet__c  pagesnipp1=new Page_Snippet__c(name__c='sample',Body_Text__c='SampleText2',Unique_Name__c='CreateSessionNameHelp');
        Insert  pagesnipp1;
        Page_Snippet__c  pagesnipp2=new Page_Snippet__c(name__c='sample',Body_Text__c='SampleText3',Unique_Name__c='CreateSessionDateHelp');
        Insert  pagesnipp2;
        Page_Snippet__c  pagesnipp3=new Page_Snippet__c(name__c='sample',Body_Text__c='SampleText4',Unique_Name__c='CreateSessionVisibleHelp');
        Insert  pagesnipp3;
        Page_Snippet__c  pagesnipp4=new Page_Snippet__c(name__c='sample',Body_Text__c='SampleText5',Unique_Name__c='CreateSessionStatusHelp');
        Insert  pagesnipp4;
        Page_Snippet__c  pagesnipp5=new Page_Snippet__c(name__c='sample',Body_Text__c='SampleText6',Unique_Name__c='CreateSessionPlacesHelp');
        Insert  pagesnipp5;
        Page_Snippet__c  pagesnipp6=new Page_Snippet__c(name__c='sample',Body_Text__c='SampleText7',Unique_Name__c='CreateSessionDescriptionHelp');
        Insert  pagesnipp6;
        
        Page_Snippet__c  pagesnipp7=new Page_Snippet__c(name__c='sample',Body_Text__c='SampleText8',Unique_Name__c='CreateSessionWheelchairHelp');
        Insert  pagesnipp7;
        
        
        
         Account acc=new  Account(Name='Acme');
        Insert acc;
        
        Contact c1 = new Contact(LastName='SampleContact');
        c1.accountId = acc.Id;
        c1.email = 'test12@gmail.com';
        c1.firstName = 'firstName';
        c1.lastName = 'lastName';
        insert(c1);
        
        
        RecordType rt = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Event__c' and r.DeveloperName='Dementia_Friend_Awareness_Session'];
        
        
        RecordType rt12 = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Contact__c' and Name='Dementia Friend'] ;
        
        RecordType rt13 = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Contact__c' and Name='Dementia Friend Champion'] ;

        DF_Contact__c dfcon = new DF_Contact__c(Name='testname',First_Name__c='testfirsname',Last_Name__c='testlastname',Portal_Contact__c=c1.id,Recordtypeid=rt13.id, Email__c = 'test.testcontact@myemail.com');
        insert dfcon;
    
        DF_Event__c evnt = new DF_Event__c(Name='test12',Event_Description__c='test Description',Event_Status__c='Available',Event_Date_Time__c=system.now(),Event_End_Date_Time__c=system.now().addHours(2),Street__c='teststreet',City__c='testcity',County__c='uk',Postcode__c='12345678912',Number_of_Places__c=1234,Session_Organiser__c=dfcon.id); 
       
        insert evnt;
       
       /******************** Creating user for Webcontroller******************/
        User u1 = new User();
         u1.username =  'Advavabd@acmecorp.com';
         u1.email = 'Sampleemail@gmail.com';
         u1.lastName = 'lastName';
         u1.firstName = 'FirstName';
         String alias = 'advanchgi';
         //Alias must be 8 characters or less
         if(alias.length() > 8) {
            alias = alias.substring(0, 8);
         }
         u1.alias = alias;
         u1.languagelocalekey = 'en_US';
         u1.localesidkey = 'en_US';
         u1.emailEncodingKey = 'UTF-8';
         u1.timeZoneSidKey = 'America/Los_Angeles';
         u1.profileId = p1.Id;
         u1.contactId = c1.Id;
         insert u1;  
       
       /*******************************************************/
  
    
    
     
     DF_Contact__c dfcnt = new DF_Contact__c(Name='Testdfcontact12',First_Name__c='Test12',Last_Name__c='dfcontact12',Status__c='Prospective',Email__c='test12@dfcon.com',
     RecordTypeId=[Select Id from RecordType where SObjectType='DF_Contact__c' and Name Like 'Dementia Friend Champion'].Id,
                                            Contact_Number__c='12385678',Eligible__c=FALSE,Contacted__c=FALSE,
                                            Attended__c=FALSE,Note__c='Test Notes2'); 
     insert dfcnt;
      ApexPages.currentPage().getParameters().put('eventId', evnt.id);
     System.runAs(u1)
    {    
    
    Pagereference pr = page.WEBChampionCreateEditSession;
    WEBChampionCreateEditSession webch = new WEBChampionCreateEditSession();
    
     webch.totalFriendsSnippet=null;
     Page_Snippet__c pp=webch.totalFriendsSnippet;
     webch.createSessionNameHelp=null;
     Page_Snippet__c pp1=webch.createSessionNameHelp;
     webch.CreateSessionDateHelp=null;
     Page_Snippet__c pp2=webch.CreateSessionDateHelp;
     webch.CreateSessionVisibleHelp=null;
     Page_Snippet__c pp3=webch.CreateSessionVisibleHelp;
     webch.CreateSessionStatusHelp=null;
     Page_Snippet__c pp4=webch.CreateSessionStatusHelp;
     webch.CreateSessionPlacesHelp=null;
     Page_Snippet__c pp5=webch.CreateSessionPlacesHelp;
     webch.CreateSessionDescriptionHelp=null;
     Page_Snippet__c pp6=webch.CreateSessionDescriptionHelp;
     webch.CreateSessionWheelchairHelp=null;
     Page_Snippet__c pp7=webch.CreateSessionWheelchairHelp;
  
     
   //  webch.isSuccess = TRUE;
     webch.getEventStatusOptions();
     List<SelectOption> lis = webch.visibleOptions;
     lis = webch.getSessionTypeOptions();
     lis = webch.getFootballTeamOptions();
     lis = webch.getTimeHour();
     lis = webch.getTimeMinute();
     webch.saveSession();
    
     /*******/
     
     // evnt.Session_Organiser__c = dfcnt.id;
    //  update evnt;                                      
     
     PageReference pageRef = Page.WEBChampion;
      Test.setCurrentPage(pageref);
   }   
}
}