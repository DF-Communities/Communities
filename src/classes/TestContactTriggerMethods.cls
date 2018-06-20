/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestContactTriggerMethods {
	public static final String RT_DF_FRIEND = 'Dementia_Friend';
	public static final String RT_DF_CHAMPION = 'Dementia_Friend_Champion';
	public static final String RT_NEWSLETTER = 'E_Newsletter_Subscriber';


    static testMethod void testContactInsert() {
    	Map<String, RecordType> rtMap = new Map<String, RecordType>();
    	List<Contact> newContacts = new List<Contact>();
		for (RecordType rt : [select r.Id, r.Name, r.DeveloperName from RecordType r where r.SObjectType = 'Contact']){
			rtMap.put(rt.DeveloperName, rt);
		}
    	Contact friendContact = new Contact(RecordTypeId = rtMap.get(RT_DF_FRIEND).Id);
    	friendContact.FirstName = 'Friend';
    	friendContact.LastName = 'Contact';
    	friendContact.Email = 'friend.contact@myemail.com';
    	newContacts.add(friendContact);
    	
    	Contact championContact = new Contact(RecordTypeId = rtMap.get(RT_DF_CHAMPION).Id);
    	championContact.FirstName = 'Champion';
    	championContact.LastName = 'Contact';
    	championContact.Email = 'champion.contact@myemail.com';
    	newContacts.add(championContact);
    	
    	Contact newsletterContact = new Contact(RecordTypeId = rtMap.get(RT_NEWSLETTER).Id);
    	newsletterContact.FirstName = 'News';
    	newsletterContact.LastName = 'Contact';
    	newsletterContact.Email = 'new.contact@myemail.com';
    	newContacts.add(newsletterContact);
    	
    	test.startTest();
    	
    	insert newContacts;
    	
    	List<DF_Contact__c> dfContacts = [select d.Id from DF_Contact__c d];
    	//system.assertEquals(3, dfContacts.size());
    	
    	test.stopTest();
    	    
    }
    
    /*
    static testMethod void testContactUpdate() {
    	Map<String, RecordType> rtMap = new Map<String, RecordType>();
    	List<Contact> newContacts = new List<Contact>();
		for (RecordType rt : [select r.Id, r.Name, r.DeveloperName from RecordType r where r.SObjectType = 'Contact']){
			rtMap.put(rt.DeveloperName, rt);
		}
    	Contact friendContact = new Contact(RecordTypeId = rtMap.get(RT_DF_FRIEND).Id);
    	friendContact.FirstName = 'Friend';
    	friendContact.LastName = 'Contact';
    	friendContact.Email = 'friend.contact@myemail.com';
    	newContacts.add(friendContact);
    	
    	Contact championContact = new Contact(RecordTypeId = rtMap.get(RT_DF_CHAMPION).Id);
    	championContact.FirstName = 'Champion';
    	championContact.LastName = 'Contact';
    	championContact.Email = 'champion.contact@myemail.com';
    	newContacts.add(championContact);
    	
    	Contact newsletterContact = new Contact(RecordTypeId = rtMap.get(RT_NEWSLETTER).Id);
    	newsletterContact.FirstName = 'News';
    	newsletterContact.LastName = 'Contact';
    	newsletterContact.Email = 'new.contact@myemail.com';
    	newContacts.add(newsletterContact);
    	
    	insert newContacts;
    	    	
    	test.startTest();
    	
    	List<Contact> testContacts = [select c.LastName from Contact c];
    	for (Contact c : testContacts){
    		c.LastName = 'ContactNew';
    	}
    	
    	update testContacts;
    	
    	List<DF_Contact__c> dfContacts = [select d.Id, d.Last_Name__c from DF_Contact__c d];
    	for (DF_Contact__c dfc : dfContacts){
    		system.assertEquals('ContactNew',dfc.Last_Name__c);
    	}
    	
    	test.stopTest();
    	    
    }
    */
}