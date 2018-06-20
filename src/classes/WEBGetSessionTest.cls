/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBChampion.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex test class.
 *               
 *  Modification History
 *  Date            Who         Description 
 *                    
*******************************************************************************************/
@isTest(seeAllData=false)
public with sharing class WEBGetSessionTest {
        static testMethod void loggedInTest() {
            
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact();
            c.firstname = 'Test';
            c.LastName = 'TestContact';
            c.AccountId = a.Id;
            c.Email = 'test.testcontact@myemail.com';
            insert c;
            
        Partner_Organisation__c po = new Partner_Organisation__c();
        po.Name = 'Test';
        po.DFC_Code__c = 'abc123';
        insert po;
            
        Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP']; 
        
        User loggedInUser = new User(Alias = 'standt',Email='light@testorg.com',EmailEncodingKey='UTF-8',LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = profileForUser.Id, TimeZoneSidKey='America/Los_Angeles',UserName=Math.random() + '@test.com',ContactId =c.id );
        insert loggedInUser;   
        
        DF_Contact__c DFc = new DF_Contact__c();
        DFc.RecordTypeId = [Select Id From RecordType Where DeveloperName=:WEBConversionClass.RT_CONTACT_CHAMPION And sObjectType='DF_Contact__c'].Id;
        DFc.First_Name__c = c.FirstName;
        DFc.Last_Name__c = c.LastName;
        DFc.Email__c = c.Email;
        DFc.Portal_Contact__c = c.Id;
        insert DFc;
        
        RecordType rt = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Event__c' and r.DeveloperName='Dementia_Friend_Awareness_Session'];
        
        DF_Event__c dfe = new DF_Event__c();
        List<DF_Event__c> dfEventList = new List<DF_Event__c>();
        
        DateTime endDateTime = system.now().addDays(1);
        DF_Event__c devent=new DF_Event__c(Event_Date_Time__c = system.now().addDays(1),Event_End_Date_Time__c=endDateTime.addHours(3),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=33,Number_of_Attendees__c=4,Name='samlpla Name',Location__c='Sample Location',Event_Status__c='Available',Event_Ext_Id__c=5495);
        insert devent;
        
            
        PageReference pageRef = Page.WEBGetSession;
        test.setCurrentPage(pageRef);
        
        System.runAs(loggedInUser) {    
                
        Test.startTest();
        WEBGetSession controller = new WEBGetSession();

        PageReference testPage = controller.loadSession();
        
        //test returned URL
        
        pageRef = Page.WEBGetSession;
        pageRef.getParameters().put('id',devent.Id);
        test.setCurrentPage(pageRef);
        
        controller = new WEBGetSession();
        PageReference testPage1 = controller.loadSession();
        
        //test returned URL
                
        Test.stoptest();
       }
    }
}