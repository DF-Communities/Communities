/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBBadgeOrder.
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
public with sharing class WEBBadgeOrderTest {
    
    private static testMethod void test1(){
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.LastName = 'TestContact';
        c.AccountId = a.Id;
        c.Email = 'test.testcontact@myemail.com';
        c.RecordTypeId = [Select Id From RecordType Where DeveloperName=:WEBConversionClass.RT_CONTACT_FRIEND And sObjectType='Contact'].Id;
        insert c;
            
        Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP']; 
        
        User user1 = new User(Alias = 'standt',Email='light@testorg.com',EmailEncodingKey='UTF-8',LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = profileForUser.Id, TimeZoneSidKey='America/Los_Angeles',UserName=Math.random() + '@test.com',ContactId =c.id );
        insert user1;   
        
        List<DF_Contact__c> dfcList = new List<DF_Contact__c>();
        DF_Contact__c DFc;
        dfcList = [SELECT Id,Code_Verefied__c FROM DF_Contact__c WHERE Portal_Contact__c=:c.Id ];
        if (dfcList.size() > 0){
            DFc = dfcList[0];
        }else {
            DFc = new DF_Contact__c();
            DFc.RecordTypeId = [Select Id From RecordType Where DeveloperName=:WEBConversionClass.RT_CONTACT_FRIEND And sObjectType='DF_Contact__c'].Id;
            DFc.First_Name__c = 'Test';
            DFc.Last_Name__c = 'TestContact';
            DFc.Portal_Contact__c = c.Id;
            DFc.Email__c = 'test.testcontact@myemail.com';
            insert DFc;
        }
        
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
        
        Badge_Claim__c claim1 = new Badge_Claim__c(DF_Contact__c = DFc.Id);
        insert claim1;
        
        Page_Snippet__c snippet = new Page_Snippet__c(Unique_Name__c='DementiaFriendsTotalSnippet',Name__c='test',Body_Text__c='testtesttesttest');
        insert snippet;
        
        system.runAs(user1) {   
            system.currentPageReference().getParameters().put('event', dfevents.Id);
            WEBBadgeOrder badgeOrder = new WEBBadgeOrder();
            Page_Snippet__c ps3 = badgeOrder.totalFriendsSnippet;
            badgeOrder.actionCards =true;
            badgeOrder.addressStreet = '';
            badgeOrder.addressCity = '';
            badgeOrder.addressCounty = '';
            badgeOrder.addressPostcode = '';
            badgeOrder.bingoSheets = '50' ;
            
           badgeOrder.submitBadgeClaim();
        }
    }

}