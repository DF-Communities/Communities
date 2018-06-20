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
public with sharing class WEBChampionTest {
    
    static testMethod void championTest() {
        
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.LastName = 'TestContact';
        c.AccountId = a.Id;
        c.Email = 'unique.testcontact@myemail.com';
        insert c;
        
        Partner_Organisation__c po = new Partner_Organisation__c();
        po.Name = 'Test';
        po.DFC_Code__c = 'abc123';
        insert po;
        
        Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP']; 
        
        User user1 = new User(Alias = 'standt',Email='light@mailinator.com',EmailEncodingKey='UTF-8',LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = profileForUser.Id, TimeZoneSidKey='America/Los_Angeles',UserName=c.Email,ContactId =c.id );
        insert user1;   
        
        DF_Contact__c DFc = new DF_Contact__c();
        DFc.RecordTypeId = [Select Id From RecordType Where DeveloperName=:WEBConversionClass.RT_CONTACT_CHAMPION And sObjectType='DF_Contact__c'].Id;
        DFc.First_Name__c = c.FirstName;
        DFc.Last_Name__c = c.LastName;
        DFc.Email__c = c.Email;
        DFc.Portal_Contact__c = c.Id;
        DFc.Type_of_Champion__c = 'Super Champion';
        insert DFc;
        
        List<DF_Contact__c> cont = [SELECT Id FROM DF_Contact__c WHERE Email__c = 'tobeconfirmed@mailinator.com'];
        
        Id dfContactId;
        if(cont.size() > 0) {
            dfContactId = cont[0].Id;
        } else {
            DF_Contact__c defaultOrganiser = new DF_Contact__c();
            defaultOrganiser.RecordTypeId =  [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend_Champion' AND SObjectType = 'DF_Contact__c'].Id;
            defaultOrganiser.First_Name__c ='test3';
            defaultOrganiser.Last_Name__c = 'test3';
            defaultOrganiser.Title__c = 'Mr';
            defaultOrganiser.Name='test'+' ' +'test';
            defaultOrganiser.Contact_Number__c = '02011180935';
            defaultOrganiser.Email__c = 'tobeconfirmed@mailinator.com';
            defaultOrganiser.Postcode__c = 'TS1 3TN';
            defaultOrganiser.Street__c = 'test street';
            defaultOrganiser.City__c = 'test';
            defaultOrganiser.County__c = 'test county';
            defaultOrganiser.Country__c = 'test country';
            
            insert defaultOrganiser;
            dfContactId = defaultOrganiser.Id;
        }
        
        Community_Settings__c newCs=new Community_Settings__c();
        newCs.name='DF_Placeholder_InfoSessionOrganiser';
        newCs.value__c=dfContactId;
        insert newCs;
        
        System.runAs(user1) {    
            
            WEBChampion controller;
            
            Test.startTest();
            controller = new WEBChampion();
            
            controller.championCode = '';
            
            //system.assertEquals(null,controller.registerCode());
            
            controller.championCode = 'abc123';
            
            //system.assertEquals(null,controller.registerCode());
            
            system.assertNotEquals(null,controller.convertBackToFriend());
            
            Test.stoptest();
        }
    }
    
    static testMethod void championTest2() {
        
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u  = (User)mapTestData.get('User');
        DF_Contact__c dc = (DF_Contact__c)mapTestData.get('DFc');
        DF_Contact_Inbound_Change__c dcc = (DF_Contact_Inbound_Change__c)mapTestData.get('DFChange');
        
        System.runAs(u) {    
            
            WEBChampion controller;
            
            Test.startTest();
            controller = new WEBChampion();
            
            controller.championCode = '';
            system.assertEquals(true,controller.showChangeDetailsPrompt);
            system.assertEquals(true,controller.hasactions);
            // system.assertEquals(null,controller.registerCode());
            system.assertEquals(true,controller.contactDetailsChanged.size()>0);
            
            controller.championCode = 'abc123';
            
            // system.assertEquals(null,controller.registerCode());
            
            system.assertNotEquals(null,controller.convertBackToFriend());
            
            Test.stoptest();
        }
    }
}