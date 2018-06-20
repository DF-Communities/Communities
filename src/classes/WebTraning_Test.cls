@isTest
public class WebTraning_Test{
 static testmethod  void TestWEBTraining(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Profile p1 = [SELECT Id FROM profile WHERE name='DF HVCP'];
        Page_Snippet__c  pagesnipp=new Page_Snippet__c(Body_Text__c='SampleText',Unique_Name__c='savesearchsnippet');
          
        Account acc=new  Account(Name='Acme');
        insert acc;
        
        Contact c=new Contact(LastName='SampleContact');
        c.accountId = acc.Id;
        c.email = 'test12@gmail.com';
        c.firstName = 'firstName';
        c.lastName = 'lastName';
        insert(c);
        
        Contact c1 = new Contact(LastName='SampleContact4');
        c1.accountId = acc.Id;
        c1.email = 'test412@gmail.com';
        c1.firstName = 'firstName4';
        c1.lastName = 'lastName4';
        insert(c1);
        
        RecordType rt = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Event__c' and r.DeveloperName='Dementia_Friend_Awareness_Session'];
        RecordType rt12 = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Contact__c' and Name='Dementia Friend'] ;
        RecordType rt13 = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Contact__c' and Name='Dementia Friend Champion'] ;

        List<DF_Event__c> dfEventList = new List<DF_Event__c>();
        List<DF_Contact__c> dfContactList = new List<DF_Contact__c>();

        DF_Contact__c dfc = new DF_Contact__c(Name='testname',First_Name__c='testfirsname1',Last_Name__c='testlastname1',Portal_Contact__c=c.id,Recordtypeid=rt12.id, EMail__c = 'testfirstname1.testlastname1@myemail.com');
        //dfContactList.add(dfc);
        insert dfc;
        
        DF_Contact__c dfc1 = new DF_Contact__c(Name='testname',First_Name__c='testfirsname',Last_Name__c='testlastname',Portal_Contact__c=c.id,Recordtypeid=rt13.id, Email__c = 'testfirstname.testlastname@myemail.com');
        //dfContactList.add(dfc1);
        insert dfc1;
        
        DateTime endDateTime = system.now().addDays(1);
        DF_Event__c devent=new DF_Event__c(Event_Date_Time__c =system.now(),Event_End_Date_Time__c=endDateTime.addHours(3),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=33,Number_of_Attendees__c=4,Name='samlpla Name',Location__c='Sample Location',Event_Status__c='Available',Event_Ext_Id__c=5495);
        dfEventList.add(devent);
        
        DF_Event__c  devent1=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(2),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name',Location__c='Sample Location',Event_Ext_Id__c=5491);
        dfEventList.add(devent1);

        DF_Event__c  devent2=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(3),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street1',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name1',Location__c='Sample Location2',Event_Ext_Id__c=5492);
        dfEventList.add(devent2);
        
        DF_Event__c  devent3=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(1),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name2',Location__c='Sample Location',Event_Ext_Id__c=5493);
        dfEventList.add(devent3);
        
        DF_Event__c  devent4=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(4),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name2',Location__c='Sample Location',Event_Ext_Id__c=5496);
        dfEventList.add(devent4);
        
        DF_Event__c  devent5=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(5),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name2',Location__c='Sample Location',Event_Ext_Id__c=5497);
        dfEventList.add(devent5);
        
        //Do the insert of the test records
        insert dfContactList;
        insert dfEventList;
        
        DF_EventAttendee__c DevAtten=new DF_EventAttendee__c(DF_Contact__c=dfc.id,DF_Event__c=devent.id);
        insert DevAtten;
        
        ApexPages.currentPage().getParameters().put('Id',devent.id);  

        Saved_Search__c ss=new Saved_Search__c(Type__c='Session',Email__c='sampleemail@gmail.com',Post_Code__c='3434',Range__c=564);   
        
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
        u1.contactId = c.Id;
        insert u1;  
         
        test.startTest(); 
        system.runAs(u1){
            ApexPages.currentPage().getParameters().put('Id',devent.id);
            WEBTraining websee=new WEBTraining();
            websee.searchRange = string.valueof(ss.Range__c);
            websee.saveSearch();
            websee.selectedEvent = new WEBTraining.EventWrapper(devent);
            websee.bookOnSession();
            websee.showUnavailable = false;
            websee.applyFilter();
            websee.searchPostCode = 'SL6 1HY';
            websee.applyFilter();
            websee.attendanceRecord = DevAtten;
           // websee.removeFromSession();
        }  
        test.stopTest();
    }
}