@isTest
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_VerifyRegistration_Controller
 *  Author  : Lakshmi Rajendram
 *  Date    : 29-09-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/

public with sharing class DF_WEBC_VerifyRegistration_Ctlr_Test {

    static testmethod void CoverMethod(){
    
    Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('contact2');

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');    
        String key = community.secretKey;

        /* Mock up a verification Key */
        String sContactKey = contact.id + ':::passw000rd:::RandomString';
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');

        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        test.starttest();
        DF_WEBC_VerifyRegistration_Controller ctl = new DF_WEBC_VerifyRegistration_Controller();                
        PageReference pr = ctl.doAction();
        DF_Contact__c dfc =[select id,portal_contact__c,portal_user__c from df_contact__c where portal_contact__c =:contact.id];
        

    }
    
    /* Bad Random String */
    static testMethod void doTest2() {
    
        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('contact2');

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');    

        /* Mock up a verification Key */
        String sContactKey = contact.id + ':::passw000rd:::RandomString';
        String key = community.secretKey;
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');

        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        
        DF_WEBC_VerifyRegistration_Controller ctl = new DF_WEBC_VerifyRegistration_Controller();                 
        PageReference pr = ctl.doAction();
        
        
    }


    /* Bad encryption Key */
    static testMethod void doTest3() {
    
        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('contact');
        test.starttest();
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');    

        /* Mock up a verification Key */
        String sContactKey = contact.id + ':::passw000rd:::BadRandomString';
        String key = community.secretKey;
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, '');
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');

        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        
        DF_WEBC_VerifyRegistration_Controller ctl = new DF_WEBC_VerifyRegistration_Controller();                 
        PageReference pr = ctl.doAction();
        
        
    }

    /* Bad Contact Id  */
    static testMethod void doTest4() {
    
        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('contact');
        User user = (User)mapTestData.get('User');
        test.starttest();
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');    

        /* Mock up a verification Key */
        String sContactKey = '00B20000006RoYI:::passw000rd:::RandomString';
        String key = community.secretKey;
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, '');
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');

        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        
        DF_WEBC_VerifyRegistration_Controller ctl = new DF_WEBC_VerifyRegistration_Controller();                
        PageReference pr = ctl.doAction();
        ctl.doPostRegistration(user) ;
        
        
    }

}