@isTest
public class DF_User_TriggerHandler_Test {

@testSetup
static void setupData() {  ExchangeDataFactory_Test.TestDataCreation(); }

private static Profile testProfile {

    get {

        if ( testProfile == null) {
             testProfile = [SELECT Id FROM Profile WHERE Name='DF HVCP'];
        }

        return testProfile;
    }

    set;
}


static testMethod void coverMethod() {
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
    c.Email = 'test.testcontact2@myemail.com';
    c.Salutation='Mr';
    insert c;

    Map<String, RecordType> mapRecordTypes = new Map<String, RecordType>();    
    List<RecordType> recordTypes = [Select Id, DeveloperName, SObjectType From RecordType];
    for (RecordType rt : recordTypes) { mapRecordTypes.put(rt.DeveloperName + '$' + rt.SObjectType, rt); }

    DF_Contact__c DFc = new DF_Contact__c();
    DFc.RecordTypeId = mapRecordTypes.get('Dementia_Friend$DF_Contact__c').Id;
    DFc.First_Name__c ='test';
    DFc.Last_Name__c = 'test';
    DFc.Title__c = 'Mr';
    DFc.Name='test'+' ' +'test';
    DFc.Contact_Number__c = '02085180934';
    DFc.Email__c = 'test.testcontact2@myemail.com';
    DFc.Postcode__c = 'TS1 3TN';
    DFc.Street__c = 'test street';
    DFc.City__c = 'test';
    DFc.County__c = 'test county';
    DFc.Country__c = 'test country';
    DFc.Newsletters__c = true;
    DFc.Portal_Contact__c = c.Id;
    insert dfc;

    User user = new User(Alias = 'standt',
                  Email='test.testcontact2@myemail.com',
                  EmailEncodingKey='UTF-8',
                  LastName='Testing', 
                  LanguageLocaleKey='en_US', 
                  LocaleSidKey='en_US', 
                  ProfileId = testProfile.Id, 
                  TimeZoneSidKey='Europe/London',
                  ContactId =c.id, 
                  UserName = 'test.testcontact2@myemail.com'
  
                   );  
    try {      
      insert user;
       
    } catch (Exception x) {
            system.debug(x.getMessage());
    }  
    

 }

static testMethod void coverMethod2() {
   User u = [SELECT Id FROM User WHERE Email = 'test.testcontact@myemail.com'];
   Set<Id> updatedUserIds = new Set<Id> ();
   updatedUserIds.add(u.Id);
   if(updatedUserIds.size()>0){
      Test.startTest();
      DF_User_TriggerHandler.disableChampionExchangeAccess(updatedUserIds);
      DF_User_TriggerHandler.enableExchangeModeratorAccess(updatedUserIds);
      DF_User_TriggerHandler.disableExchangeModeratorAccess(updatedUserIds);
      Test.stopTest();
    }

}

}