/************************************************************************************************
 *Alzheimer's Society
 
     * @author          Lakshmi Vasudevan 
     * @date            24-05-2016
     * @description     Test class for DF_WEBC_PartnerOfflineSessions_Ctr
***********************************************************************************************/
@isTest
private class DF_WEBC_PartnerOfflineSessions_Ctr_Test {
	
	@testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }
    static testMethod void myUnitTest() {
     
     List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
     PageReference pageRef = Page.DF_WEBC_PartnerOfflineSessions;
     pageRef.getParameters().put('id',partner[0].Id);
     test.setCurrentPage(pageRef);
        
     system.runAs(u[0]){ 
     
     test.starttest();   
     DF_WEBC_PartnerOfflineSessions_Ctr controller = new DF_WEBC_PartnerOfflineSessions_Ctr();
     controller.partnerId = partner[0].Id;
     List<selectoption> options =controller.getHowVideoOptions();
     controller.howVideo = 'None';
     controller.save();
     controller.event.Offline_Event_Date__c =date.today(); 
     controller.howVideo = 'Other';
     controller.howVideoOther = '';
     system.assertEquals(null,controller.save());
     system.assertNotEquals(null,controller.howVideoOtherError);
     controller.howVideoOther = 'test';
     controller.event.Participant_count__c=8;
     controller.save();
     controller.cancel(); 
    }
    }
}