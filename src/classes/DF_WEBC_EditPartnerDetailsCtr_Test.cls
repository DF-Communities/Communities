/************************************************************************************************
     * @author          Lakshmi Vasudevan 
     * @date            06-10-2016
     * @description     Test class for DF_WEBC_EditPartnerController
***********************************************************************************************/
@isTest
public with sharing class DF_WEBC_EditPartnerDetailsCtr_Test {

	@testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();   
    }
	 static testMethod void EditOrgTest() {
	 
     List<Partner_Organisation__c> partner = [select id,name,Account__c,Number_of_Employees__c,Sector__c,Sector_other__c from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
     List<Account> partnerAcc = [select id,name,BillingPostalCode,BillingCity,BillingStreet,BillingState,BillingCountry,Phone from Account where Id=:partner[0].Account__c limit 1 ];
     List<User> u  = [select id,name from User where email = 'test.testcontact@myemail.com' limit 1]; 
     PageReference pageRef = Page.DF_WEBC_EditPartnerDetails;
     pageRef.getParameters().put('id',partner[0].Id);
     test.setCurrentPage(pageRef);
        
     system.runAs(u[0]){
     
		     test.starttest();  
		     DF_WEBC_EditPartnerDetailsController controller = new DF_WEBC_EditPartnerDetailsController();
		      controller.partnerId =partner[0].Id;
		      controller.street =partnerAcc[0].billingStreet;
		      controller.phone=partnerAcc[0].phone;
		      controller.county=partnerAcc[0].billingstate;
		      controller.city=partnerAcc[0].billingcity;
		      controller.country=partnerAcc[0].billingcountry;
		      controller.postCode=partnerAcc[0].billingpostalCode;
		      controller.employees=partner[0].number_of_employees__c;
		      controller.sector=partner[0].sector__c;
		      controller.sectorOther=partner[0].sector_other__c;
		      List<SelectOption> sectorList=controller.sectorList ;
		      List<SelectOption> empnoList =controller.empnoList;
		      
		      System.assertNotEquals(null,controller.saveDetails());
		      System.assertNotEquals(null,controller.cancel());	
			}
    }

}