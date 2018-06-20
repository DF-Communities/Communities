/************************************************************************************************
*Alzheimer's Society

     * @author          Lakshmi Vasudevan 
     * @date            24-05-2016
     * @description     Test class for DF_WEBC_RegisterOrgAdmin_Controller
***********************************************************************************************/
@isTest
private class DF_WEBC_RegisterOrgAdmin_Ctl_Test {
    
    @testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();   
    }
    
    static testMethod void myUnitTest() {
     List<User> u  = [select id,name from User where email = 'test.testcontact3@myemail.com' limit 1];
     system.runAs(u[0]){
      PageReference pr = Page.WebChampion; 
    
     test.starttest(); 
      DF_WEBC_RegisterOrgAdmin_Controller ctl = new DF_WEBC_RegisterOrgAdmin_Controller();
        Test.setCurrentPageReference(pr); 
        //logged in user
        ctl.handleInvite();
     }
    }
    
        // bad invite Id
    @isTest
    private static void myUnitTest1() {

       List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
       
       String key = 'Nl8sPwQ9dAZMOVI+XQMNXQ==';
       WEBC_CommunityWrapper.RegistrationData data = new WEBC_CommunityWrapper.RegistrationData();
       data.email = 'someotherGuy@someotherGuy.com';
       data.id = partner[0].id; // has to be a valid id, but wrong
       String s = JSON.serialize(data);

       String enc = WEBC_CryptoUtils.encryptValue(s, key);
       PageReference pr = new PageReference('Page.DF_WEBC_RegisterOrgAdmin'); 
       pr.getParameters().put('invite', enc);
       Test.setCurrentPageReference(pr); 

       User guestUser = [select id from user where userType = 'Guest' and Name like 'Dementia Friends%' limit 1];
       System.runAs(guestUser) {
           test.starttest(); 
           System.debug('DF_WEBC_RegisterOrgAdmin Running Test on bad Invite Id');  
           DF_WEBC_RegisterOrgAdmin_Controller ctl = new DF_WEBC_RegisterOrgAdmin_Controller();
           ctl.handleInvite();
        }

    }
    
    static testMethod void myUnitTest2() {
           
       List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];

       PO_Administrator__c invite = new PO_Administrator__c();
       invite.Partner_Organisation__c = partner[0].id;
       invite.Invited_Email__c = 'test@testinvite.com';
       invite.Invited_Name__c = 'Test Test';
       invite.Status__c = 'Invited';
       insert invite; 
        
       String key = 'Nl8sPwQ9dAZMOVI+XQMNXQ==';
       test.starttest();
       WEBC_CommunityWrapper.RegistrationData data = new WEBC_CommunityWrapper.RegistrationData();
       data.email = 'test@testinvite.com';
       data.id = invite.id;
       String s = JSON.serialize(data);

       String enc = WEBC_CryptoUtils.encryptValue(s, key);  
       PageReference pr = new PageReference('Page.DF_WEBC_RegisterOrgAdmin'); 
       pr.getParameters().put('invite', enc);
       Test.setCurrentPageReference(pr); 

       User guestUser = [select id from user where userType = 'Guest' and Name like 'Dementia Friends%' limit 1];
       System.runAs(guestUser) {
           
           DF_WEBC_RegisterOrgAdmin_Controller ctl = new DF_WEBC_RegisterOrgAdmin_Controller();
           ctl.handleInvite();

        }

    }
    
    static testMethod void myUnitTest3() {
        
        // Instantiate a new controller with all parameters in the page        
        
         List<Community_Settings__c> cs  = [select id from Community_Settings__c where name like '%DF_'];
         DF_WEBC_RegisterOrgAdmin_Controller controller = new  DF_WEBC_RegisterOrgAdmin_Controller ();
        
        PageReference registerOrg = Page.DF_WEBC_RegisterOrgAdmin;
        registerOrg.getParameters().put('recaptcha_challenge_field','test values');
        registerOrg.getParameters().put('recaptcha_response_field','test values');
        Test.setCurrentPage(registerOrg);
        
        controller = new DF_WEBC_RegisterOrgAdmin_Controller();
        
        System.assertNotEquals(controller,null);  
        controller.orgName= 'Test Org';
        controller.sector= 'please specify';
        controller.sectorOther= 'test';
        controller.emailDomain= 'Test@Test.com' ;
        controller.employees= '8' ;
        
        controller.orgPostCode= 'TE1 3TH';
        controller.orgStreet= 'Test street';
        controller.orgcity= 'TestCity';
        controller.orgcounty= 'Test';
        controller.orgcountry= 'England';
        controller.orgTelephone=  '01111111111';
    
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
        controller.emailAddress2= 'Test@Test.com';
        controller.password = 'Test';
        controller.password2 = 'Test';
        controller.newsletter=true;
        controller.packRequest=True;
            
        System.assertEquals(null,controller.reset());

        List<SelectOption> lis = controller.titleList;
        lis = controller.genderOptionList;
        lis = controller.ethnicGroupOptionList;
        
    }    
    
     static testMethod void myUnitTest4() {
        
        // Instantiate a new controller with all parameters in the page        
       
        List<Community_Settings__c> cs  = [select id from Community_Settings__c where name like '%DF_'];      
         DF_WEBC_RegisterOrgAdmin_Controller controller = new  DF_WEBC_RegisterOrgAdmin_Controller ();
        
        PageReference registerOrg = Page.DF_WEBC_RegisterOrgAdmin;
        registerOrg.getParameters().put('recaptcha_challenge_field','test values');
        registerOrg.getParameters().put('recaptcha_response_field','test values');
        Test.setCurrentPage(registerOrg);
        
        controller = new DF_WEBC_RegisterOrgAdmin_Controller();
        
        System.assertNotEquals(controller,null);  
        controller.orgName= '';
        controller.sector= '';
        controller.sectorOther= '';
        controller.emailDomain= '' ;
        controller.employees= '' ;
        
        controller.orgPostCode= '';
        controller.orgStreet= '';
        controller.orgcity= '';
        controller.orgcounty= '';
        controller.orgcountry= '';
        controller.orgTelephone=  '';
    
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
        controller.emailAddress2= '';
        controller.password = '';
        controller.password2 = '';
        controller.newsletter= false;
        controller.packRequest=false;
            
        controller.reset();

        
    }  
    
}