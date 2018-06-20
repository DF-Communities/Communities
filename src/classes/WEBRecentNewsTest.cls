@isTest(seeAllData=false)
public with sharing class WEBRecentNewsTest {
	static testMethod void recentNewsTest() {
		Action__c action = new Action__c();
		action.Homepage__c = TRUE;
		action.Public__c = TRUE;
		action.Action__c = '*** TEST ACTION ***';

        insert action;

        WEBRecentActions controller;

        Test.startTest();
        controller = new WEBRecentActions();

        system.assertEquals(1, controller.actions.size());
        Test.stoptest();
	}
}