/***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            26-02-2015
     * @description     A set of utility methods that creates a full set of Test Data for testing 
                        DF application components. The method returns a Map of Maps
                        with a full set of records for each component of the application
***********************************************************************************************/
@isTest
public with sharing class DFP_DataFactory_Test {
    
  public static Map<String,Id> roles ;
    
    
     public static testMethod void TestDataCreation(){
        
        roles = new Map<String,Id>();
        List<UserRole> rl = [select id, name from UserRole];
        for(UserRole r : rl){ roles.put(r.name, r.id); }

      
        User sysAdminUser =  [select id from user where UserRoleId =:roles.get('CEO') and isActive=true limit 1];

       /*========== Lists to bulkify the inserts ===============
         Bulkify the inserts to reduce total SOQL queries
       */  

        List<Contact> lisContacts = new List<Contact>();
        List<DF_Contact__c> lisDFC = new List<DF_Contact__c>();
        List<Account> lisAccounts = new List<Account>();


        /*========== ACCOUNTS ===============*/


        Account a = new Account(Name='Test Account Name');
        a.OwnerId = sysAdminUser.id;
        lisAccounts.add(a);
        
        Account adminAcct = new Account(Name='Test Partner Name');
        a.OwnerId = sysAdminUser.id;
        lisAccounts.add(adminAcct);

        insert lisAccounts;
        

        
      
        

        /*========== CONTACTS ===============*/


        Contact c = new Contact();
        c.firstname = 'Test';
        c.LastName = 'TestContact';
        c.AccountId = a.Id;
        c.Email = 'test.testcontact@myemail.com';
        c.Salutation='Mr';
        insert c;

        Contact adminContact = new Contact();
        adminContact.firstname = 'Test';
        adminContact.LastName = 'TestContact';
        adminContact.AccountId = adminAcct.Id;
        adminContact.Email = 'test2.testcontact@myemail.com';
        adminContact.Salutation='Mr';
        insert adminContact;
        
        
        Contact c3 = new Contact();
        c3.firstname = 'Test';
        c3.LastName = 'TestContact';
        c3.AccountId = a.Id;
        c3.Email = 'test.testcontact3@myemail.com';
        c3.title='Mr';

       insert c3;
         
        

        Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP'];        

        /*========== USERS ===============*/

      User   user1  = new User(Alias = 'standt',
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
            insert user1;
            system.debug('Test User Inserted: ' + user1.id);
            system.debug('Test User ContactId: ' + user1.ContactId);
        } catch (Exception x) {
            system.debug(x.getMessage());
        }                         


        User   user3  = new User(Alias = 'standt',
                              Email='test.testcontact3@myemail.com',
                              EmailEncodingKey='UTF-8',
                              LastName='Testing', 
                              LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', 
                              ProfileId = profileForUser.Id, 
                              TimeZoneSidKey='Europe/London',
                              ContactId =c3.id, 
                              UserName = 'test.testcontact3@myemail.com'
                               );        
        try {
            insert user3;
            system.debug('Test User Inserted: ' + user3.id);
            system.debug('Test User ContactId: ' + user3.ContactId);
        } catch (Exception x) {
            system.debug(x.getMessage());
        }                         

        


        User adminUser = new User(Alias = 'admin',
                              Email='test2.testcontact@myemail.com',
                              EmailEncodingKey='UTF-8',
                              LastName='AdminTesting', 
                              LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', 
                              ProfileId = profileForUser.Id, 
                              TimeZoneSidKey='Europe/London',
                              ContactId = adminContact.id,
                              UserName = 'light.admin@df_organisation.com'  
                              );
        try {
        
            insert adminUser;
            system.debug('Admin Test User Inserted: ' + user1.id);
            system.debug('Admin Test User ContactId: ' + user1.ContactId);
            
                
        } catch (Exception x) {
        
            system.debug(x.getMessage());
        
        }


      
        /*========== CUSTOM SETTINGS ===============*/

        
        Community_Settings__c cs=new Community_Settings__c();
        cs.name='DF_Default_Account_Id';
        cs.value__c=a.id;
        insert cs;
        
        Community_Settings__c cs1=new Community_Settings__c();
        cs1.name='DF_Default_Profile_Id';
        cs1.value__c=profileForUser.id;
        insert cs1;
        
        Community_Settings__c cs2=new Community_Settings__c();
        cs2.name='DF_Default_Reply_To_Address';
        cs2.value__c='test@test.com';
        insert cs2;
        
        Community_Settings__c cs3=new Community_Settings__c();
        cs3.name='DF_Secret_Key';
        cs3.value__c='Nl8sPwQ9dAZMOVI+XQMNXQ==';
        insert cs3;
        
        Community_Settings__c cs4=new Community_Settings__c();
        cs4.name='DF_Site_Name';
        cs4.value__c='Dementia Friends';
        insert cs4;
        
        Community_Settings__c cs5=new Community_Settings__c();
        cs5.name='DF_Stub_Url';
        cs5.value__c='https://dfdev-dfdev.cs18.force.com/';
        insert cs5;

        Global_Setting__c GS1 = new Global_Setting__c();
        GS1.name='friendConvertCode';
        GS1.Value__c = 'DEMENTIAFRIEND123';
        insert GS1;

        Registration_Code__c rc1 = new Registration_Code__c();        
        rc1.name = 'Friend';
        rc1.Code_Value__c = 'DEMENTIAFRIEND123';
        insert rc1;


        /*========== DF CONTACT ===============*/

        DF_Contact__c DFc = new DF_Contact__c();
        DFc.RecordTypeId = DF_Utils.getsObjectRecordTypeId('DF_Contact__c','Dementia_Friend');//mapRecordTypes.get('Dementia_Friend$DF_Contact__c').Id;
        DFc.First_Name__c ='test';
        DFc.Last_Name__c = 'test';
        DFc.Title__c = 'Mr';
        DFc.Name='test'+' ' +'test';
        DFc.Contact_Number__c = '02085180934';
        DFc.Email__c = 'test.testcontact@myemail.com';
        DFc.Postcode__c = 'TS1 3TN';
        DFc.Street__c = 'test street';
        DFc.City__c = 'test';
        DFc.County__c = 'test county';
        DFc.Country__c = 'test country';
        DFc.Newsletters__c = true;
        DFc.Portal_Contact__c = c.Id;
        
        insert DFc;
        
        
        
       /*=======================================Lead========================*/
       
       Lead lead=new Lead(
                      Company='Test',
                      contact__c = c.id,
                      df_contact__c = DFc.id, 
                      LastName = c.LastName,  
                      FirstName= c.FirstName,           
                      Number_of_employees__c = '8',
                      Sector__c = 'Other',
                      Sector_other__c = 'Test',
                      RecordTypeId = DF_Utils.getsObjectRecordTypeId('Lead','Dementia_Friends_Website'),
                      LeadSource='Web',
                      status='Open' ,
                      partner_code__c = 'test55'
                      );
                      insert lead; 
      
        /*======================Partner data==================*/
        
        Partner_Organisation__c partner = new Partner_Organisation__c();
        partner.name='Test Partner Name';
        partner.Account__c = adminAcct.id;
        partner.Email_Domain__c = 'testorg.com';
        partner.Sector__c = 'test Sector';
        partner.DFC_Code__c = 'testpo123';
        insert partner;
        
        PO_Administrator__c po = new PO_Administrator__c();
        po.DF_Contact__c = DFc.Id ;
        po.Partner_Organisation__c = partner.Id;
        po.Status__c = 'Registered';
        insert po;
        
        PO_Administrator__c invite = new PO_Administrator__c();
        invite.Invited_Email__c = 'la2016@mailinator.com' ;
        invite.Invited_Name__c = 'Test';
        invite.Partner_Organisation__c = partner.Id;
        invite.Status__c = 'Invited';
        insert invite;
         
        Action__c act = new Action__c();
        act.Partner_Organisation__c = partner.id;
        act.Action__c = '*** TEST ***';
        act.Standard_Actions__c='Carry out own action';
        insert act;
        /*============End================*/

        
    
   }
}