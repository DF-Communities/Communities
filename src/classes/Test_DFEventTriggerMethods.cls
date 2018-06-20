@isTest
private class Test_DFEventTriggerMethods{
    
   

     
     static testMethod void testDFEventTriggerMethods() {
        try{
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseDFeventGenerator());        
           test.starttest();
            Saved_Search__c ssavedsearch= new Saved_Search__c();
            ssavedsearch.Post_Code__c = '560033';
            ssavedsearch.Email__c = 'test@gmail.com';
            ssavedsearch.Sent_Mail__c= false;
            ssavedsearch.Range__c = 5;
            ssavedsearch.Geolocation__Latitude__s = 30;
            ssavedsearch.Geolocation__Longitude__s = 30;
            insert ssavedsearch;
            
            DF_Contact__c contact = new DF_Contact__c();
            contact.First_Name__c = 'simon';
            contact.Last_Name__c= 'molloy';
            contact.Name = 'simonm';
            insert contact;
            
            DF_Event__c dfevent= new DF_Event__c();
            dfevent.Postcode__c = '560033';
            dfevent.Location_Geographic_Details__Latitude__s = 30;
            dfevent.Location_Geographic_Details__Longitude__s = 30;
            dfevent.Session_Organiser__c = contact.id;
            insert dfevent;
            
            DF_Event__c dfevent1 = new DF_Event__c();
            dfevent1.Postcode__c = '516001';
            dfevent1.Session_Organiser__c = contact.id;
            insert dfevent1;
            
            
            Set<Id> dfeventIds = new Set<Id>();
            dfeventIds.add(dfevent.Id);            
            dfeventIds.add(dfevent1.Id); 
           
            DFEventTriggerMethods.sendEmailToMembers(dfeventIds); 
           
            Double d1 = 90.0;
            Double d2 = 60.0;
            Double d3 = 70.0;
            Double d4 = 50.0;
            
            DFEventTriggerMethods.calculateDistance(d1,d2,d3,d4);
            test.stoptest();
        }
        catch(Exception e){}     
      
    } 
    
    static testMethod void testDFEventTriggerMethods2() {
        try{
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseDFeventGenerator());        
           test.starttest();
            Saved_Search__c ssavedsearch= new Saved_Search__c();
            ssavedsearch.Post_Code__c = '560033';
            ssavedsearch.Email__c = 'test@gmail.com';
            ssavedsearch.Sent_Mail__c= false;
            ssavedsearch.Geolocation__Latitude__s = 30;
            ssavedsearch.Geolocation__Longitude__s = 30;
            insert ssavedsearch;
            
            Map<String,Id> roles = new Map<String,Id>();
            List<UserRole> rl = [select id, name from UserRole];
        for(UserRole r : rl){ roles.put(r.name, r.id); }
            
             User sysAdminUser =  [select id from user where UserRoleId =:roles.get('CEO') and isActive=true limit 1];
            Account a = new Account(Name='Test Account Name');
            a.OwnerId = sysAdminUser.id;
            insert a;
            
            Contact c = new Contact();
            c.firstname = 'Test';
            c.LastName = 'TestContact';
            c.AccountId = a.Id;
            c.Email = 'test.testcontact@myemail.com';
            c.Salutation='Mr';
            insert c;
            
            DF_Contact__c contact = new DF_Contact__c();
            contact.First_Name__c = 'simon';
            contact.Last_Name__c= 'molloy';
            contact.Name = 'simonm';
            contact.Email__c = 'simonm@test.com';
            contact.Portal_Contact__c=c.Id;
            insert contact;
            
            
            DF_Event__c dfevent= new DF_Event__c();
            dfevent.Postcode__c = '560033';
            dfevent.Location_Geographic_Details__Latitude__s = 30;
            dfevent.Location_Geographic_Details__Longitude__s = 50;
            dfevent.Session_Organiser__c = contact.id;
            insert dfevent;
            
            DF_Event__c dfevent1 = new DF_Event__c();
            dfevent1.Postcode__c = '516001';
            dfevent1.Session_Organiser__c = contact.id;
            dfevent1.RecordTypeId = DF_Utils.getsObjectRecordTypeId('DF_Event__c','Dementia_Friend_Awareness_Session');
            dfevent1.Event_Date_Time__c = system.now()+5 ;
            insert dfevent1;
            
             
            DF_EventAttendee__c eAt2 = new DF_EventAttendee__c ();
            eAt2.DF_Contact__c = contact.id;
            eAt2.DF_Event__c = dfevent1.id;
        
            insert eAt2 ;
            
            Map<Id, DF_Event__c>  mapevents = new  Map<Id, DF_Event__c> ();
            mapevents.put(dfevent1.Id,dfevent1);
            List<DF_Event__c> lisdfevent = [select Postcode__c from DF_Event__c where Postcode__c='516001'];
            lisdfevent[0].Postcode__c='TE12 2RE';
            update lisdfevent[0];
                        
            Set<Id> dfeventIds = new Set<Id>();
            dfeventIds.add(dfevent.Id);            
            dfeventIds.add(dfevent1.Id); 
          
           
            DFEventTriggerMethods.sendEmailToMembers(dfeventIds); 
             DFEventTriggerMethods.sendEmailNotifications(lisdfevent, mapevents);
             List<DF_Event__c> lisdfeventcancel = [select Postcode__c from DF_Event__c where Postcode__c='TE12 2RE'];
            lisdfeventcancel[0].Event_Status__c = 'Cancelled';
            
            update lisdfeventcancel[0];
             DFEventTriggerMethods.sendEmailNotifications(lisdfeventcancel, mapevents);
            Double d1 = 90.0;
            Double d2 = 60.0;
            Double d3 = 70.0;
            Double d4 = 50.0;
            
            DFEventTriggerMethods.calculateDistance(d1,d2,d3,d4);
            test.stoptest();
        }
        catch(Exception e){}     
      
    } 
    
 static testMethod void setUpSystemData(){
 /*   String FRIEND_RT_NAME = 'Dementia_Friend';
    String CHAMPION_RT_NAME = 'Dementia_Friend_Champion';
    String SESSION_RT_NAME = 'Dementia_Friend_Awareness_Session';
    String TRAINING_RT_NAME = 'Champion_Training_Course';
    String STATUS_CANCELLED = 'Cancelled';*/
    
   // User adminUser;
   // User guestUser;
    User portalUser;
    Contact contactRecord;
    Contact soContactRecord;
    DF_Contact__c sessionOrganiser;
    DF_Contact__c dfContactRecord;
    DF_Event__c testSession;
    DF_Event__c testTraining;
    DF_EventAttendee__c dfe1;
    DF_EventAttendee__c dfe2;
    /*
        RecordType dfcFriend = [select r.Id from RecordType r where r.DeveloperName = :FRIEND_RT_NAME and r.SobjectType = 'DF_Contact__c' and IsActive = true LIMIT 1];
        RecordType cFriend = [select r.Id from RecordType r where r.DeveloperName = :FRIEND_RT_NAME and r.SobjectType = 'Contact' and IsActive = true LIMIT 1];
        RecordType dfcChampion = [select r.Id from RecordType r where r.DeveloperName = :CHAMPION_RT_NAME and r.SobjectType = 'DF_Contact__c' and IsActive = true LIMIT 1];
        RecordType cChampion = [select r.Id from RecordType r where r.DeveloperName = :CHAMPION_RT_NAME and r.SobjectType = 'Contact' and IsActive = true LIMIT 1];
       */ 
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
        portalUser= (User)mapTestData.get('adminUser');
        test.starttest();
       // adminUser = [Select Id From User Where Profile.Name='System Administrator' And IsActive=true limit 1];
        //guestUser = [Select Id From User Where UserType='Guest' limit 1];
        //portalUser = [Select Id, ContactId from User where Profile.Name='DF HVCP' and IsActive = true LIMIT 1];
        contactRecord = (contact)mapTestData.get('contact');
        //soContactRecord = [Select FirstName, LastName, Email from Contact where RecordTypeId = :cChampion.Id LIMIT 1];
        
    /*    Global_Setting__c setting = Global_Setting__c.mapTestData('webAccountOwnerId');
        if (setting == null){
            setting = new Global_Setting__c(Name='webAccountOwnerId',Value__c=adminUser.Id);
            insert setting;
        }*/
        List<DF_Contact__c> dfConList = new List<DF_Contact__c>();
        dfConList = [select d.First_Name__c, d.Last_Name__c, d.Email__c, d.RecordTypeId, d.Portal_Contact__c from DF_Contact__c d where d.Portal_Contact__c = :contactRecord.Id LIMIT 1];
        if (dfConList.size() == 0){
            dfContactRecord =(DF_Contact__c)mapTestData.get('DFc2');
        }else {
            dfContactRecord = dfConList[0];
        }
        
        
        
        testSession = (DF_Event__c)mapTestData.get('FriendSession');
        
        testTraining = (DF_Event__c)mapTestData.get('ChampCourse');
        
        dfe1 = (DF_EventAttendee__c)mapTestData.get('ChampAtten');
        dfe2 = (DF_EventAttendee__c)mapTestData.get('FriendAtten');
    }
  
   
    static void testSessionTrigger() {
       // setupSystemData();
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
        DF_Event__c fevent= (DF_Event__c)mapTestData.get('FriendSession');
    
        //Update the session and save it - this should fire the 'update' email 
        test.starttest();
        fevent.Event_Description__c = 'This is an update';
        update fevent;
        
        //Now we cancel the session, and this should fire the 'cancellation' email
        fevent.Event_Status__c = 'Cancelled';
        update fevent;  

             
    }
    
   
    
}