@isTest
private class Dfc_ListCommunities_Test
{
    @testSetup
    static void setupData() {

            Dfc_DataFactory_Test.TestDataCreation();
    }

    @isTest
    static void itShould()
    {

        DFC_ListCommunities ctl = new DFC_ListCommunities();
        
        ctl.Country='England';
        ctl.County = 'Hertfordshire';
        ctl.Region = 'East of England';

        List<SelectOption> options = ctl.regions;
        options = ctl.daas;

        String json = DFC_ListCommunities.getCommunityList();

        List<DFC_Community__c> lis = ctl.communities;

    }
}