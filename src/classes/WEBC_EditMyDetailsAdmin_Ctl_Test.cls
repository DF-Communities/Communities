@isTest
private class WEBC_EditMyDetailsAdmin_Ctl_Test
{
    @isTest
    static void doTest()
    {

        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u = (User)mapTestData.get('adminUser');
        test.starttest();
        System.runAs(u) {
            
            WEBC_EditMyDetailsAdmin_Controller ctl = new WEBC_EditMyDetailsAdmin_Controller();
            List<SelectOption> titleList  = ctl.titleList;
            PageReference pr = ctl.saveUserDetails();

        }

    }
}