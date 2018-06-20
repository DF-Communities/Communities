public with sharing class Dfc_CommunityServiceController 
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
   
    @AuraEnabled
    public static Object updateCommunity(DFC_Community__c community, DFC_Community_Action_Area__c[] actionAreas) 
    {
      try{
         Dfc_Util.validateCommunity(community);
         return Dfc_Util.updateCommunity(community, actionAreas) ;
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
    public static Object deleteRepresentative(String communityId, String id) 
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
    public static Object getCommunityWithContext(String Id) 
    {
      
      try{
        DFC_Community__c comm =  Dfc_Util.readCommunity(Id);
        return Dfc_Util.getDraftContext(comm);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }

    }



    @AuraEnabled
    public static Object getCommunitiesForDaa(String daaId) 
    {
      try {
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

}