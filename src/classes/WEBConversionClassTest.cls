/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBConversionClass.
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
public with sharing class WEBConversionClassTest {
    
    private static testMethod void testWEBConversionClass1(){
         Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
        Registration_Code__c setting = Registration_Code__c.getInstance('Champion');
        if (setting == null){
            setting = new Registration_Code__c(Name='Champion',Code_Value__c='ABC123');
            insert setting;
        }
        
        Registration_Code__c setting1 = Registration_Code__c.getInstance('Friend');
        if (setting1 == null){
            setting1 = new Registration_Code__c(Name='Friend',Code_Value__c='DEMENTIAFRIEND123');
            insert setting1;
        }
        
        Partner_Organisation__c po = new Partner_Organisation__c();
        po.Name = 'Alzheimers Society';
        po.DFC_Code__c = 'ABC123';
        insert po;
        
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.LastName = 'TestContact';
        c.AccountId = a.Id;
        c.Email = 'test123.testcontact@myemail.com';
        c.RecordTypeId = [Select Id From RecordType Where DeveloperName=:WEBConversionClass.RT_CONTACT_FRIEND And sObjectType='Contact'].Id;
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
        Test.startTest();
        system.runAs(user1) {   
            system.currentPageReference().getParameters().put('event', dfevents.Id);
            WEBConversionClass conversionClass = new WEBConversionClass();
            WEBConversionClass.friendConvertCode = 'DEMENTIAFRIEND123';
            WEBConversionClass.championConvertCode = 'ABC123';
            WEBConversionClass.contactToBeConverted = c;
            WEBConversionClass.dfContactToBeConverted = DFc;
            
            String s = WEBConversionClass.whatIsAChampionPage;
            Boolean b1 = WEBConversionClass.isFriend(c.Id);
            Boolean b2 = WEBConversionClass.isChampion(c.Id);
            Boolean b3 = WEBConversionClass.convertToFriend(c.Id, WEBConversionClass.friendConvertCode);
            Boolean b4 = WEBConversionClass.convertFriendToChampion(c.Id, WEBConversionClass.championConvertCode);
           // DFc.Code_Verefied__c = true;
           // DFc.Session_Code_Verified__c = true;
          //  update DFc;
          //  DFc = [SELECT Id,Code_Verefied__c, Session_Code_Verified__c FROM DF_Contact__c WHERE Portal_Contact__c=:c.Id ];
            
            Boolean b5 = WEBConversionClass.convertChampionToFriend(c.Id, WEBConversionClass.friendConvertCode);
            Boolean b6 = WEBConversionClass.convertFriendToChampion(c.Id, WEBConversionClass.championConvertCode);
        }
    }
    
    private static testMethod void testWEBConversionClass2(){
         Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
        Partner_Organisation__c po = new Partner_Organisation__c();
        po.Name = 'Alzheimers Society';
        po.DFC_Code__c = 'ABC123';
        insert po;
        
        Registration_Code__c setting = Registration_Code__c.getInstance('Champion');
        if (setting == null){
            setting = new Registration_Code__c(Name='Champion',Code_Value__c='ABC123');
            insert setting;
        }
        
        Registration_Code__c setting1 = Registration_Code__c.getInstance('Friend');
        if (setting1 == null){
            setting1 = new Registration_Code__c(Name='Friend',Code_Value__c='DEMENTIAFRIEND123');
            insert setting1;
        }
        
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.LastName = 'TestContact';
        c.AccountId = a.Id;
        c.Email = 'test.testcontact123@myemail.com';
        c.RecordTypeId = [Select Id From RecordType Where DeveloperName=:WEBConversionClass.RT_CONTACT_CHAMPION And sObjectType='Contact'].Id;
        insert c;
            
        Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP']; 
        
        User user1 = new User(Alias = 'standt',Email='light@testorg.com',EmailEncodingKey='UTF-8',LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = profileForUser.Id, TimeZoneSidKey='America/Los_Angeles',UserName=Math.random() + '@testtt.com',ContactId =c.id );
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

        Test.startTest();
        
        system.runAs(user1) {   
            system.currentPageReference().getParameters().put('event', dfevents.Id);
            WEBConversionClass conversionClass = new WEBConversionClass();
            WEBConversionClass.friendConvertCode = 'DEMENTIAFRIEND123';
            WEBConversionClass.championConvertCode = 'ABC123';
            WEBConversionClass.contactToBeConverted = c;
            WEBConversionClass.dfContactToBeConverted = DFc;
            
            
            
            Boolean b1 = WEBConversionClass.isFriend(c.Id);            
            Boolean b2 = WEBConversionClass.isChampion(c.Id);
            Boolean b3 = WEBConversionClass.convertToFriend(c.Id, WEBConversionClass.friendConvertCode);
            Boolean b4 = WEBConversionClass.registerAsChampion(user1.ContactId);
            Boolean b5 = WEBConversionClass.convertFriendToChampion(c.Id, WEBConversionClass.championConvertCode);
          //  DFc.Code_Verefied__c = true;
           // DFc.Session_Code_Verified__c = true;
         //   update DFc;
          //  DFc = [SELECT Id,Code_Verefied__c, Session_Code_Verified__c FROM DF_Contact__c WHERE Portal_Contact__c=:c.Id ];
            
            Boolean b6 = WEBConversionClass.convertChampionToFriend(c.Id, WEBConversionClass.friendConvertCode);
            Boolean b7 = WEBConversionClass.convertToChampion(c.Id);
            Boolean b8 = WEBConversionClass.isFriendConverted(c.Id);
            Boolean b9 = WEBConversionClass.isChampionConverted(c.Id);
            
        }
    }

}