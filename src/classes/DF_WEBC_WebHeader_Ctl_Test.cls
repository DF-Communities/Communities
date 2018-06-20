@isTest
private class DF_WEBC_WebHeader_Ctl_Test
{
    @isTest
    static void doTest()
    {

        DF_WEBC_WebHeader_Controller ctl = new DF_WEBC_WebHeader_Controller();
        boolean b = ctl.isSubscriber;

        // Methods from the base controller 

        b = ctl.isLoggedin;
        b = ctl.isOrgAdmin;
        User u = ctl.currentUser;
        PageReference p = ctl.loginRedirect(); 

    }

    @isTest
    static void doTest2()
    {


        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u  = (User)mapTestData.get('User');
         test.starttest();
        System.runAs(u) {
        
            DF_WEBC_WebHeader_Controller ctl = new DF_WEBC_WebHeader_Controller();
            ctl.toggleSubscription();
        }

    }
}