@isTest
 public class WEBSession_Test{
 static testmethod  void TestWEBSession()
    {
      Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u  = (User)mapTestData.get('User');
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        DF_Event__c devent = (DF_Event__c)mapTestData.get('FriendSession');
        DF_EventAttendee__c  DevAtten = (DF_EventAttendee__c)mapTestData.get('FriendAtten');
       
       test.starttest();
      
        PageReference pageRef = Page.WEBSessionDetails;
        pageRef.getParameters().put('Id',devent.id);
        test.setCurrentPage(pageRef);
        //ApexPages.currentPage().getParameters().put('Id',devent.id);  

           
       // insert ss;
       
 
    } 
    
     static testmethod  void TestWEBSession2()
    {
      Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u  = (User)mapTestData.get('User');
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        DF_Event__c devent = (DF_Event__c)mapTestData.get('FriendSession');
        DF_EventAttendee__c  DevAtten = (DF_EventAttendee__c)mapTestData.get('FriendAtten');
          
       Saved_Search__c ss=new Saved_Search__c(Type__c='Session',Email__c='sampleemail@gmail.com',Post_Code__c='3434',Range__c=564);
       System.runAs(u)
       {
         pagereference pr = page.WEBSession;
         
          test.setCurrentPage(pr);
          test.starttest();
        
            WEBSession  websee=new WEBSession();
            websee.searchRange = string.valueof(ss.Range__c);
            
            
            websee.selectedEvent = new WEBSession.EventWrapper(devent);
                   
           websee.bookOnSession();
           // DevAtten.DF_Event__c = devent1.id;
           // update DevAtten ;
           // websee.removeFromSession();
           websee.showUnavailable = false;
           
            websee.applyFilter();
            websee.attendanceRecord = DevAtten;
            //websee.removeFromSession();

          //  websee.attendanceRecord();
           // websee.EventWrapper webeven = new websee.EventWrapper();
            websee.saveSearch();
           Map<String, String> stringMap =websee.getLatLong('IG1 3HY');
           websee.nextPage();
           websee.previousPage();
           websee.changeRecordsPerPage();
           Boolean success =websee.showSuccess;
          Map<String, String> locationmap =websee.getLatLong('Ig1 3lq');
          system.assertNotEquals(null,websee.removeFromSession());
        }  
        
       
    }  
    
  }