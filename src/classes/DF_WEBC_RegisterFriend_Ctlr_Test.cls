/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_RegisterFriend_Controller
 *  Author  : Lakshmi Rajendram
 *  Date    : 23-02-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
global without sharing class DF_WEBC_RegisterFriend_Ctlr_Test {
  
    @IsTest(SeeAllData=false) 
    global static void registerFriendTest () {
        
        // Instantiate a new controller with all parameters in the page        
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        Map<String,Community_Settings__c> mapCs1 = (Map<String, Community_Settings__c>)mapTestData.get('cs1');
        Map<String,Community_Settings__c> mapCs = (Map<String, Community_Settings__c>)mapTestData.get('cs');
        Map<String,Community_Settings__c> mapCs2 = (Map<String, Community_Settings__c>)mapTestData.get('cs2');
        Map<String,Community_Settings__c> mapCs3 = (Map<String, Community_Settings__c>)mapTestData.get('cs3');
        Map<String,Community_Settings__c> mapCs4 = (Map<String, Community_Settings__c>)mapTestData.get('cs4');
        Map<String,Community_Settings__c> mapCs5 = (Map<String, Community_Settings__c>)mapTestData.get('cs5');      
        DF_WEBC_RegisterFriend_Controller controller = new DF_WEBC_RegisterFriend_Controller ();
        
        PageReference registerFriend = Page.DF_WEBC_RegisterFriend;
        registerFriend.getParameters().put('recaptcha_challenge_field','test values');
        registerFriend.getParameters().put('recaptcha_response_field','test values');
        Test.setCurrentPage(registerFriend);
        
        controller = new DF_WEBC_RegisterFriend_Controller();
        
        System.assertNotEquals(controller,null);  
        
        controller.userid ='Test';
        controller.firstName = 'Test';        
        controller.lastName = 'Test';             
        controller.postCode = 'Test';
        controller.street= 'Test';
        controller.city= 'Test';
        controller.county= 'Test';
        controller.country= 'Test';
        controller.telephone = '01111111111';
        controller.emailAddress = 'Test@Test.com';
        controller.emailAddress= 'Test@Test.com';
        controller.password = 'Test';
        controller.password2 = 'Test';
        controller.newsletter=true;
        controller.packRequest=True;
            
        System.assertEquals(null,controller.reset());

        List<SelectOption> lis = controller.titleList;
        lis = controller.genderOptionList;
        lis = controller.ethnicGroupOptionList;
        
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
        DF_WEBC_RegisterFriend_Controller controller = new DF_WEBC_RegisterFriend_Controller ();
        
        PageReference registerFriend = Page.DF_WEBC_RegisterFriend;
        
        test.setCurrentPage(registerFriend);
        
        controller = new DF_WEBC_RegisterFriend_Controller();
        controller.userid ='';
        controller.firstName = '';
        controller.lastName = '';
        controller.postCode = '';
        controller.street= '';
        controller.city= '';
        controller.county= '';
        controller.country= '';
        controller.telephone = '';
        controller.emailAddress = '';
        controller.emailAddress= '';
        controller.password = '';
        controller.password2 = '';
        controller.newsletter=False;
        controller.packRequest=False;
        controller.reset();
        
        
    
    
    
}

}