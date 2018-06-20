@isTest
public  class DF_Contact_Inbound_ChangeTHandler_Test {
	/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            11-03-2016
     * @description     Test class for DF_Contact_Inbound_ChangeTriggerHandler
***********************************************************************************************/
	static testMethod void CoverMethod () {
		
		 Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
		 DF_Contact__c dc = (DF_Contact__c )mapTestData.get('Champion');
		 DF_Contact_Inbound_Change__c dcc = new DF_Contact_Inbound_Change__c(
		 Related_DF_Contact__c =  dc.Id,
		 First_Name__c = 'TFname',
		 Last_Name__c = 'TLname'		 
		 );
		 test.starttest();
		 
		 insert dcc;
	}
    
}