@isTest
private class DF_WEBC_FriendVideo_Ctl_Test
{
    @isTest
    static void doTest()
    {
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u  = (User)mapTestData.get('User');

        System.runAs(u) {
            
            test.starttest();
            DF_WEBC_FriendVideo_Controller ctl = new DF_WEBC_FriendVideo_Controller();
            ctl.doSetVideoWatched();
            boolean b = ctl.watchedVideo;
        }

    }
}