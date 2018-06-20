/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the DF_Contact__c Trigger.
 *  Author  : Andy Rouse
 *  Date    : 18/01/2018
 *  Version : 0.1 Unit Test
 *
 *  Description:    Batchable class intended to handle mass updates of DF contact records that
 *					result in changes of access to the Dementia Friends Champions Exchange.
 *                  
 *               
 *  Modification History
 *  Date            Who         Description 
 *
 *										               
*******************************************************************************************/
public with sharing class ExchangeCommunityGroupAccess_Batchable implements Database.Batchable<sObject>{
    
    public static final integer batch_size = 200;
    
    private string testLimit = test.isRunningTest() ? ' LIMIT '+batch_size : '';
    
    private set<Id> userIds;
    private Id PermissionSetId;
    private string addOrRemove;
    private Id groupId;
    
    public ExchangeCommunityGroupAccess_Batchable(set<Id> userIds, Id PermissionSetId, string addOrRemove, Id groupId){
    	this.userIds = userIds;
    	this.PermissionSetId = PermissionSetId;
    	this.addOrRemove = addOrRemove;
    	this.groupId = groupId;
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator('select id from User where isActive = true and id IN :userIds'+testLimit);
    }
    
    public void execute(Database.BatchableContext BC, List<User> scope) {
    	
		set<Id> userIds = new set<Id>();
			
		for(User u : scope){
			userIds.add(u.id);
		}
		
		if(addOrRemove == 'ADD'){
		
			DF_User_TriggerHandler.AddPermissionSets(userIds, PermissionSetId, groupId);
		
		} else if (addOrRemove == 'REMOVE') {
		
			DF_User_TriggerHandler.removePermissionSets(userIds, PermissionSetId);
		
		}
		
	}
    
    public void finish(Database.BatchableContext BC) {
    	
    }
    
    
}