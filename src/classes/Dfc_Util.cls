public without sharing class Dfc_Util 
{
    public static DFC_Community__c readCommunity(String Id) 
    {

      System.debug('======= readCommunity ========='+Id);
      readAccessCheck(Id);
      
      DFC_Community__c[] data = [
         SELECT Id, Name, Name__c, Status__c, Country__c,
                    Region__c, Region__r.Name, Region__r.Image_name__c,
                    Central_Location__c, Why_No_Central_Location__c,
                    County__c, County__r.Name,  
                    Location__c,  Location_Type__c, Population__c, Date_Submitted__c, Date_Approved__c, Duplicate_Confirmation__c,
                CreatedDate, SystemModstamp, CreatedBy.Name, DA_Alliance__r.Name, DA_Alliance__r.Region__c,
                (select a.Id, a.Action_Area__r.Name, a.Description__c, a.Selected__c from Action_Areas__r a), //  Remove when migration from service to store complete
                (select p.Id, p.Role__c, p.Invited_Name__c, p.Invited_Email__c, p.DF_Contact__r.Name, p.DF_Contact__r.Last_Name__c,p.DF_Contact__r.Email__c, CreatedDate from Representatives__r p)
         FROM DFC_Community__c WHERE Id = :Id
      ]; 

      return data.size()>0 ? data[0] : null;  
    }

   public static DFC_Assessment__c readAssessment(String Id) 
    {
      DFC_Assessment__c[] data = [
         SELECT Id, Community__c, Name, Status__c, Year_Number__c, Date_Submitted__c, Community__r.Date_Approved__c, LastModifiedDate, LastModifiedBy.Name, 
                (select a.Id, a.Name, a.Title__c, a.Sequence__c, a.Include_Other__c, a.Other_Option_Label__c, a.Guidance__c, a.Options__c, a.Entered_Answer__c, a.Extra_Information__c, Repeat_Per_Action_Area__c,
                 a.Capture_Extra__c, a.Capture_Extra_On_Option__c, a.Capture_Extra_Required__c, a.Question_Style__c, a.Question_Text__c, a.Other_Selected__c, a.Continuation__c 
                 from Answers__r a)
         FROM DFC_Assessment__c WHERE Id = :Id
      ];

      if (data.size()==0) return null;

      readAccessCheck(data[0].Community__c);

      return data[0];        
    }

    public static DFC_Assessment__c getAssessmentForCommunityAndYear(String communityId, Integer yearNumber)
    {

      System.debug('======= getAssessmentForCommunityAndYear =========  communityId= '+communityId + 'Year:' + yearNumber);

      DFC_Community__c community  = readCommunity(communityId);
      if (community.Date_Approved__c == null) return null;

      Integer currentAssessmentYear = getCurrentAssessmentYear(community);


      System.debug('======= Current Assessment year =========  '+currentAssessmentYear);

      if (currentAssessmentYear < 1) return null;
      if (yearNumber > currentAssessmentYear) throw new Dfc_Exception('Assessment not found');
      if (yearNumber <= 0) yearNumber = currentAssessmentYear;

      DFC_Assessment__c[] data = [
         SELECT Id, Status__c, Year_Number__c, Date_Submitted__c, LastModifiedDate  
         FROM DFC_Assessment__c WHERE Community__c = :community.Id and Year_Number__c = :yearNumber
      ];

      if (data.size()>1) throw new Dfc_Exception('Duplicate assessment for year '+yearNumber);

      if (data.size()==1) {
          if (data[0].Status__c == 'New' && yearNumber == currentAssessmentYear) {
           delete data;
          }
          else {
           return readAssessment(data[0].Id);
          }
      }

      if (community.Status__c == 'Active' && yearNumber==currentAssessmentYear) 
          return createAssessment(community, yearNumber);

      throw new Dfc_Exception('Assessment not found');
   }
    
    public static Object updateAssessment(String assId, String status, DFC_Assessment_Answer__c[] answers)
    { 
        DFC_Assessment__c[] alist = [select Id, Community__c, Status__c, Date_Submitted__c from DFC_Assessment__c where Id = :assId];
        if (alist.isEmpty()) throw new Dfc_Exception('Invalid assessment Id:'+assId);
        
        DFC_Assessment__c ass = alist[0];
        if (ass.Status__c=='Submitted') throw new Dfc_Exception('Assessment has been submitted and can no longer be modified');
        
        readAccessCheck(ass.Community__c);        
        
        for (DFC_Assessment_Answer__c answer : answers) {
           DFC_Assessment_Answer__c aa = [select Id, Assessment__c from DFC_Assessment_Answer__c where Id = :answer.Id];
           if (aa.Assessment__c != assId) throw new Dfc_Exception('Inconsistent assessment Id');
           update answer;    
        }

      // If the Assessment status is being updated to Submitted, record the date  
      if (status.equals('Submitted') && !ass.Status__c.equals('Submitted')) {
        ass.Date_Submitted__c =System.now();
       }

       ass.Status__c = status;
       update ass;
        
       return readAssessment(assId);
    }
    
    private static DFC_Assessment__c createAssessment(DFC_Community__c comm, Integer year)
    {
        DFC_Assessment__c ass = new DFC_Assessment__c();
        ass.Community__c = comm.Id;
        ass.Status__c = 'New';
        ass.Year_Number__c = year;
        insert ass;
        
        DFC_Assessment_Question__c[] questions = [
            select Id, Name, Title__c, Sequence__c, Include_Other__c, Other_Option_Label__c, Guidance__c, Options__c, Question_Style__c, Repeat_Per_Action_Area__c,
                   Question_Text__c, Continuation__c, Capture_Extra__c, Capture_Extra_On_Option__c, Capture_Extra_Required__c
            from DFC_Assessment_Question__c where Active__c = true
        ];
        
        for (DFC_Assessment_Question__c question : questions) {
            if (question.Repeat_Per_Action_Area__c) {
                createActionAreaAnswerGroup(ass, question);
            }
            else {
                createAnswer(ass, question);
            }
        }
        
        return readAssessment(ass.Id);
    }

    
    private static DFC_Assessment_Answer__c newAssessmentAnswer(DFC_Assessment__c ass, DFC_Assessment_Question__c question)
    {
            DFC_Assessment_Answer__c answer = new DFC_Assessment_Answer__c();
            answer.Assessment__c = ass.Id;
            answer.Question__c = question.Id;
            answer.Title__c = question.Title__c;
            answer.Sequence__c = question.Sequence__c * 100;
            answer.Include_Other__c = question.Include_Other__c;
            answer.Other_Option_Label__c = question.Other_Option_Label__c == null || question.Other_Option_Label__c.trim().length()==0 ? 'Other' : question.Other_Option_Label__c;
            answer.Guidance__c = question.Guidance__c;
            answer.Options__c = question.Options__c;
            answer.Question_Style__c = question.Question_Style__c;
            answer.Question_Text__c = question.Question_Text__c;
            answer.Continuation__c = question.Continuation__c;
            answer.Capture_Extra__c = question.Capture_Extra__c;
            answer.Capture_Extra_Required__c = question.Capture_Extra_Required__c;
            answer.Capture_Extra_On_Option__c = question.Capture_Extra_On_Option__c;
            answer.Repeat_Per_Action_Area__c = question.Repeat_Per_Action_Area__c;
            return answer;
    }

    private static void createAnswer(DFC_Assessment__c ass, DFC_Assessment_Question__c question)
    {
        DFC_Assessment_Answer__c answer = newAssessmentAnswer(ass, question);
        insert answer;
    }
    
    private static void createActionAreaAnswerGroup(DFC_Assessment__c ass, DFC_Assessment_Question__c question)
    {
        Integer seq = 0;
        
        DFC_Community_Action_Area__c[] areas = readCommunityActionAreas(ass.Community__c);
        
        for (DFC_Community_Action_Area__c area : areas) {
            if (area.Selected__c==false) continue;
            DFC_Assessment_Answer__c answer = newAssessmentAnswer(ass, question);
            answer.Continuation__c = seq>0;
            if (seq==0) {
                if (answer.Guidance__c==null) answer.Guidance__c = '';
                if (answer.Question_Text__c==null) answer.Question_Text__c = '';
                answer.Guidance__c = (answer.Guidance__c+' '+answer.Question_Text__c).trim();
            }
            answer.Question_Text__c = area.Action_Area__r.Name;
            answer.Sequence__c += seq++;
            insert answer;
        }
    }
    
    private static Integer getCurrentAssessmentYear(DFC_Community__c comm)
    {
      DateTime ad = comm.Date_Approved__c;
      Date now = Date.today();
      return now.dayOfYear() < ad.dayOfYear() ? now.year() - ad.year() - 1 : now.year() - ad.year();
    }
    
    public static DFC_Community_Action_Area__c[] readCommunityActionAreas(String communityId) 
    {
      readAccessCheck(communityId);
      
      return [
         select Id, Action_Area__r.Name, Description__c, Selected__c,
         (select a.Activity__r.Id, a.Activity__r.Title__c from Activities__r a)
         FROM DFC_Community_Action_Area__c WHERE Community__c = :communityId
      ];
    }

    public static DFC_Activity__c[] readCommunityActivities(String Id) 
    {
      readAccessCheck(id);
      
      //NB keep this inline with readActivity()
      return [
          select Id, Name, Title__c, Start__c, End__c, Description__c, Community__c, SystemModstamp,
          (select a.Id, a.Action_Area__r.Action_Area__r.Name from Action_Areas__r a),
          (select n.Name, n.Id, n.ContentType, n.BodyLength from Attachments n)
         FROM DFC_Activity__c WHERE Community__c = :Id
      ];
    }

    @TestVisible
    private static DFC_Activity__c readActivity(String Id) 
    {
      //NB keep this inline with readCommunityActivities()
      return [
          select Id, Name, Title__c, Start__c, End__c, Description__c, Community__c, SystemModstamp,
          (select a.Id, a.Action_Area__r.Action_Area__r.Name from Action_Areas__r a),
          (select n.Name, n.Id, n.ContentType, n.BodyLength from Attachments n)
         FROM DFC_Activity__c WHERE Id = :Id
      ];
    }

    public static Map<String, Object> readCommunityActivitiesWithSigning(String Id) 
    {
      readAccessCheck(id);

      DFC_Activity__c[] activities = readCommunityActivities(Id) ;
        
      Attachment[] atts = 
          [ select Id from Attachment 
            where ParentId in (select Id from DFC_Activity__c WHERE Community__c = :Id ) 
          ];

       Map<String, String> sdata = new Map<String, String>();
        for (Attachment att : atts) {
          String sid = Dfc_Util.createSignedPayload(att.Id);
          sdata.put(att.Id, EncodingUtil.urlEncode(sid, 'UTF-8'));
        }

       Map<String, Object> data = new Map<String, Object>();
       data.put('activities', activities);
       data.put('sdata', sdata) ;

       return data;
    }


    public static DFC_Community__c[] getCommunitiesForCurrentUser()
    {
       String userId = UserInfo.getUserId();
       return getCommunitiesForUser(userId);
    }

    public static DFC_Community__c[] getCommunitiesForUser(String userId)
    {

      String contactId = getDfContactIdForUser(userId);    
      if (contactId==null) throw new Dfc_Exception('Dfc_Util getCommunitiesForCurrentUser() - Not a registered Dementia Friends user');

      return getCommunitiesForDfContact(contactId);        

    }

    public static DFC_Community__c[] getCommunitiesForDfContact(String contactId)
    {
       
      DFC_Community_Representative__c[] reps = [
          SELECT Community__r.Id FROM DFC_Community_Representative__c  
          WHERE DF_Contact__c = :contactId AND Community__r.Status__c NOT IN  ('Rejected','Inactive')
      ];

      if ( reps.size() ==0 ) { return null; }

      List<Id> repIds = new List<Id>();

      for (DFC_Community_Representative__c rep : reps){
          repIds.add(rep.Community__r.Id);
      }


       DFC_Community__c[] comms = [
          SELECT Id, Name, Name__c, Status__c, Date_Submitted__c, CreatedDate, Country__c, Location__c, DA_Alliance__c                
          FROM DFC_Community__c WHERE Id in :repIds
          ORDER BY Status__c, Country__c, Name__c asc
      ];

      return comms;
    }
    
    public static DFC_Community__c createNewCommunity() 
    {

      String userId = UserInfo.getUserId();

     
      String contactId = getDfContactIdForCurrentUser();    
      if (contactId==null) throw new Dfc_Exception('Dfc_Util getCurrentDraftForUser() - Not a registered Dementia Friends user');

      System.debug('==================  DF Contact Id  ========================'+contactId);
        
      // Create new Community with status 'New' so we don't get validation errora
      DFC_Community__c draft = new DFC_Community__c();
      draft.Status__c='New';
   
      insert draft;

      System.debug('==================  Created new Community ' + draft.Id);

      // Current user as first representative
      DFC_Community_Representative__c rep = new DFC_Community_Representative__c();
      rep.Community__c = draft.Id;
      rep.DF_Contact__c = contactId;
      rep.Role__c = 'Registered';
      insert rep;
      
      
      //  Action areas will be created by a trigger
      System.debug('==================  Added representative - reading newly created community with Id' + draft.Id);

      return readCommunity(draft.Id);
    }

    
   /*
    *    Returns the data required for a Draft Community
    */ 
   public static Dfc_CommunityContext getDraftContext(DFC_Community__c comm)
    {
        Dfc_CommunityContext context = new Dfc_CommunityContext();
        
        context.community = comm;

        String userId = UserInfo.getUserId();
        context.currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId];
        
        String contactId = getDfContactIdForUser(userId);
        context.currentContact = [SELECT Id, Name, Email__c FROM DF_Contact__c WHERE Id = :contactId];

        context.alliances = [SELECT Id, Name, Region__c FROM DFC_Alliance__c];
        context.counties =  [SELECT Id, Name, Country__c FROM DFC_County__c];

        // Added to support Welsh version
        context.regions =   [SELECT Id, Name,Image_name__c,Country__c, Sequence__c FROM DFC_DAA_Region__c];
        
        context.access =  [ SELECT RecordId, MaxAccessLevel, HasAllAccess, HasDeleteAccess, HasEditAccess, HasReadAccess, HasTransferAccess 
                      FROM UserRecordAccess 
                     where UserId = :userId and RecordId = :comm.Id ];
        
        return context;
    }
    

    /*
    *    Returns the data required for an Active Community - includes Activities
    */ 
    public static Dfc_CommunityContext getActiveContext(DFC_Community__c comm)
    {
        Dfc_CommunityContext context = new Dfc_CommunityContext();
        
        context.community = comm;

        // Where no DAA has been selected when the application form was submitted,
        // the users may want to link to an Alliance post approval
        if (comm.Country__c=='England' && comm.DA_Alliance__c==null) {
          context.alliances = [SELECT Id, Name, Region__c FROM DFC_Alliance__c where Region__c = :comm.Region__c];
        }

        String userId = UserInfo.getUserId();
        context.currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId];
        
        String contactId = getDfContactIdForUser(userId);
        context.currentContact = [SELECT Id, Name, Email__c FROM DF_Contact__c WHERE Id = :contactId];
        
        context.access =  [ SELECT RecordId, MaxAccessLevel, HasAllAccess, HasDeleteAccess, HasEditAccess, HasReadAccess, HasTransferAccess 
                      FROM UserRecordAccess 
                     where UserId = :userId and RecordId = :comm.Id ];
                     
         context.activities = [SELECT Id, Title__c, Description__c, Start__c, End__c FROM DFC_Activity__c];                     
        
        return context;
    }

   public static Map<String, Object> addActivity(String communityId, DFC_Activity__c activity, String[] actionAreaIds) 
   {
      System.debug('In addActivity Apex');
      editAccessCheck(communityId);

      System.debug('============================= Now in Dfc_Util addActivity. communityId= '+communityId + ' Activity'+activity.Title__c);

      System.debug('==============================  actionAreaIds.size()= = '+actionAreaIds.size());


      DFC_Community__c[] comms = [ select Id from DFC_Community__c where Id = :communityId ];
      if (comms.isEmpty()) throw new Dfc_Exception('');

      activity.Community__c = communityId;
      System.debug('Attempting to insert activity with: ' + activity);
      Database.SaveResult dsr = Database.insert(activity);
      System.debug('Activity inserted: sucess');
      //updateActivityActions(activity, actionAreaIds);
      
      // Get the relevant Community action area
      DFC_Community_Action_Area__c[] communityActionAreas = [SELECT Id, Action_Area__c, Community__c
                                                            FROM DFC_Community_Action_Area__c
                                                            WHERE Action_Area__c in :actionAreaIds
                                                            AND Community__c = :communityId];
       
      
      for (DFC_Community_Action_Area__c caa : communityActionAreas) {
        createActionActivity(dsr.getId(), caa.Id);
      }

      Map<String, Object> data = new Map<String, Object>();
      data.put('activity', readActivity(activity.Id));
      data.put('actionAreaData', readCommunityActionAreas(activity.Community__c));
      System.debug('After insertion of activity, data is returned as: ' + data);
      return data;
   }

   public static Map<String, Object> updateActivity(Map<String, String> activityParams, String previousFocusArea, String communityId) 
   {

      System.debug('In updateActivity APEX looking atactivityId: ' + activityParams.get('Id'));

      DFC_Activity__c[] activity = [SELECT Id, Title__c, Description__c, Start__c, End__c
                                   FROM DFC_Activity__c
                                   WHERE Id = :activityParams.get('Id')];

      System.debug('Returned activity size: ' + activity.size());

      System.debug('Id used to select juntion object focus area: ' + previousFocusArea);
      System.debug('Id for new focus area: ' + activityParams.get('focusAreaId'));
      // Get the appropriate Junction object (Focus Area on record / DFC_Action_Activity__c in data model)
      DFC_Action_Activity__c[] action = [SELECT Id, Activity__c, Action_Area__r.Action_Area__c, Action_Area__r.Action_Area_Display__c
                                         FROM DFC_Action_Activity__c 
                                         WHERE Action_Area__r.Action_Area__c = :previousFocusArea
                                         AND Activity__c = :activityParams.get('Id')];

      System.debug('Returned Focus Area junction object: ' + action);

      // Get the new community action area
      DFC_Community_Action_Area__c[] communityActionArea = [SELECT Id, Action_Area__c, Community__c
                                                            FROM DFC_Community_Action_Area__c
                                                            WHERE Action_Area__c = :activityParams.get('focusAreaId')
                                                            AND Community__c = :communityId];
      
      System.debug('Returned communityActionArea object: ' + communityActionArea);
                                                            
      // Reassociate the junction by deleting the old and adding the new
      if(action.size() == 1 && communityActionArea.size() == 1) {

        DFC_Action_Activity__c actionNew = new DFC_Action_Activity__c(
                                                Action_Area__c = communityActionArea[0].Id,
                                                Activity__c = activity[0].Id);

        insert actionNew;
        delete action;
        System.debug('Updated modified Action with action[0].Action_Area__c: (' + actionNew.Action_Area__c + 
          ') and Activity__c: (' + actionNew.Activity__c  + ')');

      }
                               
      if(activity.size() > 0) {

        activity[0].Title__c = activityParams.get('Title__c');
        activity[0].Description__c = activityParams.get('Description__c');
        activity[0].Start__c = Date.valueOf(activityParams.get('Start__c'));
        activity[0].End__c = Date.valueOf(activityParams.get('End__c'));

        try {
          update activity;

          Map<String, Object> data = new Map<String, Object>();
          data.put('activity', null); //readActivity(activity[0].Id));
          return data;

        } catch(Exception e) {
          throw new Dfc_Exception('Could not update activity');
        }

      } else {        
        throw new Dfc_Exception('Could not find an actiuvity to update');
      }
   }
       
   private static void updateActivityActions(DFC_Activity__c activity, String[] actionAreaIds)  // actionAreaIds are DFC_Community_Action_Area__c records
   {
      // Delete any action area junction objects that are not in the list of action areas
      DFC_Action_Activity__c[] aa = [select Id from DFC_Action_Activity__c where Activity__c = :activity.Id and Action_Area__c not in :actionAreaIds ];
      if (!aa.isEmpty()) delete aa;

      System.debug('=============================updateActivityActions ');
      
      for (String aaId : actionAreaIds) {
        aa = [select Id from DFC_Action_Activity__c where Activity__c = :activity.Id and Action_Area__c = :aaId ];
        if (!aa.isEmpty()) continue;

        createActionActivity(activity.Id, aaId);
      }
       
      DFC_Community_Action_Area__c[] areas = [select Id from DFC_Community_Action_Area__c where Community__c = :activity.Community__c and Action_Area__c in :actionAreaIds and Selected__c = false ];
      for (DFC_Community_Action_Area__c area : areas) area.Selected__c = true;           
      if (!areas.isEmpty()) update areas;
   }

   private static void createActionActivity(Id activityId, Id actionAreaId) {
      DFC_Action_Activity__c link = new DFC_Action_Activity__c();
      link.Activity__c = activityId;
      link.Action_Area__c = actionAreaId;
      insert link;
    }
       
   public static DFC_Community_Action_Area__c[] removeActivity(String activityId) 
   {
      DFC_Activity__c[] acts = [ select Id, Community__c from DFC_Activity__c where Id = :activityId ];
      if (acts.isEmpty()) throw new Dfc_Exception('Invalid activity Id '+activityId);
      editAccessCheck(acts[0].Community__c);
      delete acts[0];

      return readCommunityActionAreas(acts[0].Community__c);
   }
       
   public static Object removeActivityAttachment(String activityId, String attachmentId) 
   {
      DFC_Activity__c[] acts = [ select Community__c from DFC_Activity__c where Id = :activityId ];
      if (acts.isEmpty()) throw new Dfc_Exception('Invalid activity Id '+activityId);

      editAccessCheck(acts[0].Community__c);
       
      Attachment[] atts = [ select parentId from Attachment where Id = :attachmentId ];
      if (atts.isEmpty()) throw new Dfc_Exception('Invalid attachment Id '+attachmentId);
      if (atts[0].parentId != activityId) throw new Dfc_Exception('Attachment with Id '+attachmentId+' does not have correct parent '+activityId);
      delete atts[0];
       
      return null;
   }
       
    public static DFC_Community_Representative__c addRepresentative(String communityId, String email) 
    {
      editAccessCheck(communityId);

      if (existingRepresentative(communityId, email)) {
        throw new Dfc_Exception('The Email address '+email+' is already a confirmed or invited representative for this community') ;
      }
        
      DF_Contact__c[] users = [select Id, First_Name__c, Last_Name__c, Email__c from DF_Contact__c where Email__c = :email];
      if (users.isEmpty()) return null;                                                  // Prompt the user to enter the new representative name
      
      // Add the rep to the list of reps on the page automatically
      DFC_Community_Representative__c rep = new DFC_Community_Representative__c();
      rep.Community__c = communityId;
      rep.DF_Contact__c = users[0].Id;
      rep.Role__c = 'Registered';
      insert rep;

      return [select Id, Community__c, Role__c, DF_Contact__r.Name, DF_Contact__r.Email__c from DFC_Community_Representative__c where Id = :rep.id ];
    }
    
    public static String getDfContactIdForCurrentUser()
    {
      return getDfContactIdForUser(UserInfo.getUserId());
    }

    public static String getDfContactIdForUser(String userId)
    {
      DF_Contact__c[] data = [select Id from DF_Contact__c where Portal_User__c = :userId];
      return data.isEmpty() ? null : data[0].Id;
    }

    public static DFC_Community__c updateCommunity(DFC_Community__c community, DFC_Community_Action_Area__c[] actionAreas) 
    {
      editAccessCheck(community.Id);

      update community ;
      
      for (DFC_Community_Action_Area__c area : actionAreas) {
        update area;            
      }
      
      return readCommunity(community.Id);
    }

    public static DFC_Community_Action_Area__c[] updateActionAreas(String communityId, DFC_Community_Action_Area__c[] actionAreas) 
    {
      editAccessCheck(communityId);
      for (DFC_Community_Action_Area__c area : actionAreas) {
        update area;          
      }
      return readCommunityActionAreas(communityId);
    }

    public static DFC_Community_Representative__c inviteRepresentative(String communityId, String email, String name) 
    {
      editAccessCheck(communityId);


      if (existingRepresentative(communityId, email)) {
        throw new Dfc_Exception('The Email address '+email+' is already a confirmed or invited representative for this community') ;
      }
        
      DFC_Community_Representative__c rep = new DFC_Community_Representative__c();
      rep.Community__c = communityId;
      rep.Role__c = 'Invited';
      rep.Invited_Name__c = name;
      rep.Invited_Email__c = email.toLowerCase();
      insert rep;
      
      return rep;
    }

    public static boolean existingRepresentative(String communityId, String emailAddress)
    {
      DFC_Community_Representative__c[] representatives = 

          [ SELECT Id FROM DFC_Community_Representative__c 
            WHERE ( Community__r.Id = :communityId AND 
                   (DF_Contact__r.Email__c = :emailAddress.toLowerCase() OR 
                   Invited_Email__c = :emailAddress.toLowerCase()))
           ];        
           
      return representatives.size()>0 ;        
    }

    public static void deleteRepresentative(String communityId, String id) 
    {
      editAccessCheck(communityId);
      DFC_Community_Representative__c[] rep = [select Id from DFC_Community_Representative__c where Id = :id and Community__c = :communityId];
      delete rep;
    }

    public static DFC_Community__c[] getCommunitiesForDaa(String daaId)
    {
       return [select Id, Name, Name__c, Location__c, Status__c from DFC_Community__c 
               where DA_Alliance__c = :daaId 
               and Status__c not in ('Rejected','Inactive','Deleted')
              ];
    }

    public static void readAccessCheck(String communityId)
    {
        accessCheck(communityId, 'READ');
    }
    
    public static void editAccessCheck(String communityId)
    {
        accessCheck(communityId, 'EDIT');
    }
    
    public static void accessCheck(String communityId, String level)
    {      
      String contactId = getDfContactIdForCurrentUser();

      DFC_Community_Representative__c[] data = [ select Id from DFC_Community_Representative__c where DF_Contact__c = :contactId and Community__c = :communityId ];
 
      if (data.size()>0) return;  

      String userId = UserInfo.getUserId();
      UserRecordAccess[] ua = [ SELECT RecordId, HasAllAccess, HasDeleteAccess, HasEditAccess, HasReadAccess
                                FROM UserRecordAccess 
                                WHERE UserId = :userId and RecordId = :communityId ];
      if (!ua.isEmpty()) {
          if (level=='READ' && ua[0].HasReadAccess) return;
          if (level=='EDIT' && ua[0].HasEditAccess) return;
      }
        
      throw new Dfc_Exception('User '+userId+' does not have '+level+' access to record with community id '+communityId);
    }
    
    public static void validateCommunity(DFC_Community__c community)
    {
        // If there is a value in the Name__c field, check that this name is not in use for a different community
        if (community.Name__c != null && community.Name__c.trim() != '') {

           DFC_Community__c[] comms = [ select Id from DFC_Community__c where Name__c = :community.Name__c and Id <> :community.Id ];

           if (comms.size()>0) throw new Dfc_Exception('There is already a community with the name: ' + community.Name__c);
        }
        
        if (community.Status__c == 'New' || community.Status__c == 'Draft') return;
        
        //Probably these things that dont involve database access should go into the field definitions....
        if (community.Name__c==null || community.Name__c.trim()=='') throw new Dfc_Exception('Community name is required');
        
        //if .........
        
        
    }
    



    // Called by after insert Trigger Dfc_ContactTrigger - which is run when a new user registers
    public static void resolveInvitations(DF_Contact__c[] dfContacts)
    {
       List<String> emailAddresses = new List<String>();

       for (DF_Contact__c dfContact : dfContacts) {
              emailAddresses.add( dfContact.Email__c );
        }
    
       // Get a list of Invited Representatives for these email addresses
       DFC_Community_Representative__c[] reps = 
            [  select Id, DF_Contact__c, Invited_Email__c 
               from DFC_Community_Representative__c 
               where Role__c = 'Invited' and Invited_Email__c in :emailAddresses
               and Community__r.Status__c not in ('Rejected','Inactive') 
             ]; 

       // Update the Representative record with the Id of th DFC Contact
       for (DFC_Community_Representative__c rep : reps) {
            if (rep.DF_Contact__c==null) {
                rep.DF_Contact__c = findIdForEmail(rep.Invited_Email__c, dfContacts);
              }
            // Change the status of the representative from 'Invited' to 'Registered'
            rep.Role__c = 'Registered';

            // Now that the Invited user has a registered account, clear the Invite data
            rep.Invited_Email__c = null;
            rep.Invited_Name__c = null;
        }

        if (reps.size()>0) update reps;
    }

    @TestVisible
    // Returns the id of the DF_Contact__c record for a given email address in a list of DF_Contact__c s
    private static String findIdForEmail(String emailAddress, DF_Contact__c[] dfContacts)
    {
        for (DF_Contact__c dfc : dfContacts) {
            if (dfc.Email__c == emailAddress) {
              return dfc.Id;
            }
        }
        return null;
    }
    
    private static String xprefix = 'M2NXaSy8dpHEBJDDN1wOzg';
    private static String xkey = 'C+ZS+Ns3CGIasnaIXjTc5KHafxK95wNCVN2sEgwvZvM=';
    
    public static String createSignedPayload(String payload)
    {
        Blob key = EncodingUtil.base64Decode(xkey);
        
        String expires = ''+(System.now().getTime()+120*60*60*1000); //2 hours

        String clearText = xprefix + '£' + expires + '£' + payload;

        Blob cypher = Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf(clearText));
        
        return EncodingUtil.base64Encode(cypher);
    }
    
    public static String extractSignedPayload(String signedPayload)
    {
        System.debug('In extractSignedPayload');
        Blob key = EncodingUtil.base64Decode(xkey);
        System.debug('Key is: ' + key);
        Blob payload = Crypto.decryptWithManagedIV('AES256', key, EncodingUtil.base64Decode(signedPayload));
        String[] data = payload.toString().split('£');
        
        if (xprefix != data[0]) return null;
        
        Long expires = Long.valueOf(data[1]);
        if (System.now().getTime()>expires) return null;
        System.debug('Signed payload is: ' + data);
        return data[2];
    }
    
    public static String[] unpack(String json)
    {
      System.debug('In unpack');
      List<String> ret = new List<String>();
      System.debug('JSON String passed in as: ' + json);
      Object[] values = (Object[])System.JSON.deserializeUntyped(json);
      System.debug('Unpacked values are: ' + values);
      for (Object s : values) {
        ret.add(String.valueof(s) );
      }
      return ret;
    }
    
    

    
    public static Map<String, Object> getResourcesForState(String state)
    {

        if ( state == null ) {throw new Dfc_Exception('state cannot be null'); }

        Map<String, Object> data = new Map<String, Object>();
        DFC_Resource__c[] res = [select Id, Name, Title__c, Description__c
                                  from DFC_Resource__c where Applies_To_Status__c includes (:state) 
                                 ];

        Attachment[] att = [select Id, ParentId, Name, ContentType, BodyLength
                               from Attachment where ParentId in :res
                              ];
        
        data.put('resources', res);
        data.put('attachments', att);
            
        return data;
    }
    
   public static String readSnippet(String key) 
   {
      List<Page_Snippet__c> lis = [select Body_Text__c from Page_Snippet__c where Unique_Name__c = :key];        
      return lis.isEmpty() ? key : lis[0].Body_Text__c;
   }

   public static Map<String, Object> updateSnippet(Page_Snippet__c snippet) 
   {
      update snippet;
      return null;
      
   }

   /*
   ======================
   ======================
   LEGACY CODE             The follwoing methods are used by the old DFC ligthtning app and need to be kept as long as a side-by-side comparison of apps is required
   ======================
   ======================
    */
     public static Map<String, Object> updateActivity(DFC_Activity__c activity, String[] actionAreaIds) 
   {
      editAccessCheck(activity.Community__c);
      update activity;
      updateActivityActions(activity, actionAreaIds);
      
      Map<String, Object> data = new Map<String, Object>();
      data.put('activity', readActivity(activity.Id));
      data.put('actionAreaData', readCommunityActionAreas(activity.Community__c));
      return data;
   }

}