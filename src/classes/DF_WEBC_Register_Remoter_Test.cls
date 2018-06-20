/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test Class for DF_WEBC_Register_Remoter
 *  Author  : Gary Grant
 *  Date    : 17/11/2015
 *  Version : 
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/

@isTest
public class DF_WEBC_Register_Remoter_Test { 

  static testMethod void recpatcha2Test() {

    String s = DF_WEBC_Recaptcha2Handler.captchaSite;
    s = DF_WEBC_Recaptcha2Handler.captchaSecret;

  }  

  // Test with an invite
  static testMethod void doTestInv002() {

    DFC_DataFactory_Test.TestDataCreation();
    DFC_Community__c comm = [select Id from DFC_Community__c where Status__c = 'Active' limit 1];

    DFC_Community_Representative__c invite = new DFC_Community_Representative__c();
    invite.Community__c = comm.id;
    invite.Invited_Email__c = 'gg-tt-nws-c001a@mailinator.com';
    invite.Invited_Name__c = 'Test Test';
    invite.Role__c = 'Invited';
    insert invite; 

    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.inviteId = invite.id;
    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);    
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleCommunityAdminJson(s);

}

 // Test registration for a community user
 static testMethod void doTest() {

    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);    
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleCommunityAdminJson(s);

    }

   //Test with bad name data and mismatched emails 
   static testMethod void doTest2() {
    

    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = '';
    data.firstName = '';
    data.lastName = '';
    data.emailAddress = '@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '';
    data.newsLetter= true;
    data.postCode = '';
    data.street = '';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'p';
    data.password2 = 'p2';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleCommunityAdminJson(s);

    }

    // Test with all bad data and bad passwords
    static testMethod void doTest3() {
    
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = '';
    data.firstName = '';
    data.lastName = '';
    data.emailAddress = '';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '';
    data.newsLetter= true;
    data.postCode = '';
    data.street = '';
    data.city = '';
    data.county = '';
    data.country = '';
    data.password = '';
    data.password2 = 'p2';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = '';
    data.recaptcha_response = '';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleCommunityAdminJson(s);

}

// Test with a null title
static testMethod void doTest3a() {
    
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = 'NULL';
    data.firstName = '';
    data.lastName = '';
    data.emailAddress = '';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '';
    data.newsLetter= true;
    data.postCode = '';
    data.street = '';
    data.city = '';
    data.county = '';
    data.country = '';
    data.password = '';
    data.password2 = 'p2';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = '';
    data.recaptcha_response = '';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleCommunityAdminJson(s);

}

// Test with and existing registration DFC 
static testMethod void doTest4() {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
    dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_REGISTRATION);
    test.startTest();
    update dfc;
  
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.userid = dfc.id;
    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = dfc.Email__c;
    data.emailAddress2 = dfc.Email__c;
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleCommunityAdminJson(s);

}

// Test with all good data
static testMethod void doTest5() {
    
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleCommunityAdminJson(s);

    }

// Test a friend registration
static testMethod void doTest6() {
    
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleFriendJson(s);

}

// Test a Champion Registration
static testMethod void doTest7() {
    
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';
    data.champnewsletter =true;
    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    data.birthDate = '25/03/1966'; 

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleChampionJson(s);

}

// Test a Champion Registration qith a bad birthdate
static testMethod void doTest8() {
    
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '0777000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';
    data.champnewsletter =true;
    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    data.birthDate = '25/03/2015'; 

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleChampionJson(s);

}

// Champion registration with a bad format birth date
static testMethod void doTest9() {
    
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    data.birthDate = 'xxx'; 

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleChampionJson(s);

}

// Test with a null birth date
static testMethod void doTest10() {
    
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    data.birthDate = ''; 

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleChampionJson(s);

}

// Test Digital Friend registration step 1
static testMethod void doTest11() {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        test.startTest();
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.newsLetter= true;

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleDigitalFriendJson(s);


}

// Test Digital Friend registration step 1 convert to DDF
static testMethod void doTest12() {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc2');

    dfc.RecordTypeId = DF_Utils.getDfcRecordTypeName('Registration');
    test.startTest();
    update dfc;

    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.newsLetter= true;
    data.proximity = 'test;test';
    data.ethnicGroup ='test';
    data.telephone = '07770000000';   
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.action='makeDDF';
    data.proximity='test';
    data.ethnicGroup='test';
    data.birthDate = '25/03/2015';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleDigitalFriendJson(s);    

    data.userid='xx';
    s = JSON.serialize(data);
    responseHolder = DF_WEBC_Register_Remoter.handleDigitalFriendJson(s);    

    data.userid=dfc.id;
    s = JSON.serialize(data);
    responseHolder = DF_WEBC_Register_Remoter.handleDigitalFriendJson(s);        


}

// Test subscriber registration 
static testMethod void doTest13() {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        test.startTest();
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.userid = dfc.id;
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.newsLetter= true;

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleSubscriberJson(s);


}

// Test base handler methods not called specifically by other classes
static testMethod void doTest99() { 
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
    test.startTest();
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.userid = dfc.id;
    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = dfc.Email__c;
    data.emailAddress2 = dfc.Email__c;
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    data.birthDate = '25/03/2015'; 

    String sJson = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler handler = new DF_WEBC_RegisterBase_Handler(sJson);
    handler.handleJson();

    // These methods are all overriden so the base methods do not get called by any of the other use cases
    String s = handler.remoteHost;
    s = handler.getEmailTemplateName();
    s = handler.getRecordTypeName();
    s = handler.getCreatedAsValue();
    s = handler.getStartUrl();
    //handler.populateExtendedData();
    boolean b = handler.isExtendedRegistrationDataOK();

}

// Test subscriber registration-invalid email 
static testMethod void doTest14() {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
    test.startTest();
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.userid = dfc.id;
    data.firstName = '';
    data.lastName = '';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator';
    data.newsLetter= true;

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleSubscriberJson(s);


}

//digital friend registration invalid email and name

static testMethod void doTest15() {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
    test.startTest();
    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();

    data.firstName = '';
    data.lastName = '';
    data.emailAddress = 'gg-tt-nws-c001a@mailinatorcom';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinatorcom';
    data.newsLetter= true;

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleDigitalFriendJson(s);


}

static testMethod void doTest16() {
    

    DF_WEBC_RegisterBase_Handler.DataHolder data = new DF_WEBC_RegisterBase_Handler.DataHolder();
    data.orgName= 'Test Org';
    data.sector= 'please specify';
    data.sectorOther= 'test';
    data.employees= '8' ;
    data.orgPostCode= 'TE1 3TH';
    data.orgStreet= 'Test street';
    data.orgcity= 'TestCity';
    data.orgcounty= 'Test';
    data.orgcountry= 'England';
    data.orgTelephone=  '01111111111';
    data.title = 'Mr.';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '07770000000';
    data.newsLetter= true;
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';
    data.packRequest= true;
    data.gender= 'Male';
    data.ethnicGroup = 'White';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    String s = JSON.serialize(data);
    DF_WEBC_RegisterBase_Handler.ResponseHolder responseHolder = DF_WEBC_Register_Remoter.handleOrgAdminJson(s);

}



}