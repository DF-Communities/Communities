/************************************************************************************************
*Alzheimer's Society

     * @author          Lakshmi Vasudevan 
     * @date            24-05-2016
     * @description     Test class for DF_WEBC_PartnerActions
***********************************************************************************************/
@isTest
private class DF_WEBC_PartnerActions_Ctr_Test {
    
    @testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }

    static testMethod void myUnitTest() {
     
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
         
     PageReference pageRef = Page.DF_WEBC_PartnerActions;
     pageRef.getParameters().put('id',partner[0].Id);
     test.setCurrentPage(pageRef);
        
    system.runAs(u[0]){
     
     test.starttest(); 
     DF_WEBC_PartnerActions_Controller controller = new DF_WEBC_PartnerActions_Controller();
     controller.partnerId = partner[0].Id;
     System.assertNotEquals(controller, null);
     controller.action5 = '***';
     System.assertNotEquals(null, controller.cancel());
     System.assertNotEquals(null, controller.save());
     
     
     }
             
    }
    
    static testMethod void myUnitTest2() {
       List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
       List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
     
        System.runAs(u[0]) {
           test.starttest();
            DF_WEBC_PartnerActions_Controller controller = new DF_WEBC_PartnerActions_Controller();
            System.assertNotEquals(null,controller);
            controller.partnerId = partner[0].Id;
             System.assertNotEquals(controller, null);

            controller.action5 = '***';
            controller.Actionname = new List<String>{'Join your local Dementia Action Alliance','Sign up to a Local Dementia Action Alliance'};
            List<selectoption> options =controller.getActionNames();
             
            System.assertNotEquals(null, controller.cancel());
            System.assertNotEquals(null, controller.save());
            
        }
    }
    
    static testMethod void myUnittest3(){
        delete [SELECT  DF_Contact__c FROM PO_Administrator__c];
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     DF_Contact__c dfc = [SELECT Id, Name, First_Name__c, Last_Name__c, Title__c, Contact_Number__c,
		                            Email__c, Postcode__c, Street__c, City__c, County__c, Country__c, Newsletters__c,
		                            Portal_Contact__c, Portal_User__c, RecordTypeId
		                       FROM DF_Contact__c  limit 1 ];
		                       
     List<User> u  = [select id,name from User where email = :dfc.Email__c  limit 1]; 
        PageReference pageRef = Page.DF_WEBC_PartnerActions;
        pageRef.getParameters().put('id',partner[0].Id);
        test.setCurrentPage(pageRef);
         System.runAs(u[0]) {
           test.starttest();
            DF_WEBC_PartnerActions_Controller controller = new DF_WEBC_PartnerActions_Controller();
            controller.partnerId = partner[0].Id;
             
            system.assertNotEquals(null,controller.orgAdminLoginRedirect());
           
         }
    }
}
