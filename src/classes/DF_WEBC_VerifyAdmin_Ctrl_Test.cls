/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_VerifyAdmin_Controller
 *  Author  : Lakshmi Rajendram
 *  Date    : 12-03-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
public with sharing class  DF_WEBC_VerifyAdmin_Ctrl_Test {
    
    
    static testMethod void doTest() {
    
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');  
        String key = community.secretKey; 

        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('adminContact2');
        Partner_Organisation__c partner = (Partner_Organisation__c)mapTestData.get('partnerOrg');

        /* Mock up a verification Key */
        String sContactKey = contact.id + ':::' + partner.id + ':::passw0000rd:::RandomString';
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');
        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        
        DF_WEBC_VerifyAdmin_Controller ctl = new DF_WEBC_VerifyAdmin_Controller();        
        PageReference pr = ctl.doAction();
        
        
    }

    /* Bad Contact Id */
    static testMethod void doTest2() {
    
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');  
        String key = community.secretKey; 

        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('adminContact2');
        Partner_Organisation__c partner = (Partner_Organisation__c)mapTestData.get('partnerOrg');

        /* Mock up a verification Key */
        String sContactKey = contact.id + '_xxx:::' + partner.id + ':::passw0000rd:::RandomString';
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');
        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        
        DF_WEBC_VerifyAdmin_Controller ctl = new DF_WEBC_VerifyAdmin_Controller();        
        PageReference pr = ctl.doAction();
        
        
    }

    /* Bad Secret Key */
    static testMethod void doTest3() {
    
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');  
        String key = community.secretKey; 

        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('adminContact2');
        Partner_Organisation__c partner = (Partner_Organisation__c)mapTestData.get('partnerOrg');

        /* Mock up a verification Key */
        String sContactKey = contact.id + ':::' + partner.id + ':::passw0000rd:::RandomString';
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, '');
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');
        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        
        DF_WEBC_VerifyAdmin_Controller ctl = new DF_WEBC_VerifyAdmin_Controller();        
        PageReference pr = ctl.doAction();
        
        
    }

    /* Bad Org Id */
    static testMethod void doTest4() {
    
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');  
        String key = community.secretKey; 

        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('adminContact2');
        Partner_Organisation__c partner = (Partner_Organisation__c)mapTestData.get('partnerOrg');

        /* Mock up a verification Key */
        String sContactKey = contact.id + ':::' + partner.id + '_xxx:::passw0000rd:::RandomString';
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');
        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8'); 

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        
        DF_WEBC_VerifyAdmin_Controller ctl = new DF_WEBC_VerifyAdmin_Controller();        
        PageReference pr = ctl.doAction();
        
        
    }

    /* Bad Random String */
    static testMethod void doTest5() {
    
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');  
        String key = community.secretKey; 

        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('adminContact2');
        Partner_Organisation__c partner = (Partner_Organisation__c)mapTestData.get('partnerOrg');

        /* Mock up a verification Key */
        String sContactKey = contact.id + ':::' + partner.id + ':::passw0000rd:::RandomString_xxx';
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');
        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);
        
        DF_WEBC_VerifyAdmin_Controller ctl = new DF_WEBC_VerifyAdmin_Controller();        
        PageReference pr = ctl.doAction();
        
        
    }


}