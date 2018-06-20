@IsTest 
private class DF_WEBC_CreateActions_Test {
    static testMethod void createActionTest() {

        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u  = (User)mapTestData.get('User');

        System.runAs(u) {
            test.starttest();
            DF_WEBC_CreateActions controller = new DF_WEBC_CreateActions ();
            System.assertNotEquals(controller, null);

            controller.publicCheckbox = TRUE;
            controller.action5 = '***';

            System.assertNotEquals(null, controller.cancel());
            System.assertNotEquals(null, controller.saveActions());

        }
    }
    
     static testMethod void createActionTestWithAction() {

        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u  = (User)mapTestData.get('User');
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        
        System.runAs(u) {

           
           PageReference pr = Page.DF_WEBC_CreateActions;
            test.setCurrentPage(pr);
            test.starttest();
            DF_WEBC_CreateActions controller = new DF_WEBC_CreateActions ();

            System.assertNotEquals(controller, null);

            controller.publicCheckbox = TRUE;
            controller.action5 = '***';
            controller.Actionname = new List<String>{'Get in touch with someone with dementia','Campaign for change'};
            List<selectoption> options =controller.getActionNames();
             
            System.assertNotEquals(null, controller.cancel());
            System.assertNotEquals(null, controller.saveActions());

        }
    }
}