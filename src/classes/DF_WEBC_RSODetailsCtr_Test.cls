@isTest
public without sharing class DF_WEBC_RSODetailsCtr_Test {
    
    @isTest static void test_method_one() {
    Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();        
    DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('Champion'); 
    DF_Region__c dfr =  (DF_Region__c)mapTestData.get('Region'); 
    User u = (User)mapTestData.get('User2');
    User rso = (User)mapTestData.get('adminUser');
    
    dfc.status__c = 'Converted';
    update dfc;
    system.runAs(u){
     Test.setCurrentPage(Page.WEBChampion);
     DF_WEBC_RSODetailsController controller = new DF_WEBC_RSODetailsController();
     controller.currentDfc = dfc;
        system.assertNotEquals(null,controller.currentDfc.df_region__c);
     system.assertEquals(true,controller.isChampion);
   }

}
}