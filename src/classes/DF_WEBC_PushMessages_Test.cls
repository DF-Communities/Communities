@isTest
private class DF_WEBC_PushMessages_Test {
    
    @isTest static void test_method_one() {
    Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();        
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('Champion');  
        dfc.Status__c =DF_Utils.STATUS_CONVERTED;
        update dfc;
        Push_Notifications__c pn = new Push_Notifications__c();
        pn.Message__c='tesrt';
        pn.title__c='test title';
        pn.DF_Contact__c = dfc.Id;
        pn.Status__c ='Unread';
        insert pn;
     User u = (User)mapTestData.get('User2');

    

        PageReference pr = Page.DF_WEBC_PushMessages;
            test.setCurrentPage(pr);
            test.starttest();
         DF_WEBC_PushMessages.deleteMessage(pn.id);
         DF_WEBC_PushMessages controller = new DF_WEBC_PushMessages();
         controller.currentdfc=dfc;
         List<Push_Notifications__c> lispn=controller.champMessages;
       system.assertNotEquals(null, lispn);
     
    }
    
    @isTest static void test_method_two() {
        // Implement test code
    }
    
}