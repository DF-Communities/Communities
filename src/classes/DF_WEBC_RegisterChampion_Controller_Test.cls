/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_RegisterChampion_Controller 
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
global class DF_WEBC_RegisterChampion_Controller_Test {
    
    @IsTest(SeeAllData=false) 
    global static void registerChampionTest () {
    
        // Instantiate a new controller with all parameters in the page    
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        Map<String,Community_Settings__c> mapCs1 = (Map<String, Community_Settings__c>)mapTestData.get('cs1');
        Map<String,Community_Settings__c> mapCs = (Map<String, Community_Settings__c>)mapTestData.get('cs');
        Map<String,Community_Settings__c> mapCs2 = (Map<String, Community_Settings__c>)mapTestData.get('cs2');
        Map<String,Community_Settings__c> mapCs3 = (Map<String, Community_Settings__c>)mapTestData.get('cs3');
        Map<String,Community_Settings__c> mapCs4 = (Map<String, Community_Settings__c>)mapTestData.get('cs4');
        Map<String,Community_Settings__c> mapCs5 = (Map<String, Community_Settings__c>)mapTestData.get('cs5');      

        DF_WEBC_RegisterChampion_Controller controller = new DF_WEBC_RegisterChampion_Controller ();
        
        PageReference registerChampion = Page.DF_WEBC_RegisterChampion;
        
        registerChampion.getParameters().put('recaptcha_challenge_field','test values');
        registerChampion.getParameters().put('recaptcha_response_field','test values');
        Test.setCurrentPage(registerChampion);
        
        controller = new DF_WEBC_RegisterChampion_Controller();
        
        System.assertNotEquals(controller,null);  
        
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
        DF_WEBC_RegisterChampion_Controller controller = new DF_WEBC_RegisterChampion_Controller ();
        
        PageReference registerChampion = Page.DF_WEBC_RegisterChampion;
        
        test.setCurrentPage(registerChampion);
        
        controller = new DF_WEBC_RegisterChampion_Controller();
        
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