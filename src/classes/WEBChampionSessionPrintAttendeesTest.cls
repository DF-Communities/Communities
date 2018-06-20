@isTest(seeAllData=false)
public with sharing class WEBChampionSessionPrintAttendeesTest {
    static testMethod void printAttendeesTest() {
        WEBChampionSessionPrintAttendees controller ;
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData(); 
        DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession');
        De.Event_Status__c = 'Available';

        Test.startTest();
       update  De;
        ApexPages.currentPage().getParameters().put('eventId', De.Id);
        
        controller = new WEBChampionSessionPrintAttendees();

        System.assertNotEquals(null, controller.isChampion);
        System.assertNotEquals(null, controller.attendees);
        System.assertNotEquals(null, controller.noOfAttendees);
        
        Test.stoptest();
    }
}