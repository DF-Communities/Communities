/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBContactForm.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex test class.
 *               
 *  Modification History
 *  Date            Who         Description 
 *                    
*******************************************************************************************/
@isTest
private class WEBContactFormTest {

    static testMethod void testForm() {
            
        Profile profileForUser = [SELECT Id FROM Profile WHERE Name='DF HVCP']; 
		    User u = (User)DF_DataFactory_Test.getTestData().get('User');
         System.runAs(u) {
         // The following code runs as user 'u' 
         System.debug('Current User: ' + UserInfo.getUserName());
         System.debug('Current Profile: ' + UserInfo.getProfileId()); 
           
       	PageReference contactForm = Page.WEBContactForm;
       	contactForm.getParameters().put('recaptcha_challenge_field','test values');
       	contactForm.getParameters().put('recaptcha_response_field','test values');
       	test.setCurrentPage(contactForm);
       
        WEBContactForm wcf = new WEBContactForm();
        Page_Snippet__c snippet = wcf.contactFormText;
        snippet = wcf.thankyouText;
        Contact c = wcf.contactRecord;
        List<SelectOption> lisOptions = wcf.subjectList;

        //Test with no values;
        
        wcf.submitContactForm();
        
        List<WEBContactMessage__c> wcfList;
        wcfList = [select w.Id from WEBContactMessage__c w];
        system.assertEquals(0, wcfList.size());
        
        		//test with bad values
		
		    wcf.firstName = 'Test';
        wcf.lastName = 'Contact';
        wcf.email = 'test';
        wcf.webSubject = lisOptions[1].getValue();
        wcf.webMessage = 'Test Message'; 
        wcf.captchaResponse = 'notNull';
        
        wcf.submitContactForm();
        
        wcfList = [select w.Id from WEBContactMessage__c w];
        system.assertEquals(0, wcfList.size());
        
        //test with good values 
        
        wcf.firstName = 'Test';
        wcf.lastName = 'Contact';
        wcf.email = 'test.contact@myemail.com';
        wcf.webSubject = lisOptions[1].getValue();
        wcf.webMessage = 'Test Message'; 
        wcf.captchaResponse = 'notNull';
        
        wcf.submitContactForm();
        
        wcfList = [select w.Id from WEBContactMessage__c w];
        system.assertEquals(1, wcfList.size());
       }
        
    }
}