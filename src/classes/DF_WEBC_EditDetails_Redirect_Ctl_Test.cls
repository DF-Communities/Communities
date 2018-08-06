@isTest
private class DF_WEBC_EditDetails_Redirect_Ctl_Test
{
    @isTest
    static void doTest()
    {

        DF_WEBC_EditDetails_Redirect_Controller ctl = new DF_WEBC_EditDetails_Redirect_Controller();
        PageReference pr = ctl.doAction();
        pr = ctl.handleGuest();
        pr = ctl.handleOrgAdmin();


        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        test.starttest();
        ctl.handleDfc(dfc);

        dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_Champion);
        
        update dfc;

        ctl.handleDfc(dfc);
        test.stoptest();

    }
}