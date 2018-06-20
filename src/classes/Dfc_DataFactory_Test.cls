/***********************************************************************************************
* 
*   @author          Valerie Dunphy, Conseq
*   @date            1/12-2015
*   @description    

*   Set up Test Data for testing Dementia Friendly Communities
*   Account 'Test Account Name' owned by SysAdmin
*   Users  
*      test1.testcontact@myemail.com  
        - linked to a Draft Community 'DRAFT TEST COMMUNITY'

*      test2.testcontact@myemail.com  
*        - linked to an Active Community 'ACTIVE TEST COMMUNITY' with Activities and Assessment
*
***********************************************************************************************/
@isTest
public with sharing class Dfc_DataFactory_Test {



public static testMethod void TestDataCreation()
{    
   
    User sysAdminUser =  getSysAdminUser();

    Account account = new Account(Name='Test Account Name', OwnerId = sysAdminUser.Id);
    insert account;
 
     
    /*========== Create 4 Test Contact records   ===============*/ 

    List<Contact> contacts = createContacts(account) ;  
   
    
    /*========== Set up some users linked to those contacts   ===============*/ 

    List<User> users = createUsers(account, contacts); 
     

    /*========== Set up some DF_Contact df, linked to contacts and users ===============*/                  
  
    DF_Contact__c df1 = createDF_Contact(account, users[0], contacts[0], false);
    DF_Contact__c df2 = createDF_Contact(account, users[1], contacts[1], false);  // Unverified - not linked to User
    DF_Contact__c df3 = createDF_Contact(account, users[2], contacts[2], false);
    DF_Contact__c df4 = createDF_Contact(account, users[3], contacts[3], true);  // champion

  
    // Create test data for Dementia Friendly Communities

    DFC_DAA_Region__c region = new DFC_DAA_Region__c(
        Name = 'East of England',
        Country__c = 'England',
        DAA_Regional_Lead__c = [SELECT Id FROM User WHERE isActive = true LIMIT 1].Id,
        Sequence__c=1 );
    insert region;


    // DFC County object
    DFC_County__c county = new DFC_County__c( Name ='Hertfordshire', Region__c='South East', Country__c='England' );
    insert county;

    // DFC Alliance object linked to DAA Region
    DFC_Alliance__c alliance = new DFC_Alliance__c(Name = 'DFC Test Alliance', Region__c = 'East of England', DAA_Region__c = region.Id);
    insert alliance;
    update alliance;

    /*========== DFC Action Areas ===============*/
    List<DFC_Action_Area__c> actionAreas = createActionAreas();
   
   
    /*========== Set up 2 communities   ===============*/ 

    DFC_Community__c draftCommunity  = createDFC('1',  alliance, region, county, 'Draft');
    System.debug('>>>>>>>  CREATED DRAFT COMMUNITY '+draftCommunity.Name__c);

    DFC_Community__c activeCommunity = createDFC('2',  alliance, region, county, 'Active');
    System.debug('>>>>>>>  CREATED ACTIVE COMMUNITY '+activeCommunity.Name__c);

    activeCommunity.Location_Type__c = 'Village';
    update activeCommunity;

    List<DFC_Community__c> communityList = [SELECT Id FROM DFC_Community__c c WHERE c.Name__c = 'ACTIVE TEST COMMUNITY']; 

    System.debug('>>>>>>>  COMMUNITY LIST SIZE '+communityList.size());
 

    // Create 2 Representatives - one for each Community
    DFC_Community_Representative__c rep1 = createRepresentative(df1, draftCommunity);
    DFC_Community_Representative__c rep2 = createRepresentative(df2, activeCommunity);


    /*========== DFC Activities===============*/

    DFC_Activity__c activity = new DFC_Activity__c(
        Title__c = 'Activity 1',
        Description__c = 'Activity Description',
        Community__c = activeCommunity.Id,
        Start__c =  system.today() + 90);
    insert activity;

    createAttachment(activity.Id);
   

   /*========== Page, Page_Display_Snippet and  Snippets ===============*/

    Page__c page = new Page__c(isPublished__c = true, Title__c = 'DF Comunity Application Form', Unique_Text__c = 'dfc_apply');
    insert page;

    Page_Snippet__c snippet1 =  createSnippet('dfc-apply-submit-intro', page);
    Page_Snippet__c snippet2 =  createSnippet('dfc-apply-intro', page);
    Page_Snippet__c snippet3 =  createSnippet('dfc-apply-action-areas', page);
     

    /*========== DFC Resources ===============*/

    createResources();

    /*========== DFC Assessment Community Approved in 2013, Year 1 is 2014===============*/

    DFC_Assessment__c assessment = new DFC_Assessment__c(

            Community__c = activeCommunity.Id,
            Status__c = 'Draft',
            Year_Number__c = 1
        );

     try {
         insert assessment;  
          system.debug('>>>>>>>>>>>>>> Dfc_DataFactoryTest - Assessment created >>>>>>'+assessment.Id);
          
     } catch (Exception x) {

          system.debug('>>>>>>>>>>>>>> Dfc_DataFactoryTest - Assessment NOT created >>>>>>');
         system.debug(x.getMessage());

     }
        
    /*========== DFC Assessment Questions ===============*/

    List<DFC_Assessment_Question__c> questions = createQuestions();
  

    /*========== DFC Assessment Answers ===============*/

    List<DFC_Assessment_Answer__c> answers = createAnswers(questions, assessment);


    Community_Settings__c cs=new Community_Settings__c();
    cs.name='DF_Default_Account_Id';
    cs.value__c=account.id;
    insert cs;
    
    Community_Settings__c cs1 =new Community_Settings__c();
    cs1.name='DF_Default_Profile_Id';
     Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP']; 
    cs1.value__c=profileForUser.Id;
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
    rc1.Name = 'Friend';
    rc1.Code_Value__c = 'DEMENTIAFRIEND123';
    insert rc1;
}


String getCustomSettingTestValue(String name){
        
    if ( name == 'Default_Account_Id') { 
        Account a = new Account(Name='Test Account Name');
        a.OwnerId = testSysAdminUser.Id;
        insert a;
        return a.Id;
    }
    
    if ( name == 'Default_Account_Owner_Id') { 
        return testSysAdminUser.Id;
    }

    if ( name == 'Default_Profile_Id' ) {             
        return testProfile.Id;
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
        return testSysAdminUser.Id;
    }        
    
    return 'RandomString';

}    

/*
 *  Creates and returns a Contact for the given address with email address test1@testcontact@myemail.com
 */
static List<Contact> createContacts(Account account) {

    List<Contact> contactsList = new List<Contact>{};

    for (Integer i = 1; i < 6; i++) {

        Contact contact = new Contact(
            Email = 'test'+i+'.testcontact@myemail.com', // test1.testcontact@myemail.com
            FirstName = 'Test',
            LastName = 'TestContact'+i,
            AccountId = account.Id,
            Title='Mr'
            );

        contactsList.add(contact);

    }
    try {
         insert contactsList;  
          
    } catch (Exception x) {
            system.debug(x.getMessage());
    }  
    return contactsList;
  

}

static User getSysAdminUser() {

    Map<String,Id> roles = new Map<String,Id>();
    List<UserRole> rl = [select Id, name from UserRole];
    for (UserRole r : rl) { roles.put(r.name, r.Id); }
    
    User sysAdminUser =  [select Id from user where UserRoleId =:roles.get('CEO') and isActive=true limit 1];

    return sysAdminUser;

}

/*
 *  Creates and returns a User for the given Contact, with the 'DF HVCP' Profile
 */
 static List<User> createUsers(Account account, List<Contact> contacts) {

    List<User> usersList = new List<User>{};

    for (Contact contact : contacts ) {

        User u = new User();

        // Link the new user to the given Contact
        u.ContactId = contact.Id;

        // Pick up some data from the given Contact
        u.Email= contact.Email;                       // test1.testcontact@myemail.com
        u.UserName = getUserNamePrefix() + contact.Email;
        u.FirstName = contact.FirstName;
        u.LastName = contact.LastName;

        u.Alias = u.Email.substring(0,5);  // 'test5'
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US'; 
        u.LocaleSidKey = 'en_US';
        u.ProfileId = testProfile.Id;
        u.TimeZoneSidKey = 'Europe/London';

        usersList.add(u);

    }

   try {
        insert usersList;
  
      
    } catch (Exception x) {
        system.debug('>>>>>>>>>>>>>> Dfc_DataFactoryTest - UNABLE TO CREATE TEST USER');
        system.debug(x.getMessage());
    }  

    return usersList;

  }  

  // This method dynamically creates a username prefix that will make ensure username uniqueness.

   static String getUserNamePrefix(){
         // http://www.nimbleams.com/blog/2014/1/19/apex-testing-username-creation-best-practice/
        return UserInfo.getOrganizationId() + System.now().millisecond();

    }


/*
 *  Creates and returns a DFC Community of the given status, linked to Alliance and County
 *  Active Community Submitted and Approved 3 years ago
 */
  static DFC_Community__c createDFC(String ordinal, DFC_Alliance__c alliance, DFC_DAA_Region__c region, DFC_County__c county, String status) {

    DFC_Community__c comm= new DFC_Community__c();
    comm.Status__c = status;
    comm.DA_Alliance__c = alliance.Id;
    comm.Region__c = region.Id;
    comm.County__c = county.Id;
    comm.Name__c = status.toUpperCase() + ' TEST COMMUNITY';

    comm.Duplicate_Confirmation__c = true;
    comm.Country__c = 'England';
    comm.Central_Location__c = 'South West';
    comm.Location__c = 'Here Somewhere';
    comm.Location_Type__c = 'Village';
    comm.Population__c=100;

    if (status!=null && status.equals('Active')) {
            comm.Date_Submitted__c = system.today().addYears(-3);
            comm.Date_Approved__c  = system.today().addYears(-3);
    }

    // Causes the trigger to execute which populates the regional lead 
    insert comm;
    return comm;
}



  static String getFriendRecordTypeId() { return [Select Id From RecordType Where DeveloperName='Dementia_Friend' And sObjectType='DF_Contact__c'].Id; }
  static String getChampionRecordTypeId() { return [Select Id From RecordType Where DeveloperName='Dementia_Friend_Champion' And sObjectType='DF_Contact__c'].Id;}


/*
 *  Creates and returns a DF_Contact of the given status, 
 */
  static DF_Contact__c createDF_Contact(Account account, User user, Contact contact, boolean champion){

    system.debug('****  Dfc_DataFactory_Test Test START');
    system.debug('****  Dfc_DataFactory_Test Test *** DF_Contact__c Contact: ' + contact.Email  + ' '+contact.Email);
    system.debug('****  Dfc_DataFactory_Test Test *** DF_Contact__c User: ' + user.Email  + ' '+user.Email);
    
    DF_Contact__c df = new DF_Contact__c();

    df.Title__c = 'Mr';

    // If the user is Null, (User not verified), take the details from the Contact
    if (user==NULL) {
        df.First_Name__c =contact.FirstName;
        df.Last_Name__c = contact.LastName;
        df.Name=contact.FirstName+' ' +contact.FirstName;
        df.Email__c = contact.Email;

    // Otherwise take the details from the User
    } else {
        df.Portal_Contact__c = user.Contact.id;
        df.Portal_User__c = user.Id;
        df.Email__c = user.Email;
        df.First_Name__c =user.FirstName;
        df.Last_Name__c = user.LastName;
    }

    if ( champion ) {
        df.RecordTypeId = getChampionRecordTypeId();
        df.Total_No_of_Completed_Info_Sessions__c = 4 ;
        df.Total_No_of_Available_Info_Sessions__c = 4 ;
        df.Total_No_of_Cancelled_Info_Sessions__c = 4 ;
        df.Total_No_of_Friends_Created__c = 4 ;
        df.Number_of_Public_Sessions_Run__c = 4 ;
        df.Number_of_Private_Sessions_Run__c = 4 ;
    } else {
        df.RecordTypeId = getFriendRecordTypeId();
    }

    df.Title__c = 'Mr';
    df.Contact_Number__c = '02085180934';
    df.Postcode__c = 'TS1 3TN';
    df.Street__c = 'test street';
    df.City__c = 'test';
    df.County__c = 'test county';
    df.Country__c = 'test country';
    df.Newsletters__c = true;
 
    system.debug('**** DF Contact Test Method: ');

    try {

        system.debug('DF Context Insert Now: ');        
        insert df;
        system.debug('DF Context Insert Completed: ');        
 
    } catch (Exception x) {

        system.debug('DF Context Insert Failed: ');
        system.debug(x.getMessage());
    }   

    return df;

  }

 static List<DFC_Action_Area__c> createActionAreas() {

        List<DFC_Action_Area__c> areasList = new List<DFC_Action_Area__c>{};

        for (Integer i = 0; i < 9; i++){

            DFC_Action_Area__c a= new DFC_Action_Area__c();
            a.Name = 'Action Area '+i;
            a.Active__c = true;
            a.Sequence__c = i;

            areasList.add(a);

        }

        insert areasList;
        return areasList;
   }

   static List<DFC_Assessment_Question__c> createQuestions() {

        List<DFC_Assessment_Question__c> questionsList = new List<DFC_Assessment_Question__c>{};

        for (Integer i = 0; i < 9; i++) {

            DFC_Assessment_Question__c q = new DFC_Assessment_Question__c();
     
            q.Active__c = true;
            q.Capture_Extra__c = true;
            q.Capture_Extra_On_Option__c = '';
            q.Capture_Extra_Required__c = true;
            q.Continuation__c = true;
            q.Guidance__c = 'help' + i;
            q.Options__c = 'One '+ i;
            q.Include_Other__c = true;
            q.Other_Option_Label__c = 'Please give another option';
            q.Question_Style__c = i < 8 ? 'Radio' : 'Multi';
            q.Question_Text__c = 'Question text ?'+i;
            q.Repeat_Per_Action_Area__c = i < 8 ? false: true ;
            q.Sequence__c = i * 10;
            q.Title__c = 'This is the title';

            questionsList.add(q);

        }

        insert questionsList;
        return questionsList;

    }


   static List<DFC_Assessment_Answer__c> createAnswers(List<DFC_Assessment_Question__c> questions, DFC_Assessment__c assessment) {

        List<DFC_Assessment_Answer__c> answersList = new List<DFC_Assessment_Answer__c>{};

        for (DFC_Assessment_Question__c question : questions) {

            DFC_Assessment_Answer__c a= new DFC_Assessment_Answer__c();
            a.Assessment__c = assessment.Id;
            a.Question__c = question.Id;
         
            a.Capture_Extra__c = true;
            a.Capture_Extra_On_Option__c = '';
            a.Entered_Answer__c = 'Answer text';
            a.Continuation__c = true;
            a.Capture_Extra_Required__c = true;
            a.Explanation__c = 'Explanation text';
            a.Guidance__c = 'help';
            a.Extra_Information__c = 'Extra information';
            a.Include_Other__c = true;
            a.Sequence__c = 10;
            a.Continuation__c = true;
            a.Options__c = 'One';
            a.Other_Option_Label__c = 'Please give another option';
            a.Question_Style__c = 'Radio';
            a.Question_Text__c = 'Is your community a success ?';
            a.Repeat_Per_Action_Area__c = false;
            a.Title__c = 'This is the title';

            answersList.add(a);

        }

        insert answersList;
        return answersList;

    }


   static Page_Snippet__c createSnippet(String unique, Page__c page) {

        Page_Snippet__c snippet = new Page_Snippet__c(
            Name__c = unique, 
            Unique_Name__c = unique, 
            Body_Text__c = unique
        );
        insert snippet;

        Page_Display_Snippet__c  pds = new  Page_Display_Snippet__c();
        pds.Page_Snippet__c = snippet.Id;
        pds.Page__c = page.Id;

        insert pds;

        return snippet;
  }

 static List<DFC_Resource__c>  createResources () {

    List<DFC_Resource__c> resourceList = new List<DFC_Resource__c>{};

   for (Integer i = 0; i < 9; i++) {
        DFC_Resource__c r = new DFC_Resource__c();
        r.Applies_To_Status__c = 'Draft';
        r.Description__c = 'This is a Dementia Friendly Community help file ' + i;
        r.Sequence__c = i*10;
        r.Title__c = 'Help '+ i;

        resourceList.add(r);
    }

    insert resourceList;
    for (DFC_Resource__c r : resourceList) {
            createAttachment(r.Id);
     }

     return resourceList;

}

    static DFC_Community_Representative__c createRepresentative(DF_Contact__c df, DFC_Community__c comm) {

        DFC_Community_Representative__c rep = new DFC_Community_Representative__c(
            Community__c = comm.id,
            DF_Contact__c = df.Id,
            Role__c = 'Registered'
            );

        try{
        insert rep;
        update rep;
        } catch (Exception e) {
        
        }

        return rep;

    }


  static Attachment createAttachment(String parentId) {

    Attachment attach=new Attachment();

    attach.Name='Unit Test Attachment ';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.Body=bodyBlob;
    attach.ParentId=parentId;
    attach.ContentType = 'application/msword';
    attach.IsPrivate = false;
    attach.Description = 'Test';

    insert attach;
    return attach;

  }

  static User testSysAdminUser {

    get {
        if ( testSysAdminUser == null ) {
            testSysAdminUser = [select Id from user where UserRole.Name ='CEO' and isActive=true limit 1];
        }
        return testSysAdminUser;
     }
     
 }

static Profile testProfile {

    get {
        if ( testProfile == null) {
             testProfile = [SELECT Id FROM Profile WHERE Name='DF HVCP'];
        }
        return testProfile;
    }
}

 
   
}