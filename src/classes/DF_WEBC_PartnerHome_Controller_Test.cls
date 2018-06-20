/************************************************************************************************
     * @author          Lakshmi Vasudevan 
     * @date            24-05-2016
     * @description     Test class for DF_WEBC_PartnerHome_Controller
***********************************************************************************************/
@isTest
private class DF_WEBC_PartnerHome_Controller_Test {
    
    @testsetup  static void mytestdata(){
        DFP_DataFactory_Test.TestDataCreation();
   
    }
    static testMethod void myUnitTest() {
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
     
     PageReference pageRef = Page.DF_WEBC_PartnerHome;
     pageRef.getParameters().put('id',partner[0].Id);
     test.setCurrentPage(pageRef);  
     System.runAs(u[0]) {
           
       test.starttest();
       DF_WEBC_PartnerHome_Controller ctl = new DF_WEBC_PartnerHome_Controller();
       ctl.SelectedPartner=partner[0];
       ctl.actionRecordSaved = true;
       Page_Snippet__c ps = ctl.totalFriendsSnippet;
       system.assertEquals(false,ctl.showSaveConfirmation);
        
        }
        
    }

}