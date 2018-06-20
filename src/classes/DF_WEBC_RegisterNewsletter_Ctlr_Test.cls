/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for WEBC_RegisterNewsletter
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
Global class DF_WEBC_RegisterNewsletter_Ctlr_Test {

  
    @IsTest(SeeAllData=false) global static void registerNewsletterTest () {
        // Instantiate a new controller with all parameters in the page
        
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        DF_WEBC_RegisterNewsletter_Controller controller = new DF_WEBC_RegisterNewsletter_Controller ();
        
        PageReference registerNewsletter = Page.DF_WEBC_RegisterNewsletter;
        registerNewsletter.getParameters().put('recaptcha_challenge_field','test values');
        registerNewsletter.getParameters().put('recaptcha_response_field','test values');
        test.setCurrentPage(registerNewsletter);
        
        controller = new DF_WEBC_RegisterNewsletter_Controller();        
        System.assertNotEquals(controller,null);  
        
        Page_Snippet__c s = controller.newsletterSignupText;
 
        User u = (User)mapTestData.get('User');  
        
        controller.userid ='Test';
        controller.firstName = 'Test';        
        controller.lastName = 'Test';             
        
        controller.emailAddress = 'Test@Test.com';
        controller.emailAddress2 = 'Test@Test.com';
                
        controller.newsletter=true;
        controller.APIUser=u;
    
        
        System.assertEquals(null,controller.reset());
        
    }    
    
    @IsTest(SeeAllData=false) 
    global static void registerNewsletterTestEmptyVals () {

        // Instantiate a new controller with all parameters in the page
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        DF_WEBC_RegisterNewsletter_Controller controller = new DF_WEBC_RegisterNewsletter_Controller ();
        User u = (User)mapTestData.get('User');  
        PageReference registerNewsletter = Page.DF_WEBC_RegisterNewsletter;
        
        test.setCurrentPage(registerNewsletter);
        
        controller = new DF_WEBC_RegisterNewsletter_Controller();
        controller.userid ='';
        controller.firstName = '';
        controller.lastName = '';
        controller.emailAddress = '';
        controller.emailAddress2= '';
        controller.newsletter=False;
        controller.APIUser=u;
        
        
    
    
    
}

}