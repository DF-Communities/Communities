public with sharing class Dfc_CommunityStoreController 
{
    
    @AuraEnabled
    public static Object getCommunity(String Id) 
    {
      try{
        return Dfc_Util.readCommunity(Id);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }


/*
    @AuraEnabled
    public static Object createNewCommunityForCurrentUser() 
    {
      try{
        return Dfc_Util.createNewCommunityForUser();
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }  */
   
   
    @AuraEnabled
    public static Object getCommunityActionAreas(String Id) 
    {
      try {
        return Dfc_Util.readCommunityActionAreas(Id);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
    @AuraEnabled
    public static Object getCommunityActivities(String Id) 
    {
      try {

        return Dfc_Util.readCommunityActivitiesWithSigning(Id);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
    @AuraEnabled
    public static Object updateCommunity(DFC_Community__c community, DFC_Community_Action_Area__c[] actionAreas) 
    {
      try {
         Dfc_Util.validateCommunity(community);
         return Dfc_Util.updateCommunity(community, actionAreas) ;
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }

    @AuraEnabled
    public static Object updateActionAreas(String communityId, DFC_Community_Action_Area__c[] actionAreas) 
    {
      try {
         return Dfc_Util.updateActionAreas(communityId, actionAreas) ;
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }


    @AuraEnabled 
    public static Object addActivity(String communityId, DFC_Activity__c activity, String actionAreaIds) 
    {
        try{
           return Dfc_Util.addActivity(communityId, activity, Dfc_Util.unpack(actionAreaIds));
        }
        catch(Exception e) {
           return new Dfc_ErrorResponse(e);
        }
    }
    
    @AuraEnabled 
    public static Object updateActivity(DFC_Activity__c activity, String actionAreaIds) 
    {
        try{
           return Dfc_Util.updateActivity(activity, Dfc_Util.unpack(actionAreaIds));
        }
        catch(Exception e) {
           return new Dfc_ErrorResponse(e);
        }
    }
    
    @AuraEnabled 
    public static Object removeActivity(String activityId) 
    {
        try{
           return Dfc_Util.removeActivity(activityId);
        }
        catch(Exception e) {
           return new Dfc_ErrorResponse(e);
        }
    }
    
    @AuraEnabled 
    public static Object removeActivityAttachment(String activityId, String attachmentId) 
    {
        try{
           return Dfc_Util.removeActivityAttachment(activityId, attachmentId);
        }
        catch(Exception e) {
           return new Dfc_ErrorResponse(e);
        }
    }
    
    @AuraEnabled
    public static Object addRepresentative(String communityId, String email) 
    {
        try{
            return Dfc_Util.addRepresentative(communityId, email);
        }
        catch(Exception e) {
            return new Dfc_ErrorResponse(e);
        }
    }
    
    @AuraEnabled
    public static Object inviteRepresentative(String communityId, String email, String name) 
    {
      try{
        return Dfc_Util.inviteRepresentative(communityId, email, name) ;
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
    @AuraEnabled
    public static Object removeRepresentative(String communityId, String id) 
    {
      try{
        Dfc_Util.deleteRepresentative(communityId, id);
        return null;
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }



    @AuraEnabled
    public static Object getCommunitiesForDaa(String daaId) 
    {
      try{
        return Dfc_Util.getCommunitiesForDaa(daaId);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }

    @AuraEnabled
    public static String getCurrentUserId() 
    {
        return UserInfo.getUserId();
    }

    @AuraEnabled
    public static Object getCurrentContactId() 
    {
      try{
        return Dfc_Util.getDfContactIdForCurrentUser();
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }


}