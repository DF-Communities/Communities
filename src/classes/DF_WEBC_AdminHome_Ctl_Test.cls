@isTest
private class DF_WEBC_AdminHome_Ctl_Test
{
    @isTest
    static void doTest()
    {

        
       
        
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u = (User)mapTestData.get('adminUser');
        test.starttest();
        DF_WEBC_AdminHome_Controller ctl = new DF_WEBC_AdminHome_Controller();
        Page_Snippet__c ps = ctl.totalFriendsSnippet;
        ctl.clicked();
       
        System.runAs(u) {
        
            ctl = new DF_WEBC_AdminHome_Controller();
            ctl.friendCount = 25;
            Decimal d = ctl.friendCount;
        
        }
        
    }
}