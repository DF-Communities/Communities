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
private class ExchangeCommunityGroupAccess_Batch_Test {

    @testSetup
    static void setupData(){
    	
    	string commGroupName = 'Example Community Group';
    	
    	CollaborationGroup commGroup = new CollaborationGroup(Name = commGroupName, CollaborationType='Private');
    	insert commGroup;
    	
    	Community_Settings__c groupName = new Community_Settings__c(Name = 'Exchange_Public_Group', Value__c=commGroupName);
    	Community_Settings__c permissionSet = new Community_Settings__c(Name = 'Exchange_Permission_Set', Value__c ='Exchange_User');
    	Community_Settings__c community = new Community_Settings__c(Name = 'Exchange_Site', Value__c ='Champions Exchange');
    	
    	insert new list<Community_Settings__c>{groupName, permissionSet, community};
    	
    }
    
    static testMethod void testAddPemissionSets() {
        
        string groupName = Community_Settings__c.getInstance('Exchange_Public_Group').value__c;
        string communityName = Community_Settings__c.getInstance('Exchange_Site').value__c;
        Id groupId = DF_Utils.getCommunityGroupId(communityName, groupName);
        
        string permName =  Community_Settings__c.getInstance('Exchange_Permission_Set').value__c; 
        Id permSetId = DF_Utils.getPermissionSetId(permName);
        
        set<Id> userIds = new set<Id>();
        
        for(User u :[select id, Name from User where IsActive = true 
        						and Id NOT IN (select memberId from CollaborationGroupMember where CollaborationGroupId = :groupId)
        						and Id NOT IN (select AssigneeId from PermissionSetAssignment where PermissionSetId = :permSetId)
        						limit :ExchangeCommunityGroupAccess_Batchable.batch_size]){
        	
        	userIds.add(u.id);
        							
        }
        

		test.startTest();
		
		ID batchprocessid = Database.executeBatch(new ExchangeCommunityGroupAccess_Batchable(userIds, permSetId, 'ADD', groupId));
				
		test.stopTest();

    }
    
    static testMethod void testRemovePemissionSets() {
        
        string permName =  Community_Settings__c.getInstance('Exchange_Permission_Set').value__c; 
        Id permSetId = DF_Utils.getPermissionSetId(permName);
        
        set<Id> userIds = new set<Id>();
        
        for(User u :[select id, Name from User where IsActive = true 
        						and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSetId = :permSetId)
        						limit :ExchangeCommunityGroupAccess_Batchable.batch_size]){
        	
			userIds.add(u.id);
        							
        }
        
		test.startTest();
		
		ID batchprocessid = Database.executeBatch(new ExchangeCommunityGroupAccess_Batchable(userIds, permSetId, 'REMOVE', null));
				
		test.stopTest();

    }
}