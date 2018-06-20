/******************************************************************************************
*  Alzheimer's Society
*  
*  Purpose : APEX Test Class for DF_WEBC_RegisterAdmin_Controller
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
global without sharing class DF_WEBC_RegisterAdmin_Controller_Test {
    
    @IsTest(SeeAllData=false) global static void registerAdminTest () {
        // Instantiate a new controller with all parameters in the page
        
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        Map<String,Community_Settings__c> mapCs1 = (Map<String, Community_Settings__c>)mapTestData.get('cs1');
        Map<String,Community_Settings__c> mapCs = (Map<String, Community_Settings__c>)mapTestData.get('cs');
        Map<String,Community_Settings__c> mapCs2 = (Map<String, Community_Settings__c>)mapTestData.get('cs2');
        Map<String,Community_Settings__c> mapCs3 = (Map<String, Community_Settings__c>)mapTestData.get('cs3');
        Map<String,Community_Settings__c> mapCs4 = (Map<String, Community_Settings__c>)mapTestData.get('cs4');
        Map<String,Community_Settings__c> mapCs5 = (Map<String, Community_Settings__c>)mapTestData.get('cs5');      
        DF_WEBC_RegisterAdmin_Controller controller = new DF_WEBC_RegisterAdmin_Controller ();
        
        PageReference registerAdmin = Page.DF_WEBC_RegisterAdmin;
        registerAdmin.getParameters().put('recaptcha_challenge_field','test values');
        registerAdmin.getParameters().put('recaptcha_response_field','test values');
        test.setCurrentPage(registerAdmin);
        
        controller = new DF_WEBC_RegisterAdmin_Controller();
        
        System.assertNotEquals(controller,null);  
        
        
        
        
        controller.firstName = 'Test';
        controller.orgName='test';
        controller.lastName = 'Test';
        controller.employees='4';
        controller.userName ='test@test.com';
        controller.postCode = 'Test';
        controller.street= 'Test';
        controller.city= 'Test';
        controller.county= 'Test';
        controller.country= 'Test';
        controller.telephone = '01111111111';
        controller.emailDomain = 'Test';
        controller.emailAddress = 'Test@Test.com';
        controller.emailAddress= 'Test@Test.com';
        controller.password = 'Test';
        controller.password2 = 'Test';
        
        
        System.assertEquals(null,controller.reset());
        
    }    
    
    @IsTest(SeeAllData=false) 
    global static void registerFriendTestEmptyVals () {
        // Instantiate a new controller with all parameters in the page
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        Map<String,Community_Settings__c> mapCs1 = (Map<String, Community_Settings__c>)mapTestData.get('cs1');
        Map<String,Community_Settings__c> mapCs = (Map<String, Community_Settings__c>)mapTestData.get('cs');
        Map<String,Community_Settings__c> mapCs2 = (Map<String, Community_Settings__c>)mapTestData.get('cs2');
        Map<String,Community_Settings__c> mapCs3 = (Map<String, Community_Settings__c>)mapTestData.get('cs3');
        Map<String,Community_Settings__c> mapCs4 = (Map<String, Community_Settings__c>)mapTestData.get('cs4');
        Map<String,Community_Settings__c> mapCs5 = (Map<String, Community_Settings__c>)mapTestData.get('cs5'); 
        DF_WEBC_RegisterAdmin_Controller controller = new DF_WEBC_RegisterAdmin_Controller ();
        
        PageReference registerAdmin = Page.DF_WEBC_RegisterAdmin;
        
        test.setCurrentPage(registerAdmin);
        
        controller = new DF_WEBC_RegisterAdmin_Controller();
        
        controller.firstName = '';
        controller.orgName='';
        controller.lastName = '';
        controller.employees='';
        controller.userName ='';
        controller.postCode = '';
        controller.street= '';
        controller.city= '';
        controller.county= '';
        controller.country= '';
        controller.telephone = '';
        controller.emailDomain = '';
        controller.emailAddress = '';
        controller.emailAddress= '';
        controller.password = '';
        controller.password2 = '';
        controller.reset();
        
        
    }    
    
    
}