@isTest
private class DF_WEBC_CtrlBase_Test
{
        
    
    @isTest
    static void doTest()
    {
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        User u = (User)mapTestData.get('User');
        Partner_Organisation__c partner = ( Partner_Organisation__c)mapTestData.get('partnerOrg');
        
        System.runAs(u) {
        test.starttest();
        DF_WEBC_HomePage ctl = new DF_WEBC_HomePage();
        User u2 = ctl.currentUser;
        boolean b = ctl.isLoggedIn;
        b = ctl.isOrgAdmin;
        double offset = ctl.currentUserOffset;
        Contact c = ctl.currentContact;
        String partnerid= ctl.partnerId;

        DF_Contact__c dfc = ctl.currentDfc;
        DF_Contact_Wrapper dfcW = ctl.dfcW;
        String s = ctl.totalFriendCount;
        List<String> lis = ctl.totalFriendCountList;

       }

    }

    @isTest
    static void doTest2() {

        DF_WEBC_HomePage ctl = new DF_WEBC_HomePage();
        PageReference pr = ctl.loginRedirect();
    }
    
  


}