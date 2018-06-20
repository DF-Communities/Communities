@isTest
private class Dfc_CommunityPublicListing_Test
{

    @testSetup
    static void setupData() {

            Dfc_DataFactory_Test.TestDataCreation();
    }

    @isTest
    static void itShould()
    {

        Dfc_CommunityPublicListing ctl = new Dfc_CommunityPublicListing();
        List<SelectOption> lis = ctl.regions;

        ctl.region = 'East of England';
        lis = ctl.daas;

        List<DFC_Community__c> lisComms = ctl.communities;

        DFC_Alliance__c alliance = [select id, name from DFC_Alliance__c where Name = 'DFC Test Alliance'];        
        ctl.daa = alliance.id;        
        lisComms = ctl.communities;


    }
}