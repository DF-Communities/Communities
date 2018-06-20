@isTest
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for WEBC_CommunityWrapper
 *  Author  : Lakshmi Rajendram
 *  Date    : 24-02-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/

Public class WEBC_CommunityWrapper_Test{
    
    static testMethod void testWEBC_CommunityWrapper(){
        
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
        
        DF_Contact__c DFc = ( DF_Contact__c )mapTestData.get('DFc');
        Map<String, Community_Settings__c> mapCs = ( Map<String, Community_Settings__c >)mapTestData.get('cs');
        test.starttest();
        Contact contact = DF_Utils.getContactRecord(dfc);

        Community_Settings__c cs=( Community_Settings__c )mapCs.get('cs'); 
        Map<String, Community_Settings__c> mapCs1 = ( Map<String, Community_Settings__c>)mapTestData.get('cs1');
        
        Community_Settings__c cs1=( Community_Settings__c )mapCs.get('cs1'); 
        Map<String, Community_Settings__c> mapCs2 = ( Map<String, Community_Settings__c >)mapTestData.get('cs2');
        
        Community_Settings__c cs2=( Community_Settings__c)mapCs.get('cs2'); 
        string prefix='DF';
        
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper(prefix);
        string values=community.getCustomSetting(prefix);
        
        String sTemplateName = 'DF' + '_Verification_Request';
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = :sTemplateName];
        
        User u = (User)mapTestData.get('User');
        User u2 =community.registerUser('test','test', 'test@test.com', 'password',false);
        
        Contact c2 = WEBC_CommunityWrapper.getContactRecordForUser(u);

        Account a = (Account)mapTestData.get('Account');

        boolean b = community.sendVerificationRequest(contact ,'password');
        b = community.sendVerificationRequest(contact ,'password', 'register-community');
        b = community.sendVerificationRequest(contact ,'password', 'register=community','Community_Admin_Verification_Request');
  
        //At some point this can be disgarded  
      b = community.sendAdminVerificationRequest(contact, 'xxOrg', 'password', 'register-admin', 'Community_Admin_Verification_Request');    
        
        String aid = a.Id;
        b = community.sendOrgAdminVerificationRequest(contact, aid, a.Name, 'Test', 'password');

        String s = community.getOrgAdminUserName('test', 'test.com');

        User u3 = community.registerOrgAdminUser(contact, 'test', 'password', false);
        
        b = WEBC_CommunityWrapper.hasUserRecord(contact);

        b = WEBC_CommunityWrapper.isPasswordOK('Passw0rd22');
        b = WEBC_CommunityWrapper.isEmailAddressOK('test-user@test.com');
        b = WEBC_CommunityWrapper.isOrgAdmin();
        b = WEBC_CommunityWrapper.isLoggedIn;

        b = community.sendForgotPasswordEmail(contact);
        b = community.sendForgotPasswordEmail(u);
        b = WEBC_CommunityWrapper.isPhoneOK('0123456709');
        String pfix = WEBC_CommunityWrapper.getAdminUserNamePrefix(u.username);
        string random = WEBC_CommunityWrapper.generateRandomString(15);
    }
}