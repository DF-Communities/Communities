/************************************************************************************************
*Alzheimer's Society

     * @author          Lakshmi Vasudevan 
     * @date            23-05-2016
     * @description     Test class for DF_WEBC_PartnerResources_Ctr
***********************************************************************************************/
@isTest
private class DF_WEBC_PartnerResources_Ctr_Test {
	
	@testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();
   
    }

    static testMethod void myUnitTest() {
      
     List<Partner_Organisation__c> partner = [select id,Sector__c,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
     
     Partner_Organisation_Resources__c oRes = new Partner_Organisation_Resources__c (Category__c='test Sector',Name__c='test',date_added__c=date.today());
     insert oRes;
       
     
      
     Blob b = Blob.valueOf('Test Data');  
      
     Attachment attachment = new Attachment();  
     attachment.ParentId = oRes.id;  
     attachment.Name = 'Test Attachment for Parent';  
     attachment.Body = b;  
      
     insert(attachment); 
     PageReference pageRef = Page.DF_WEBC_PartnerResources;
     pageRef.getParameters().put('id',partner[0].Id);
     test.setCurrentPage(pageRef);
        
     system.runAs(u[0]){ 
     
     test.starttest(); 
      
       DF_WEBC_PartnerResources_Ctr partnerRes = new DF_WEBC_PartnerResources_Ctr(); 
       partnerRes.partnerId = partner[0].Id;
       partnerRes.Sector =partner[0].Sector__c;
      // system.assertnotequals(null,webResource.sessionResources);
       //system.assertnotequals(null,webResource.att);
       //system.assertnotequals(null,webResource.sessionCategories);
      // WEBChampionSessionResources.sessionResourceCategory inCl = new WEBChampionSessionResources.sessionResourceCategory();
       
     }    
        
    }
}