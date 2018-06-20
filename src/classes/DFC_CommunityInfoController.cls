public without sharing class DFC_CommunityInfoController 
{

    @RemoteAction
    public static Map<String, String> doUploadAttachment(String acctId, String attachmentBody, String attachmentName, String attachmentId, String contentType) {

      Map<String, String> resultMap = new Map<String, String>();
      if(acctId != null) {
          DFC_Activity__c acct = getAccount(acctId);
          if(acct != null) {
              if(attachmentBody != null) {
                  Attachment att = getAttachment(attachmentId);
                  String newBody = '';
                  if(att.Body != null) {
                      newBody = EncodingUtil.base64Encode(att.Body);
                  }
                  newBody += attachmentBody;
                  att.Body = EncodingUtil.base64Decode(newBody);
                  if(attachmentId == null) {
                      att.Name = attachmentName;
                      att.parentId = acct.Id;
                      att.ContentType = contentType;   
                  }
                  upsert att;
                  // Now get the signedId to populate the UI view link with
                  String sid = EncodingUtil.urlEncode(Dfc_Util.createSignedPayload(att.Id), 'UTF-8');
                  
                  
                  resultMap.put('id', att.Id);
                  resultMap.put('sid', sid);
                  return resultMap;
              } else {
                resultMap.put('id', 'Attachment Body was null');
                resultMap.put('sid', 'Attachment Body was null');
                return resultMap;
              }
          } else {
            resultMap.put('id', 'Account could not be found');
            resultMap.put('sid', 'Account could not be found');
            return resultMap;
          }
      } else {
        resultMap.put('id', 'Account Id was null');
        resultMap.put('sid', 'Account Id was null');
        return resultMap;
      }
    }
     
    @RemoteAction
    public static String doSubmitForm(String acctId, String description, String website, String phone) {
        if(acctId != null) {
            DFC_Activity__c acct = getAccount(acctId);
            if(acct != null) {
                acct.Description__c = description;
                update acct;
                return 'Success';
            } else {
                return 'Account could not be found';
            }
        } else {
            return 'Account Id was null';
        }
    }
     
    private static DFC_Activity__c getAccount(String acctId) {
        list<DFC_Activity__c> accounts = [SELECT Id, Name, Description__c                                  
                                          FROM DFC_Activity__c
                                          WHERE Id =:acctId];
        if(accounts.isEmpty()) {
            return null;
        } else {
            return accounts[0];
        }
    }
     
    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }

    @RemoteAction
    public static Object getCommunity(String Id) 
    {
      try{
        return Dfc_Util.readCommunity(Id);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
   
    @RemoteAction
    public static Object getCommunityActionAreas(String Id) 
    {
      try {
        return Dfc_Util.readCommunityActionAreas(Id);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
    @RemoteAction
    public static Object getCommunityActivities(String Id) 
    {
      try {

        return Dfc_Util.readCommunityActivitiesWithSigning(Id);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
    @RemoteAction
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

    
    @RemoteAction
    public static Object updateActionAreas(String communityId, DFC_Community_Action_Area__c[] actionAreas) 
    {
      System.debug('In updateActionAreas with actionareas: ' + actionAreas);
      try {
         return Dfc_Util.updateActionAreas(communityId, actionAreas) ;
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
    @RemoteAction 
    public static Object addActivity(String communityId, Map<String, String> activityParams, String actionAreaIds) 
    { 
       System.debug('activityParams: ' + activityParams);
        
        // Form the SFDC object from the parameters
        DFC_Activity__c activity = new DFC_Activity__c(Title__c = activityParams.get('Title__c'),
                                                       Community__c = communityId,
                                                       Description__c = activityParams.get('Description__c'),
                                                       Start__c = Date.valueOf(activityParams.get('Start__c')));

        // Add optional end date parameter if added
        if(activityParams.get('End__c') != null) {
          activity.End__c = Date.valueOf(activityParams.get('End__c'));
        }

        try{
           return Dfc_Util.addActivity(communityId, activity, Dfc_Util.unpack(actionAreaIds));
        }
        catch(Exception e) {
           return new Dfc_ErrorResponse(e);
        }

    }

    @RemoteAction
    public static Object updateActivity(Map<String, String> activityParams, String previousFocusArea, String communityId) 
    {
      try {
        return Dfc_Util.updateActivity(activityParams, previousFocusArea, communityId); 
      } catch(Exception e) {
        return new Dfc_ErrorResponse(e);
      }
   }
    
    @RemoteAction 
    public static Object removeActivity(String activityId) 
    {
        try{
           return Dfc_Util.removeActivity(activityId);
        }
        catch(Exception e) {
           return new Dfc_ErrorResponse(e);
        }
    }
    
    @RemoteAction 
    public static Object removeActivityAttachment(String activityId, String attachmentId) 
    {
        try{
           Dfc_Util.removeActivityAttachment(activityId, attachmentId);
           return true;
        }
        catch(Exception e) {
           return new Dfc_ErrorResponse(e);
        }
    }
    
    @RemoteAction
    public static Object addRepresentative(String communityId, String email) 
    {
        try{
            Object response = Dfc_Util.addRepresentative(communityId, email);
            if(response == null) {
              return false;
            } else {
              return response;
            }
        }
        catch(Exception e) {
            return new Dfc_ErrorResponse(e);
        }
    }
    
    @RemoteAction
    public static Object inviteRepresentative(String communityId, String email, String name) 
    {
      try{
        return Dfc_Util.inviteRepresentative(communityId, email, name) ;
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
    @RemoteAction
    public static Object removeRepresentative(String communityId, String id) 
    {
      try{
        if(Dfc_Util.deleteRepresentative(communityId, id) == null) {
          return true;
        } else {
          return false;
        }
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }

    @RemoteAction
    public static Object getCommunitiesForDaa(String daaId) 
    {
      try{
        return Dfc_Util.getCommunitiesForDaa(daaId);
      }
       catch(Exception e) { 
         return new Dfc_ErrorResponse(e);
      }
    }

    @RemoteAction
    public static String getCurrentUserId() 
    {
        return UserInfo.getUserId();
    }

    @RemoteAction
    public static Object getCurrentContactId() 
    {
      try{
        return Dfc_Util.getDfContactIdForCurrentUser();
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }

    @RemoteAction
    public static object readAssessment(String Id) 
    {
      try{
        return Dfc_Util.readAssessment(Id);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }


    @RemoteAction
    public static Object updateAssessment(String assessmentId, String status, DFC_Assessment_Answer__c[] answers) 
    { 
      try {
        return Dfc_Util.updateAssessment(assessmentId, status, answers);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }

   @RemoteAction
    public static Object getAssessmentForCommunityAndYear(String Id, Integer yearEnding) 
    {
      try {
        return Dfc_Util.getAssessmentForCommunityAndYear(Id, Integer.valueOf(yearEnding)); 
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }

    @RemoteAction
    public static Object getResources(String state) {
      try {
        return Dfc_Util.getResourcesForState(state);
      }
      catch(Exception e) {
        return new Dfc_ErrorResponse(e);
      }
    }

}