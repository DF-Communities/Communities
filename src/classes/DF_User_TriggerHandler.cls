/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Trigger Handler for Creating a new user registration
 *  Author  : Gary Grant
 *  Date    : Jan 2016
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         	Description
 *	18/08/2018		Andy Rouse		Added new generic methods for adding/removing permission sets and group memberships:
 										AddPermissionSets(set<Id> userIds, Id permissionSetId, Id groupId)
 										removePermissionSets(set<Id> userIds, Id permissionSetId)
 									Made change to the following methods to allow calling a new batch class:
 										enableChampionExchangeAccess(Set<Id> updatedUserIds)
										enableExchangeModeratorAccess(Set<Id> updatedUserIds)
										disableChampionExchangeAccess(Set<Id> updatedUserIds)
										disableExchangeModeratorAccess(Set<Id> updatedUserIds)
										
*******************************************************************************************/ 

public class DF_User_TriggerHandler {
    
    public static string groupName;
    public static string groupId;
    public static string communityName;
    public static string communityId;

    public void OnAfterInsert(User[] itemsNew, Map<ID, User> itemsNewMap){

        List<DF_Contact__c> lisToUpdate = new List<DF_Contact__c>();


        Map<String, User> mapUsers = new Map<String, User>();
        for (User user : itemsNew) {
          
            /* It's important to compare UserName with email address.
               DF Contact assumes UserName and Email address are the same
            */                     
            mapUsers.put(user.UserName, user);            
        
        } 
        
        List<DF_Contact__c> lisDfc = [select id, email__c, 
                                                 Portal_User__c, 
                                                 OwnerId from DF_Contact__c where email__c in:mapUsers.keySet()];
        
        for (DF_Contact__c dfc : lisDfc) {
        
            User u = (User)mapUsers.get(dfc.Email__c);
            
            if ( u!=null ) {
            
                dfc.Portal_User__c = u.id;
                dfc.OwnerId = u.id;
                lisToUpdate.add(dfc);
            }
        
        
        }
        
        if (lisToUpdate.size() >0 ) { update lisToUpdate; }

    } 

   

    @future
    public static void enableChampionExchangeAccess(Set<Id> updatedUserIds)
    {
        //Get permission set for the Champions Exchange
        string permName =  Community_Settings__c.getInstance('Exchange_Permission_Set').value__c; 
        string permSetId = DF_Utils.getPermissionSetId(permName);
        
        //if(permSetId ==null || permSetId==''){ return; }
        
        //Get the Chatter group to add people to
        groupName = Community_Settings__c.getInstance('Exchange_Public_Group').value__c;
        communityName = Community_Settings__c.getInstance('Exchange_Site').value__c;
        //communityId = DF_Utils.getCommunityId(communityName);
		groupId = DF_Utils.getCommunityGroupId(communityName, groupName);//DF_Utils.getGroupId(groupName,communityId);
        
        //Decide whether this needs to be batch or immediate
        if(updatedUserIds.size() <= ExchangeCommunityGroupAccess_Batchable.batch_size){
        	AddPermissionSets(updatedUserIds, permSetId, groupId);
        } else {
        	database.executeBatch(new ExchangeCommunityGroupAccess_Batchable(updatedUserIds, permSetId, 'ADD', groupId));
        }
        
        
        /*
        list<PermissionSetAssignment> passign = new List<PermissionSetAssignment>();
        
		//Create list of permission sets to add new users to Champions Exchange
		for(User u:[select id from user where Id IN :updatedUserIds]){
                
			PermissionSetAssignment pa = new PermissionSetAssignment();
                
			pa.AssigneeId =u.Id;
			pa.PermissionSetId= permSetId;
			passign.add(pa);

		}
       
            
        if(passign.size()>0){

			insert passign;
			
			//create queued jobs to add users to Chatter group
			
			//Get the Chatter group to add people to
        	groupName = Community_Settings__c.getInstance('Exchange_Public_Group').value__c;
        	communityName = Community_Settings__c.getInstance('Exchange_Site').value__c;
        	communityId = DF_Utils.getCommunityId(communityName);
        	groupId = DF_Utils.getGroupId(groupName,communityId);
			
			ExchangeCommunityGroupAccess groupAccess = new ExchangeCommunityGroupAccess(updatedUserIds,groupId);
			ID jobID = System.enqueueJob(groupAccess);
		
		}*/
       
        
    }
    
    @future
    public static void enableExchangeModeratorAccess(Set<Id> updatedUserIds){
        
        //Get permission set for the Champions Exchange Moderator access
        string permName= Community_Settings__c.getInstance('Exchange_Feed_Moderator_Perm').value__c;
        string permSetId = DF_Utils.getPermissionSetId(permName);
        
        //Decide whether this needs to be batch or immediate
        if(updatedUserIds.size() <= ExchangeCommunityGroupAccess_Batchable.batch_size){
        	AddPermissionSets(updatedUserIds, permSetId, null);
        } else {
        	database.executeBatch(new ExchangeCommunityGroupAccess_Batchable(updatedUserIds, permSetId, 'ADD', null));
        }
        
        /*List<PermissionSetAssignment> passign = new List<PermissionSetAssignment>();
        
        if(permSetId!=null && permSetId!=''){
            
            for(User u:[select id from user where Id in:updatedUserIds]){
                
                PermissionSetAssignment pa = new PermissionSetAssignment();
                pa.AssigneeId =u.Id;
                pa.PermissionSetId= permSetId;
                passign.add(pa);

            }
        }
            
        if(passign.size()>0){
			
			insert passign;
			
			//There is no specific group for moderators
			//ExchangeCommunityGroupAccess groupAccess = new ExchangeCommunityGroupAccess(updatedUserIds,groupId);

        }*/
    }
    
   	//This method adds Users to a permission Set and also to a Chatter group (if the groupId is supplied)
    public static void AddPermissionSets(set<Id> userIds, Id permissionSetId, Id groupId){
		
		if(userIds == null || userIds.size() == 0 || permissionSetId == null){ return; }
		
		list<PermissionSetAssignment> passign = new list<PermissionSetAssignment>();
		
		for(Id uId : userIds){
                
			PermissionSetAssignment pa = new PermissionSetAssignment(
																	 AssigneeId = uId,
																	 PermissionSetId = PermissionSetId
			);
                
			passign.add(pa);
			userIds.add(uid);

		}
       
        if(passign.size()>0){

			list<database.saveResult> insertResults = database.insert(passign, false);
			
			//create queued jobs to add users to Chatter group
			if(groupId != null){ System.enqueueJob( new ExchangeCommunityGroupAccess(userIds,groupId)); } 
			
		}
		
	}

    

    
    @future
    public static void disableChampionExchangeAccess(Set<Id> updatedUserIds){

        string permName = Community_Settings__c.getInstance('Exchange_Permission_Set').value__c; 
        string permSetId = DF_Utils.getPermissionSetId(permName);
        
        removePermissionSets(updatedUserIds, permSetId);
        /*List<PermissionSetAssignment> permToDelete = new List<PermissionSetAssignment>();
        Set<Id> userIds = new Set<Id>();
            
		if(permSetId!=null && permSetId!=''){

			for(User u:[select id from user where Id in:updatedUserIds]){

				userIds.add(u.Id);

			}

			if(userIds.size()>0){

				for(PermissionSetAssignment pa : [select id from PermissionSetAssignment where AssigneeId in:userIds and PermissionSetId=:permSetId]){
					permToDelete.add(pa);
				}
            }
            
            if(permToDelete.size()>0){
				try{
					delete permToDelete;
				}catch(Exception e){

				}
			}
		}*/
	}
	
	//this method removes access to a permission set, as long as the users and permission set are supplied
	public static void removePermissionSets(set<Id> userIds, Id permissionSetId){
		
		if(userIds == null || userIds.size() == 0 || permissionSetId == null){ return; }
		
		//try{
			list<database.deleteResult> results = database.delete([select id from PermissionSetAssignment where AssigneeId IN :userIds and PermissionSetId = :permissionSetId], false);
		//} catch(Exception e) {

		//}
	}

    
    

    @future
	public static void disableExchangeModeratorAccess(Set<Id> updatedUserIds){

		string permName = Community_Settings__c.getInstance('Exchange_Feed_Moderator_Perm').value__c; 
		string permSetId = DF_Utils.getPermissionSetId(permName);
		
		removePermissionSets(updatedUserIds, permSetId);
		/*Set<Id> userIds = new Set<Id>();
		list<PermissionSetAssignment> permToDelete = new List<PermissionSetAssignment>();
        
		if(permSetId!=null && permSetId!=null){

			for(User u:[select id from user where Id in:updatedUserIds]){
				userIds.add(u.Id);
			}
            
            if(userIds.size()>0){

				for(PermissionSetAssignment pa : [select id from PermissionSetAssignment where AssigneeId in:userIds and PermissionSetId =:permSetId]){
					permToDelete.add(pa);
				}
			}
            
			if(permToDelete.size()>0){
				try{
					delete permToDelete;
				}catch(Exception e){

				}
			}
		}*/
	}
}