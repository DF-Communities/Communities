/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBChampionContactDetailsClass.
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
@isTest
private class WEBChampionContactDetailsTest {

    static testMethod void myUnitTest() {
            
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact();
            c.firstname = 'Test';
            c.LastName = 'TestContact';
            c.AccountId = a.Id;
            c.Email = 'test.testcontact@myemail.com';
            insert c;
            
        Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP']; 
        
        User user1 = new User(Alias = 'standt',Email='light@testorg.com',EmailEncodingKey='UTF-8',LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = profileForUser.Id, TimeZoneSidKey='America/Los_Angeles',UserName=Math.random() + '@test.com',ContactId =c.id );
        insert user1;   
        
        DF_Contact__c DFc = new DF_Contact__c();
        DFc.RecordTypeId = [Select Id From RecordType Where DeveloperName=:WEBConversionClass.RT_CONTACT_CHAMPION And sObjectType='DF_Contact__c'].Id;
        DFc.First_Name__c = c.FirstName;
        DFc.Last_Name__c = c.LastName;
        DFc.Email__c = c.Email;
        DFc.Portal_Contact__c = c.Id;
        insert DFc;
        
       DF_Event__c dfevents= new DF_Event__c();
       dfevents.Location__c = 'Test';
       dfevents.Event_Date_Time__c = system.today();
        dfevents.Street__c = 'Test';
        dfevents.City__c = 'Test';
        dfevents.County__c = 'Test';
        dfevents.Country__c = 'Test';
        dfevents.Postcode__c = 'Test';
        dfevents.Session_Organiser__c = DFc.Id;
        
        insert dfevents;
         System.runAs(user1) {  
        system.currentPageReference().getParameters().put('event', dfevents.Id);
        
        WEBChampionContactDetailsClass contactDetails = new WEBChampionContactDetailsClass();
        
        contactDetails.submitForm();
         }
    }
}