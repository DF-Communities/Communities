@isTest
private class DF_WEBC_EditDetails_Redirect_Ctl_Test
{	
    @testsetup
    static void init() {
       DF_DataFactory_Test.getTestData();
    }
    
    @isTest
    static void doTest()
    {
		
		DF_Contact__c dfc = [SELECT Id, Name, First_Name__c, Last_Name__c, Title__c, Contact_Number__c,
		                            Email__c, Postcode__c, Street__c, City__c, County__c, Country__c, Newsletters__c,
		                            Portal_Contact__c, Portal_User__c, RecordTypeId
		                       FROM DF_Contact__c  limit 1 ];
		                       
		User adminUser = [SELECT Id FROM User WHERE Email = :dfc.Email__c limit 1];
        
        DF_WEBC_EditDetails_Redirect_Controller ctl;
        
        System.runAs(adminUser) {
            ctl = new DF_WEBC_EditDetails_Redirect_Controller();
            PageReference pr = ctl.doAction();
            pr = ctl.handleGuest();
            pr = ctl.handleOrgAdmin();
        }
    
            //Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
           // DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
            test.starttest();
            ctl.handleDfc(dfc);
    
            dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_Champion);
            
            update dfc;
    
            ctl.handleDfc(dfc);
            test.stoptest();
        

    }
}
