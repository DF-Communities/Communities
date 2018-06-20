/***********************************************************************************************
* @author          Lakshmi Rajendram 
* @date            26-02-2015
* @description     A set of utility methods that creates a full set of Test Data for testing 
DF application components. The method returns a Map of Maps
with a full set of records for each component of the application
***********************************************************************************************/
@isTest
public class DF_DataFactory_Test {
    
    
    private static User testSysAdminUser {
        
        get {
            
            if ( testSysAdminUser == null ) {
                testSysAdminUser = [select id from user where UserRole.Name ='CEO' and isActive=true limit 1];
            }
            
            return testSysAdminUser;
            
        }
        set;
    }
    
    private static Profile testProfile {
        
        get {
            
            if ( testProfile == null) {
                testProfile = [SELECT Id FROM Profile WHERE Name='DF HVCP'];
            }
            
            return testProfile;
        }
        
        set;
    }
    
    public static Id DefaultRequestSessionOrganiser {
        
        get {
            List<DF_Contact__c> cont = [SELECT Id FROM DF_Contact__c WHERE Email__c = 'tobeconfirmed@mailinator.com'];
            
            Id dfContactId;
            if(cont.size() > 0) {
                dfContactId = cont[0].Id;
                return dfContactId;
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
            
            return dfContactId;
        
        }
        
        set;
    }
    
    public static testMethod void TestDataCreation()
    {
        
        Map<String, Object> mapTestData = getTestData();
        
    }
    
    public static String getCustomSettingTestValue(String name){
        
        if ( name == 'Default_Account_Id') { 
            Account a = new Account(Name='Test Account Name');
            a.OwnerId = testSysAdminUser.id;
            insert a;
            return a.id;
        }
        
        if ( name == 'Default_Account_Owner_Id') { 
            return testSysAdminUser.id;
        }
        
        if ( name == 'Default_Profile_Id' ) {             
            return testProfile.id;
        }
        
        if ( name == 'Default_Reply_To_Address' ) {
            return 'test@test.com';
        }
        
        
        if ( name == 'Secret_Key' ) {
            return 'Nl8sPwQ9dAZMOVI+XQMNXQ==';
        }
        
        if ( name == 'Site_Name' ) {
            return 'Dementia Friends';
        }
        
        if ( name == 'Stub_Url' ) {
            return 'https://dfdev-dfdev.cs18.force.com/';
        }
        
        if ( name == 'Sys_Admin_Id' ) {
            return testSysAdminUser.id;
        }   
        
        if ( name == 'Exchange_Domain' ) {
            return 'exchange';
        }  
        if ( name == 'Exchange_Feed_Moderator_Perm' ) {
            return 'Exchange_Feed_Moderator';
        }   
        if ( name == 'Exchange_Permission_Set' ) {
            return 'Exchange_User';
        }      
        
        if ( name == 'Exchange_Site' ) {
            return 'Champions Exchange';
        }      
        
        if ( name == 'Exchange_Stub_Url' ) {
            return 'https://uat-alzheimerscommunities.cs81.force.com/exchange/';
        }      
        
        if ( name == 'Exchange_Public_Group' ) {
            return 'General';
        }      
        
        
        return 'RandomString';
        
    }    
    
    public static Map<String, RecordType> mapRecordTypes;
    
    public static map<String,Object> getTestData(){
        
        Map<String,Id> roles = new Map<String,Id>();
        List<UserRole> rl = [select id, name from UserRole];
        for(UserRole r : rl){ roles.put(r.name, r.id); }
        
        mapRecordTypes = new Map<String, RecordType>();
        List<RecordType> recordTypes = [Select Id, DeveloperName, SObjectType From RecordType];
        for (RecordType rt : recordTypes) { mapRecordTypes.put(rt.DeveloperName + '$' + rt.SObjectType, rt); }
        
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
        lisContacts.add(c);
        
        Contact adminContact = new Contact();
        adminContact.firstname = 'Test';
        adminContact.LastName = 'TestContact';
        adminContact.AccountId = adminAcct.Id;
        adminContact.Email = 'test2.testcontact@myemail.com';
        adminContact.Salutation='Mr';
        lisContacts.add(adminContact);       
        
        Contact c2 = new Contact();
        c2.firstname = 'NotVerified';
        c2.LastName = 'NotVerified';
        c2.AccountId = a.Id;
        c2.Email = 'NotVerified@test.com';
        c2.Salutation='Mr';
        c2.Password_Reset_Key__c = 'RandomString';
        lisContacts.add(c2);
        
        Contact c3 = new Contact();
        c3.firstname = 'Test';
        c3.LastName = 'TestContact';
        c3.AccountId = a.Id;
        c3.Email = 'test.testcontact2@myemail.com';
        c3.title='Mr';
        
        lisContacts.add(c3);
        
        Contact c4 = new Contact();
        c4.firstname = 'Test';
        c4.LastName = 'TestContact';
        c4.AccountId = a.Id;
        c4.Email = 'test.testcontact@myemail.com';
        c4.Salutation='Mr';
        
        lisContacts.add(c4);
        
        Contact adminContact2 = new Contact();
        adminContact2.firstname = 'Test';
        adminContact2.LastName = 'TestContact';
        adminContact2.AccountId = adminAcct.Id;
        adminContact2.Email = 'test2.test2@myemail.com';
        adminContact2.Salutation='Mr';
        adminContact.Password_Reset_Key__c = 'RandomString';
        lisContacts.add(adminContact2); 
        
        
        insert lisContacts;
        
        Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP'];        
        
        /*========== USERS ===============*/
        
        User user1 = new User(Alias = 'standt',
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
        
        User user2 = new User(Alias = 'standt',
                              Email='test.testcontact2@myemail.com',
                              EmailEncodingKey='UTF-8',
                              LastName='Testing', 
                              LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', 
                              ProfileId = profileForUser.Id, 
                              TimeZoneSidKey='Europe/London',
                              ContactId =c3.id, 
                              UserName = 'test.testcontact2@myemail.com'
                             );        
        try {
            insert user2;
            system.debug('Test User Inserted: ' + user2.id);
            system.debug('Test User ContactId: ' + user2.ContactId);
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
        
        
        /*========== REGIONS ===============*/
        
        
        List<DF_Region__c> lisRegions = new List<DF_Region__c>();
        DF_Region__c dfr = new DF_Region__c ( Name = 'South West',
                                             RSO__c = adminUser.id );                                              
        //lisRegions.add(dfr);
        insert dfr;
        
        DF_Region__c dfr2 = new DF_Region__c ( Name = 'South East');                                              
        lisRegions.add(dfr2);
        //insert (lisRegions);
        insert dfr2;
        
        DF_Region_Postcode__c rp = new DF_Region_Postcode__c();
        rp.DF_Region__c=dfr.id;
        rp.Name = 'TS1';
        insert rp;
        
        
        
        
        /*========== DF CONTACT ===============*/
        
        DF_Contact__c DFc = new DF_Contact__c();
        DFc.RecordTypeId = mapRecordTypes.get('Dementia_Friend$DF_Contact__c').Id;
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
        
        lisDFC.add(DFc);
        
        DF_Contact__c DFc2 = new DF_Contact__c();
        DFc2.RecordTypeId = mapRecordTypes.get('Dementia_Friend$DF_Contact__c').Id;
        DFc2.First_Name__c ='NotVerified';
        DFc2.Last_Name__c = 'NotVerified';
        DFc2.Title__c = 'Mr';
        DFc2.Name='NotVerified'+' ' +'NotVerified';
        DFc2.Contact_Number__c = '02085180934';
        DFc2.Email__c = 'NotVerified@test.com';
        DFc2.Postcode__c = 'TS1 3TN';
        DFc2.Street__c = 'test street';
        DFc2.City__c = 'test';
        DFc2.County__c = 'test county';
        DFc2.Country__c = 'test country';
        DFc2.Newsletters__c = true;
        DFc2.Portal_Contact__c = c2.Id;
        
        lisDFC.add(DFc2);
        
        DF_Contact__c DFchamp = new DF_Contact__c();
        DFchamp.RecordTypeId = mapRecordTypes.get('Dementia_Friend_Champion$DF_Contact__c').Id;
        DFchamp.First_Name__c ='test2';
        DFchamp.Last_Name__c = 'test2';
        DFchamp.Title__c = 'Mr';
        DFchamp.Name='test'+' ' +'test';
        DFchamp.Contact_Number__c = '02085180934';
        DFchamp.Email__c = 'test.testcontact2@myemail.com';
        DFchamp.Postcode__c = 'EC3N 2AE'; // Address is important for proximity seach in requested info sessions
        DFchamp.Street__c = '43-44 Crutched Friars';
        DFchamp.City__c = 'London';
        DFchamp.County__c = 'London';
        DFchamp.Country__c = 'United Kingdom';
        DFchamp.Newsletters__c = true;
        DFchamp.Location__Latitude__s = 51.37360;
        DFchamp.Location__Longitude__s = -0.08595;
        DFchamp.DF_Region__c = dfr.id;
        DFchamp.Total_No_of_Completed_Info_Sessions__c = 4 ;
        DFchamp.Total_No_of_Available_Info_Sessions__c = 4 ;
        DFchamp.Total_No_of_Cancelled_Info_Sessions__c = 4 ;
        DFchamp.Total_No_of_Friends_Created__c = 4 ;
        DFchamp.Number_of_Public_Sessions_Run__c = 4 ;
        DFchamp.Number_of_Private_Sessions_Run__c = 4 ;
        DFchamp.Portal_Contact__c = adminContact.id;
        DFchamp.Portal_User__c = adminUser.Id;
        lisDFC.add(DFchamp);
        
        DF_Contact__c DFchamp2 = new DF_Contact__c();
        DFchamp2.RecordTypeId = mapRecordTypes.get('Dementia_Friend_Champion$DF_Contact__c').Id;
        DFchamp2.First_Name__c ='test3';
        DFchamp2.Last_Name__c = 'test3';
        DFchamp2.Title__c = 'Mr';
        DFchamp2.Name='test'+' ' +'test';
        DFchamp2.Contact_Number__c = '02085180935';
        DFchamp2.Email__c = 'test.testcontact3@myemail.com';
        DFchamp2.Postcode__c = 'TS1 3TN';
        DFchamp2.Street__c = 'test street';
        DFchamp2.City__c = 'test';
        DFchamp2.County__c = 'test county';
        DFchamp2.Country__c = 'test country';
        DFchamp2.Location__Latitude__s = 51.37360;
        DFchamp2.Location__Longitude__s = -0.08595;
        DFchamp2.Newsletters__c = true;
        DFchamp2.Portal_Contact__c = c4.Id;
        DFchamp2.Total_No_of_Friends_Created__c=25;
        DFchamp2.DF_Region__c = dfr.id;
        
        lisDFC.add(DFchamp2);
        
        DF_Contact__c defaultOrganiser = new DF_Contact__c();
        defaultOrganiser.RecordTypeId = mapRecordTypes.get('Dementia_Friend_Champion$DF_Contact__c').Id;
        defaultOrganiser.First_Name__c ='test3';
        defaultOrganiser.Last_Name__c = 'CONFIRMED';
        defaultOrganiser.Title__c = 'Mr';
        defaultOrganiser.Name='test'+' ' +'test';
        defaultOrganiser.Contact_Number__c = '02011180935';
        defaultOrganiser.Email__c = 'tobeconfirmed@mailinator.com';
        defaultOrganiser.Postcode__c = 'TS1 3TN';
        defaultOrganiser.Street__c = 'test street';
        defaultOrganiser.City__c = 'test';
        defaultOrganiser.County__c = 'test county';
        defaultOrganiser.Country__c = 'test country';
        defaultOrganiser.Location__Latitude__s = 51.37360;
        defaultOrganiser.Location__Longitude__s = -0.08595;
        
        lisDFC.add(defaultOrganiser);
        
        insert lisDFC;
        
        
        Partner_Organisation__c partner = new Partner_Organisation__c();
        partner.name='Test Partner Name';
        partner.Account__c = adminAcct.id;
        partner.Email_Domain__c = 'testorg.com';
        partner.Sector__c = 'test Sector';
        partner.DFC_Code__c = 'testpo123';
        insert partner;
        
        PO_Administrator__c po = new PO_Administrator__c();
        po.DF_Contact__c = DFchamp.Id ;
        po.Partner_Organisation__c = partner.Id;
        po.Status__c = 'Registered';
       // insert po;
        
        PO_Administrator__c invite = new PO_Administrator__c();
        invite.Invited_Email__c = 'la2016@mailinator.com' ;
        invite.Invited_Name__c = 'Test';
        invite.Partner_Organisation__c = partner.Id;
        invite.Status__c = 'Invited';
        insert new List<PO_Administrator__c>{po, invite };
        
        
        /*========== CUSTOM SETTINGS ===============*/
        
        List<Community_Settings__c> testCs = new List<Community_Settings__c>();
        
        Community_Settings__c cs=new Community_Settings__c();
        cs.name='DF_Default_Account_Id';
        cs.value__c=a.id;
        testCs.add(cs);
        
        Community_Settings__c cs1=new Community_Settings__c();
        cs1.name='DF_Default_Profile_Id';
        cs1.value__c=profileForUser.id;
        testCs.add(cs1);
        
        Community_Settings__c cs2=new Community_Settings__c();
        cs2.name='DF_Default_Reply_To_Address';
        cs2.value__c='test@test.com';
        testCs.add(cs2);
        
        Community_Settings__c cs3=new Community_Settings__c();
        cs3.name='DF_Secret_Key';
        cs3.value__c='Nl8sPwQ9dAZMOVI+XQMNXQ==';
        testCs.add(cs3);
        
        Community_Settings__c cs4=new Community_Settings__c();
        cs4.name='DF_Site_Name';
        cs4.value__c='Dementia Friends';
        testCs.add(cs4);
        
        Community_Settings__c cs5=new Community_Settings__c();
        cs5.name='DF_Stub_Url';
        cs5.value__c='https://dfdev-dfdev.cs18.force.com/';
        testCs.add(cs5);
        
        Community_Settings__c cs6=new Community_Settings__c();
        cs6.name='Exchange_Domain';
        cs6.value__c='exchange';
        testCs.add(cs6);
        
        Community_Settings__c cs7=new Community_Settings__c();
        cs7.name='Exchange_Feed_Moderator_Perm';
        cs7.value__c='Exchange_Feed_Moderator';
        testCs.add(cs7);
        
        Community_Settings__c cs8=new Community_Settings__c();
        cs8.name='Exchange_Permission_Set';
        cs8.value__c='Exchange_User';
        testCs.add(cs8);
        
        Community_Settings__c cs9=new Community_Settings__c();
        cs9.name='Exchange_Site';
        cs9.value__c='Champions Exchange';
        testCs.add(cs9);
        
        Community_Settings__c cs10=new Community_Settings__c();
        cs10.name='Exchange_Stub_Url';
        cs10.value__c='https://uat-alzheimerscommunities.cs81.force.com/exchange/';
        testCs.add(cs10);
        
        Community_Settings__c cs11=new Community_Settings__c();
        cs11.name='Exchange_Public_Group';
        cs11.value__c='General';
        testCs.add(cs11);
        
        Community_Settings__c cs12=new Community_Settings__c();
        cs12.name='DF_Placeholder_InfoSessionOrganiser';
        cs12.value__c= [SELECT Id FROM DF_Contact__c WHERE Email__c = 'tobeconfirmed@mailinator.com'].Id;
        testCs.add(cs12);
        
        insert testCs;
        
        List<Global_Setting__c> testGs = new List<Global_Setting__c>();
        Global_Setting__c GS1 = new Global_Setting__c();
        GS1.name='friendConvertCode';
        GS1.Value__c = 'DEMENTIAFRIEND123';
        testGs.add(GS1);
        
        Global_Setting__c GS2 = new Global_Setting__c();
        GS2.name='DF_VisualforceOriginHostDomain';
        GS2.Value__c = 'uat--uat.lightning.force.com';
        testGs.add(GS2);
        
        Global_Setting__c GS3 = new Global_Setting__c();
        GS3.name='DF_LightningOriginHostDomain';
        GS3.Value__c = 'uat--uat--c.cs18.visual.force.com';
        testGs.add(GS3);
        
        Global_Setting__c GS4 = new Global_Setting__c();
        GS4.name='GoogleMapsApiKey';
        GS4.Value__c = 'AIzaSyC6dHKnrwyIbJcqW4CS9VPlYF4LBNJywg0';
        testGs.add(GS4);
        
        insert testGs;
        
        Registration_Code__c rc1 = new Registration_Code__c();        
        rc1.name = 'Friend';
        rc1.Code_Value__c = 'DEMENTIAFRIEND123';
        insert rc1;
        
        /*========== EVENTS ===============*/
        
        Id defaultOrganiserId = [SELECT Id FROM DF_Contact__c WHERE Email__c = 'tobeconfirmed@mailinator.com'].Id;
        List<DF_Event__c> testEvnts = new List<DF_Event__c>();
        
        DF_Event__c dfE4 = new DF_Event__c();
        dfE4.RecordTypeId = mapRecordTypes.get('Dementia_Friend_Awareness_Session$DF_Event__c').Id;
        dfE4.name = 'Test Friends Session 2';
        dfE4.Postcode__c = 'IG1 3HY';
        dfE4.City__c = 'Ilford';
        dfE4.Event_Date_Time__c = system.today()-3 ;
        dfE4.Event_End_Date_Time__c = system.today()-3 ;
        dfE4.Session_Organiser__c = DFChamp2.id ;
        testEvnts.add(dfE4);
        
        DF_Event__c dfE2 = new DF_Event__c();
        dfE2.RecordTypeId = mapRecordTypes.get('Dementia_Friend_Awareness_Session$DF_Event__c').Id;
        dfE2.name = 'Test Friends Session';
        dfE2.Postcode__c = 'IG1 3HY';
        dfE2.City__c = 'Ilford';
        dfE2.Event_Date_Time__c = system.today()-2 ;
        dfE2.Event_End_Date_Time__c = system.now() ;
        dfE2.Session_Organiser__c = DFChamp.id ;
        testEvnts.add(dfE2);
        
        DF_Event__c dfE = new DF_Event__c();
        dfE.RecordTypeId = mapRecordTypes.get('Champion_Training_Course$DF_Event__c').Id;
        dfE.name = 'Test Champion Training';
        dfE.Postcode__c = 'IG1 3HY';
        dfE.City__c = 'Ilford';
        dfE.Event_Date_Time__c = system.today() ;
        dfE.Event_End_Date_Time__c = system.today() ;
        dfE.Session_Organiser__c = DFChamp.id ;
        testEvnts.add(dfE);
        
        DF_Event__c dfE3 = new DF_Event__c();
        dfE3.RecordTypeId = mapRecordTypes.get('Champion_Training_Course$DF_Event__c').Id;
        dfE3.name = 'Test Champion Training';
        dfE3.Postcode__c = 'IG1 3HY';
        dfE3.City__c = 'Ilford';
        dfE3.Event_Date_Time__c = system.today() ;
        dfE3.Event_End_Date_Time__c = system.today() ;
        dfE3.Session_Organiser__c = DFChamp.id ;
        testEvnts.add(dfE3);
        
        insert testEvnts;
        
        List<DF_EventAttendee__c> testAttendees = new List<DF_EventAttendee__c>();
        DF_EventAttendee__c eAt2 = new DF_EventAttendee__c ();
        eAt2.DF_Contact__c = DFc2.id;
        eAt2.DF_Event__c = dfE2.id;
        testAttendees.add(eAt2);
        
        DF_EventAttendee__c eAt = new DF_EventAttendee__c ();
        eAt.DF_Contact__c = DFchamp.id;
        eAt.DF_Event__c = dfE.id;
        testAttendees.add(eAt);
        
        insert(testAttendees);
        
        DF_Pack_Request__c pack = new DF_Pack_Request__c();
        pack.DF_Contact__c = DFc.id;
        pack.City__c = DFc.City__c;
        pack.Street__c = DFc.Street__c;
        pack.PostCode__c = DFc.PostCode__c;
        pack.County__c = DFc.County__c;
        pack.Country__c = DFc.Country__c;
        insert pack;
        
        Action__c act = new Action__c();
        act.DF_Contact__c = dfc.id;
        act.Action__c = '*** TEST ***';
        act.Standard_Actions__c='Carry out own action';
        insert act;
        
        List<DF_Event__c> testReqEvts = new List<DF_Event__c>();
        DF_Event__c dfERequested1 = new DF_Event__c();
        Date dToday = system.today();
        dfERequested1.RecordTypeId = mapRecordTypes.get('Dementia_Friend_Awareness_Session$DF_Event__c').Id;
        dfERequested1.name = 'Test Request Session';
        dfERequested1.Postcode__c = 'EC3N 2AE';
        dfERequested1.City__c = 'London';
        dfERequested1.Street__c = '44 Crutched Friars';
        dfERequested1.Requested_Info_Session__c = true;
        dfERequested1.Event_Date_Time__c = dToday.addDays(21);
        dfERequested1.Event_End_Date_Time__c = dToday.addDays(21);
        dfERequested1.Preference_1_Date__c = dToday.addDays(21); 
        dfERequested1.Preference_1_Period__c = 'Afternoon (12pm-5pm)'; 
        dfERequested1.Preference_2_Date__c = dToday.addDays(29); 
        dfERequested1.Preference_2_Period__c = 'Any time'; 
        dfERequested1.Preference_3_Date__c = dToday.addDays(25); 
        dfERequested1.Preference_3_Period__c = 'Specific time (hh:mm)'; 
        dfERequested1.Preference_3_Time__c = '09:45'; 
        dfERequested1.Session_Requester__c = DFChamp.id ;
        dfERequested1.Session_Organiser__c = defaultOrganiserId;
        dfERequested1.Request_Status__c = 'Open - waiting for champion';
        testReqEvts.add(dfERequested1);
        
        DF_Event__c dfERequested2 = new DF_Event__c();
        dfERequested2.RecordTypeId = mapRecordTypes.get('Dementia_Friend_Awareness_Session$DF_Event__c').Id;
        dfERequested2.name = 'Test Request Session';
        dfERequested2.Postcode__c = 'EC3N 2AE';
        dfERequested2.City__c = 'London';
        dfERequested2.Street__c = '44 Crutched Friars';
        dfERequested2.Requested_Info_Session__c = true;
        dfERequested2.Event_Date_Time__c = dToday.addDays(2);
        dfERequested2.Event_End_Date_Time__c = dToday.addDays(2);
        dfERequested2.Preference_1_Date__c = dToday.addDays(2); 
        dfERequested2.Preference_1_Period__c = 'Afternoon (12pm-5pm)'; 
        dfERequested2.Preference_2_Date__c = dToday.addDays(7); 
        dfERequested2.Preference_2_Period__c = 'Morning (7am-12pm)'; 
        dfERequested2.Preference_3_Date__c = dToday.addDays(20); 
        dfERequested2.Preference_3_Period__c = 'Specific time (hh:mm)'; 
        dfERequested2.Preference_3_Time__c = '16:30'; 
        dfERequested2.Session_Requester__c = DFChamp.id ;
        dfERequested2.Session_Organiser__c = defaultOrganiserId;
        testReqEvts.add(dfERequested2);
        insert testReqEvts;
        
        
        /*============DF Contact Inbound Change===============*/
        
        DF_Contact_Inbound_Change__c dcc = new DF_Contact_Inbound_Change__c();
        dcc.Related_DF_Contact__c =  Dfc.Id;
        dcc.First_Name__c = 'TFname';
        dcc.Last_Name__c = 'TLname';    
        
        insert dcc ;
        /*========== END ===============*/
        
        /*============Demographic Information===============*/
        
        List<Demographic_Information__c> testDgs = new List<Demographic_Information__c>();
        
        Demographic_Information__c dg = new Demographic_Information__c(
            
            Contact__c = c.Id, 
            Ethnic_Group__c = 'White - Irish', 
            Ethnic_Group_Other__c = 'Test',
            Proximity_to_dementia__c     = 'Employed'
        );
        testDgs.add(dg);
        
        Id contactId = DFChamp.Portal_Contact__c;
        Demographic_information__c	di = new Demographic_information__c();
        di.Contact__c = contactId;
        di.Email_Opt_in__c = true;
        di.Ethnic_Group__c = 'Asian/Asian British – Indian';
        di.Post_Opt_out__c = true;
        di.Proximity_to_dementia__c = 'Family or Friend,Carer';
        testDgs.add(di);
        
        insert(testDgs);
        
        /*========== END ===============*/
        
        /*========== Put all the data into a Map ===============*/
        
        Map<String,Community_Settings__c> mapCs = new Map<String,Community_Settings__c>();
        mapCs.put('cs1',cs1);
        mapCs.put('cs2',cs2);
        mapCs.put('cs',cs);
        mapCs.put('cs3',cs3);
        mapCs.put('cs4',cs4); 
        mapCs.put('cs5',cs5); 
        
        Map<String, Object> mapMisc = new Map<String,Object>();    
        mapMisc.put('User',user1);
        mapMisc.put('User2',user2);
        mapMisc.put('Account',a);
        
        mapMisc.put('DFc',DFc);
        mapMisc.put('DFc2',DFc2);
        
        mapMisc.put('cs', mapCs);        
        mapMisc.put('contact',c);
        mapMisc.put('contact2',c2);
        
        mapMisc.put('partnerOrg',partner);
        mapMisc.put('adminContact',adminContact);
        mapMisc.put('adminContact2',adminContact2);
        mapMisc.put('adminUser',adminUser);
        mapMisc.put('Region',dfr);
        mapMisc.put('Region2',dfr2);
        mapMisc.put('Champion',DFchamp);
        mapMisc.put('Champion2',DFchamp2);
        mapMisc.put('ChampCourse', dfE);
        mapMisc.put('ChampCourse2', dfE3);
        mapMisc.put('ChampAtten', eAt);
        mapMisc.put('FriendSession', dfE2);
        mapMisc.put('FriendSession2', dfE4);
        mapMisc.put('FriendAtten', eAt2);
        
        mapMisc.put('RegionPostcode', rp);
        mapMisc.put('Pack', pack);
        mapMisc.put('Action', act);
        // mapMisc.put('DFChange',dcc);
        mapMisc.put('Demographic',dg);
        
        
        return mapMisc;
        
    }
    
    
    
}