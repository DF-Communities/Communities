/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class WEBChampionSessionFeedback_Test {
   @testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }
       //Test methods
   static testmethod  void tesWEBChampionFeedback(){
     List<Partner_Organisation__c> partner = [select id,Sector__c,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1];     
     List<DF_Contact__c> dfcon =[select id,name__c from DF_Contact__c where email__c = 'test.testcontact@myemail.com' limit 1];
     List<Po_Administrator__c> po = [select id from Po_Administrator__c where DF_Contact__c =: dfcon[0].id limit 1];
     
     dfcon[0].RecordTypeId = DF_Utils.getsObjectRecordTypeId('DF_Contact__c','Dementia_Friend_Champion');
     dfcon[0].Partner_Organisation_Id__c = partner[0].Id;
     update dfcon[0]; 
     DF_Event__c evnt = new DF_Event__c(Name='test12',Event_Description__c='test Description',Event_Status__c='Available',Event_Date_Time__c=system.now(),Street__c='teststreet',City__c='testcity',County__c='uk',Postcode__c='12345678912',Number_of_Places__c=1234,
                                 Session_Organiser__c=dfcon[0].id,Comments__c ='testcommetns',Number_of_Attendees__c=1234); 
     insert evnt;
     System.runAs(u[0]) {
     PageReference pageRef = Page.WEBFriendEditMyDetails; 
     pageRef.getParameters().put('eventId', evnt.id);
     test.startTest();
     WEBChampionSessionFeedback webfeedback = new WEBChampionSessionFeedback();
     webfeedback.selectedSession =evnt.id;
     webfeedback.ispartnerSession = true;
     webfeedback.selectedPartner = partner[0].Id;
     webfeedback.noOfAttendees =5;
     system.assertEquals(1,webfeedback.partnerListSize);
     system.assertNotEquals(null,webfeedback.save());
     webfeedback.selectedPartner = 'none';
     system.assertNotEquals(null,webfeedback.partnerError);
     system.assertNotEquals(null,webfeedback.thereAreNoSessions);
     system.assertNotEquals(null,webfeedback.eventsRequiringFeedback);
     system.assertNotEquals(null,webfeedback.sessionList);
     system.assertNotEquals(null,webfeedback.sessionListSize);
     webfeedback.save();
     }
      
   }
   static testmethod void tesWEBChampionFeedbacktwo(){
     
     DF_Contact__c dfcon = new DF_Contact__c(Name='Test dfcontact',First_Name__c='Test',Last_Name__c='dfcontact',Status__c='Prospective',Email__c='test@dfcon.com',
     RecordTypeId=[Select Id from RecordType where SObjectType='DF_Contact__c' and Name Like 'Dementia Friend Champion'].Id,
                                              Contact_Number__c='12345678',Eligible__c=FALSE,Contacted__c=FALSE,
                                              Attended__c=FALSE,Note__c='Test Notes');
      insert dfcon;
      
     DF_Event__c evnt = new DF_Event__c(Name='test12',Event_Description__c='test Description',Event_Status__c='Available',Event_Date_Time__c=system.now(),Street__c='teststreet',City__c='testcity',County__c='uk',Postcode__c='12345678912',Number_of_Places__c=1234,
                                 Session_Organiser__c=dfcon.id,Comments__c ='testcommetns',Number_of_Attendees__c=1234,Type_Of_Session__c ='test'); 
     insert evnt;
     system.debug('event inserted'+evnt);
     
   // ApexPages.currentPage().getParameters().put('eventId', evnt.id);
     test.startTest();
     WEBChampionSessionFeedback webfeedback = new WEBChampionSessionFeedback();
     webfeedback.dfc = dfcon;
     webfeedback.selectedSession = evnt.id;
     webfeedback.noOfAttendees =5;
     string s = webfeedback.messageArea;
     string s2 = webfeedback.messageAreaClass;
     webfeedback.cancelSession();
     webfeedback.save();
      
      
   }
   }