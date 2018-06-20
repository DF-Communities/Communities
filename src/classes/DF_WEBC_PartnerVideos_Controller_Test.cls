/***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            22-09-2015
     * @description     DF_WEBC_PartnerVideos_Controller
***********************************************************************************************/
@isTest
public class DF_WEBC_PartnerVideos_Controller_Test {

    @testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }
 static testmethod void covermethod(){
     
     List<Partner_Organisation__c> partner = [select id,Sector__c,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 


     System.runAs(u[0]) { 
        test.starttest();
        DF_WEBC_PartnerVideos_Controller ctr = new DF_WEBC_PartnerVideos_Controller();
        system.assertEquals(true,DF_WEBC_PartnerVideos_Controller.isPartnerFound('testpo123'));
        system.assertEquals(false,DF_WEBC_PartnerVideos_Controller.isPartnerFound(''));
        ctr.code = 'testpo123';
        ctr.init();
        


     }
 
    }
    
     static testmethod void covermethod2(){
     
     List<Partner_Organisation__c> partner = [select id,Sector__c,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 


     System.runAs(u[0]) { 
        test.starttest();
        DF_WEBC_PartnerVideos_Controller ctr = new DF_WEBC_PartnerVideos_Controller();
        ctr.init();
        


     }
 
    }


}