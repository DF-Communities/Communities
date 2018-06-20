/************************************************************************************************
*Alzheimer's Society

     * @author          Lakshmi Vasudevan 
     * @date            24-05-2016
     * @description     Test class for DF_WEBC_ManagePartnerAdmins_Ctr
***********************************************************************************************/
@isTest
private class DF_WEBC_ManagePartnerAdmins_Ctl_Test {
    
    @testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }
    
    
    static testMethod void myUnitTest() {
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
     String email='test@test.com';
    
     test.starttest();
      DF_WEBC_ManagePartnerAdmins_Ctr.holder holder= new DF_WEBC_ManagePartnerAdmins_Ctr.holder();
      holder=DF_WEBC_ManagePartnerAdmins_Ctr.handleinvites(email,partner[0].Id);
      email='test@testcom';
      holder=DF_WEBC_ManagePartnerAdmins_Ctr.handleinvites(email,partner[0].Id);
      system.assertNotEquals(null,holder.emailError);  
      email=''; 
      holder=DF_WEBC_ManagePartnerAdmins_Ctr.handleinvites(email,partner[0].Id);
      system.assertNotEquals(null,holder.emailError); 
      email='test@test.com';
      holder=DF_WEBC_ManagePartnerAdmins_Ctr.handleinvites(email,partner[0].Id);
      system.assertNotEquals(null,holder.emailError);
      
    }
   
   
     static testMethod void myUnitTest2() {
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
     List<PO_Administrator__c> po = [select id,invited_email__c,invited_name__c from PO_Administrator__c limit 2];
   
     PageReference pageRef = Page.DF_WEBC_ManagePartnerAdmins;
     pageRef.getParameters().put('id',partner[0].Id);
     test.setCurrentPage(pageRef);
        
      system.runAs(u[0]){
     
     test.starttest(); 
     DF_WEBC_ManagePartnerAdmins_Ctr controller = new DF_WEBC_ManagePartnerAdmins_Ctr();
     
    List<DF_WEBC_ManagePartnerAdmins_Ctr.AdminWrapper> aw = controller.getAdminList();
    system.assertEquals(2, aw.size());
      controller.email= 'test.testcontact7@myemail.com' ;
      controller.Name= 'test test' ;
      DF_WEBC_ManagePartnerAdmins_Ctr.partnerId=partner[0].Id;
     system.assertNotEquals(null,controller.addAdmin());
     system.assertNotEquals(null,controller.invite());
     system.assertNotEquals(null,controller.cancel());
     controller.saveAdmin();
      } 
    }
}