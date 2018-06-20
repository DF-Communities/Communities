@isTest
public class ExchangeDataFactory_Test {
    
public static testMethod void TestDataCreation()
{  
Community_Settings__c cs = new Community_Settings__c(name='Exchange_Site', Value__c='Champions Exchange');
insert cs;

Community_Settings__c cs2 = new Community_Settings__c(name='Exchange_Domain', Value__c='exchange');
insert cs2;

Community_Settings__c cs6=new Community_Settings__c();
        cs6.name='Exchange_Domain';
        cs6.value__c='exchange';
        insert cs6;
        Community_Settings__c cs7=new Community_Settings__c();
        cs7.name='Exchange_Feed_Moderator_Perm';
        cs7.value__c='Exchange_Feed_Moderator';
        insert cs7;
        Community_Settings__c cs8=new Community_Settings__c();
        cs8.name='Exchange_Permission_Set';
        cs8.value__c='Exchange_User';
        insert cs8;
        Community_Settings__c cs9=new Community_Settings__c();
        cs9.name='Exchange_Site';
        cs9.value__c='Champions Exchange';
        insert cs9;
        Community_Settings__c cs10=new Community_Settings__c();
        cs10.name='Exchange_Stub_Url';
        cs10.value__c='https://uat-alzheimerscommunities.cs81.force.com/exchange/';
        insert cs10;

        Community_Settings__c cs11=new Community_Settings__c();
        cs11.name='Exchange_Public_Group';
        cs11.value__c='Group chat';
        insert cs11;

 Map<String,Id> roles = new Map<String,Id>();
        List<UserRole> rl = [select id, name from UserRole];
        for(UserRole r : rl){ roles.put(r.name, r.id); }
 Map<String, RecordType> mapRecordTypes = new Map<String, RecordType>();
        List<RecordType> recordTypes = [Select Id, DeveloperName, SObjectType From RecordType];
        for (RecordType rt : recordTypes) { mapRecordTypes.put(rt.DeveloperName + '$' + rt.SObjectType, rt); }


User sysAdminUser =  [select id from user where UserRoleId =:roles.get('CEO') and isActive=true limit 1];

Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP'];        


Account a = new Account(Name='Test Account Name');
        a.OwnerId = sysAdminUser.id;
insert a;

 Contact c = new Contact();
        c.firstname = 'Test';
        c.LastName = 'TestContact';
        c.AccountId = a.Id;
        c.Email = 'test.testcontact@myemail.com';
        c.title='Mr';

insert c;
         


 User user = new User(Alias = 'standt',
                              Email='test.testcontact@myemail.com',
                              EmailEncodingKey='UTF-8',
                              LastName='Testing', 
                              LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', 
                              ProfileId = profileForUser.Id, 
                              TimeZoneSidKey='Europe/London',
                              ContactId =c.id, 
                              UserName = 'test.testcontact@myemail.com'
                               );        
        try {
            insert user;
            system.debug('Test User Inserted: ' + user.id);
            system.debug('Test User ContactId: ' + user.ContactId);
        } catch (Exception x) {
            system.debug(x.getMessage());
        } 

 DF_Contact__c DFchamp = new DF_Contact__c();
        DFchamp.RecordTypeId = mapRecordTypes.get('Dementia_Friend_Champion$DF_Contact__c').Id;
        DFchamp.First_Name__c ='test2';
        DFchamp.Last_Name__c = 'test2';
        DFchamp.Title__c = 'Mr';
        DFchamp.Status__c ='Converted';
        DFchamp.Champion_exchange_access__c = true;
        DFchamp.Name='test'+' ' +'test';
        DFchamp.Contact_Number__c = '02085180934';
        DFchamp.Email__c = 'test.testcontact@myemail.com';
        DFchamp.Postcode__c = 'TS1 3TN';
        DFchamp.Street__c = 'test street';
        DFchamp.City__c = 'test';
        DFchamp.County__c = 'test county';
        DFchamp.Country__c = 'test country';
        DFchamp.Newsletters__c = true;
        DFchamp.Portal_Contact__c = c.Id;
        
 insert DFchamp;



 
}
    
}