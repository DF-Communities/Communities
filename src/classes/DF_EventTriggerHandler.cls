public without sharing class DF_EventTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the DF_Event__c Trigger.
 *  Author  : Ian Smith
 *  Date    : 24-01-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Apex Class calls the LastTransactionDateLookup Apex Class to update the 
 *                  lastTransactionDate__c field for the DF_Event__c Record.
 *
 *          The Class also calls updateDFContactSessionStats method to update the 
 *          Session stats for the Session_Organiser__c for DF_Event they are related to.
 *               
 *  Modification History
 *  Date            Who         Description 
 *  24-01-2014      MTinson     Added Call to UpdateLastTransactionDate Class.
 *  11-03-2014      STadikonda  Added call to Update Contact Session Stats 
 *  24-03-2014      Mike Tinson If no completed sessions, average conversions is zero  
 *  12/05/2014      CSL         Commenting out code for LastTransactionDateLookup
    23/01/2015      Gary Grant  Handle Setting Full/Available Status                    
*******************************************************************************************/

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static final String CHAMPION_RT = 'Champion_Training_Course';
    public static final String SESSION_RT = 'Dementia_Friend_Awareness_Session';
    public static Boolean isRun = false;
        
        
    public DF_EventTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    /* Check if the Status of the event should be set to full */
    private void updateStatusForAttendeeNumbers(DF_Event__c[] dfEvents, Map<ID, DF_Event__c> mapOldDfEvents)
    {
        
        
        for(DF_Event__c dfEvent : dfEvents) {
            
            /* This will remain null for an Insert */ 
            DF_Event__c oldEvent = null;
            
            /* This validation uses different fields for Champion Training Sessions
               and Friends Information Sessions
            */              
            
            if ( mapOldDfEvents != null ) {
                oldEvent = mapOldDfEvents.get(dfEvent.id);
            }
            
            /* The number of attendees is recorded in different fields for each Event type 
               TODO!!! RecordTYpe_Name__c on the Object should be changed to use DeveloperName not Name                 
            */          
            Decimal iNoAttendees = 0; 
            
            if (dfEVent.RecordTypeId == DF_Utils.getDfEventRecordTypeId(CHAMPION_RT) ) {
                 
                 iNoAttendees = dfEvent.Number_Of_Champions_Attended__c;
                 
            } else if (dfEVent.RecordTypeId == DF_Utils.getDfEventRecordTypeId( SESSION_RT)) {
                
                 iNoAttendees = dfEvent.Number_Of_Attendee_Records__c;
            
              /* Event Record TYpe is uknown */         
            } else { return; }
            
            
            /* Trap the special case that the user is switching the status to full where spaces are available. */
            if ( oldEvent != null && oldEvent.Event_Status__c == 'Available' && dfEvent.Event_Status__c == 'Full' ) {
            
                if ( iNoAttendees < dfEvent.Number_of_Places__c  ) {
                    dfEvent.addError('You cannot change this session to Full with places still available.  Please set the number of places to ' + iNoAttendees + ' to mark this session as Full');
                }               
            
            } else {                
    
                 /* Set the status to Full/Available where relevant */ 
    
                 if ( dfEvent.Event_Status__c =='Available' && (iNoAttendees == dfEvent.Number_of_Places__c )) {                    
                      dfEvent.Event_Status__c = 'Full';
                 }  
                 
                 if ( dfEvent.Event_Status__c =='Full' && (iNoAttendees < dfEvent.Number_of_Places__c )) {                  
                      dfEvent.Event_Status__c = 'Available';
                 }
                 
            }               
                
        }
    }
    
    
    public void OnBeforeInsert(DF_Event__c[] dfEvents)
    {   
        /* 23/01/2015. This was previously handled by a workflow rule. However, workflow rules
                       run after validation, so it needs to be handled here.*/
        updateStatusForAttendeeNumbers(dfEvents, null);                                       
        checkEventAddressUpdate(dfEvents,null);                     
    }

    public void OnBeforeUpdate(DF_Event__c[] dfEvents, Map<ID, DF_Event__c> mapOldDfEvents)
    {
        /* 23/01/2015. This was previously handled by a workflow rule. However, workflow rules
                       run after validation, so it needs to be handled here.*/
        updateStatusForAttendeeNumbers(dfEvents,mapOldDfEvents);
        checkEventAddressUpdate(dfEvents,mapOldDfEvents);
		//updateDfSessionAdminEdits(dfEvents,mapOldDfEvents);
        
        if(!isRun) {
        	statusDrivenInfoSessionEmails(dfEvents, mapOldDfEvents);
            isRun = true;
        }
        
    }
    
    public void OnAfterInsert(DF_Event__c[] dfEvent, Map<ID, DF_Event__c> dfEventMap)
    {
        
        List<Id> dfEventIds = new List<Id>();
        List<Id> sessionOrganisers = new List<Id> ();
        Datetime dtLastTransactionDate = datetime.now();
        
        //Iterate over the DF_Event Object for the DF_Event/s being Inserted via the DF_Event__c Trigger. 
        for(DF_Event__c dfe : dfEvent)
        {
          //Add the DF_Event Id field to a List Collection.
            dfEventIds.add(dfe.Id);
            
            if(dfe.Session_Organiser__c != NULL){
                sessionOrganisers.add(dfe.Session_Organiser__c);
            }
            
            /*if(dfe.RecordType_Name__c == 'Dementia Friend Information Session') {
                // Send confirmation of event creation to the session requester
                new DF_Pure360_Email_Handler().sendFriendConfirmationOfNewInfoSessionRequest(dfe.Session_Requester_Email__c, dfe.Session_Requester_Name__c.split(' ')[0]);  
                
            }*/
            
        }

        if(dfEventIds.isEmpty() == false)
        {
            if(sessionOrganisers.isEmpty() == false)
            {
              //Call Apex Method to calculate DF Champion Session Statistics.
                updateDFContactSessionStats(sessionOrganisers);
            }
                             
            //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime. 
            //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records
            //LastTransactionDateLookup handler = new LastTransactionDateLookup();
            //handler.UpdateLastTransactionDate(dfEventIds[0], dtLastTransactionDate); 
        }
    }   
    
    public void OnAfterUpdate(DF_Event__c[] olddfEvent, DF_Event__c[] updateddfEvent, Map<ID, DF_Event__c> dfEventMap){
            
        List<Id> dfEventIds = new List<Id>();
        List<Id> sessionOrganisers = new List<Id> ();
        Datetime dtLastTransactionDate = datetime.now();
        
        //Iterate over the DF_Event Object for the DF_Event/s being Updated via the DF_Event__c Trigger.
        for(DF_Event__c df : updateddfEvent)
        {
          //Add the DF_Event Id field to a List Collection.
            dfEventIds.add(df.Id);
            
            if(df.Session_Organiser__c != NULL)
            {
                //Add the DF_Event Session_Organiser__c field to a List Collection.
                sessionOrganisers.add(df.Session_Organiser__c);
            }
        }

        if(dfEventIds.isEmpty() == false)
        {
            if(sessionOrganisers.isEmpty() == false)
            {
              //Call Apex Method to calculate DF Champion Session Statistics
              updateDFContactSessionStats(sessionOrganisers);
            }
     
            //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime. 
            //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records
            //LastTransactionDateLookup handler = new LastTransactionDateLookup();
            //handler.UpdateLastTransactionDate(dfEventIds[0], dtLastTransactionDate); 
        }
    }
    
    

    public void OnAfterDelete(DF_Event__c[] oldDFEvent, Map<ID, DF_Event__c> DFEventMap){
            
        List<Id> dfEventIds = new List<Id>();
        List<Id> sessionOrganisers = new List<Id> ();
        Datetime dtLastTransactionDate = datetime.now();
        
        //Iterate over the DF_Event Object for the DF_Event/s being Deleted via the DF_Event__c Trigger.
        for(DF_Event__c df : oldDFEvent)
        {
          //Add the DF_Event Id field to a List Collection.
            dfEventIds.add(df.Id);
            
            if(df.Session_Organiser__c != NULL)
            {
                //Add the DF_Event Session_Organiser__c field to a List Collection.
                sessionOrganisers.add(df.Session_Organiser__c);
            }
        }

        if(dfEventIds.isEmpty() == false)
        {
            if(sessionOrganisers.isEmpty() == false)
      {
        //Call Apex Method to calculate DF Champion Session Statistics
                updateDFContactSessionStats(sessionOrganisers);
            }
            
            //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime. 
            //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records
            //LastTransactionDateLookup handler = new LastTransactionDateLookup();
            //handler.UpdateLastTransactionDate(dfEventIds[0], dtLastTransactionDate); 
        }
    }
        
        
        
    public boolean IsTriggerContext
    {
        get{ return m_isExecuting;}
    }
    
    
    private void statusDrivenInfoSessionEmails(DF_Event__c[] newEvents, Map<Id,DF_Event__c> mapOldEvents) {
                
        for(DF_Event__c event : newEvents) {
        
            if(event.RecordType_Name__c == 'Dementia Friend Information Session' && event.Requested_Info_Session__c) {
            
                String linkUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+ event.Id;
                String sessionRequesterName = event.Session_Requester_Firstname__c;
                String sessionRequesterEmail = event.Session_Requester_Email__c;
                String sessionOrganiserName = event.Session_Organiser_Firstname__c;
                String sessionOrganiserEmail = event.Session_Organiser_Email__c;
                String contactRecType = event.Session_Organiser_Type_Of_Contact__c; 
                
                System.debug('Will be debugging: ' + event.Request_Status__c + ' with previous status: ' + mapOldEvents.get(event.Id).Request_Status__c);
                if(event.Request_Status__c == 'Open - waiting for champion' && mapOldEvents.get(event.Id).Request_Status__c == 'Waiting for approval') {
                   
                    new DF_Pure360_Email_Handler().sendFriendConfirmationOfSessionApproval(sessionRequesterEmail, linkUrl, sessionRequesterName, event);                    
                               
                } else if(event.Request_Status__c == 'Matched with champion' && mapOldEvents.get(event.Id).Request_Status__c != 'Matched with champion') {
                        
                    new DF_Pure360_Email_Handler().sendFriendConfirmationOfChampSignup(sessionRequesterEmail, linkUrl, sessionRequesterName, event);                    
                    new DF_Pure360_Email_Handler().sendChampConfirmationOfSignup(sessionOrganiserEmail, linkUrl, sessionOrganiserName, event);                    
                
                } else if(event.Request_Status__c == 'Withdrawn' && mapOldEvents.get(event.Id).Request_Status__c == 'Matched with champion') {
                                                  
                    new DF_Pure360_Email_Handler().sendChampConfirmationOfSessionCancellation(sessionOrganiserEmail, sessionOrganiserName);   
                
                
                } else if(event.Request_Status__c != 'Matched with champion' && mapOldEvents.get(event.Id).Request_Status__c == 'Matched with champion') {
                                                  
                    new DF_Pure360_Email_Handler().sendFriendConfirmationOfChampDropOut(sessionRequesterEmail, sessionRequesterName, event);                    
                    
                    // Set the Session Organiser field for champ reassignments
                    if(event.Request_Status__c == 'Open - waiting for champion') {
                        event.Session_Organiser__c = [SELECT Value__c FROM Community_Settings__c WHERE Name = 'DF_Placeholder_InfoSessionOrganiser'].Value__c;
                    }
                
                } else if(event.Event_Status__c == 'Cancelled' && !event.Session_Cancellation_Email_Sent__c) {
                                                  
                    //new DF_Pure360_Email_Handler().sendFriendConfirmationOfSessionCancellation(sessionRequesterEmail, sessionRequesterName);                    
                    new DF_Pure360_Email_Handler().sendChampConfirmationOfSessionCancellation(sessionOrganiserEmail, sessionOrganiserName);                    
                
                } else if(event.Event_Status__c == 'Completed' && !event.Feedback_Email_Sent__c) {
                                                 
                    new DF_Pure360_Email_Handler().sendFriendRequestForFeedback(sessionRequesterEmail, sessionRequesterName);                    
                    new DF_Pure360_Email_Handler().sendChampRequestForFeedback(sessionOrganiserEmail, sessionOrganiserName);                    
    
                } 
            }
        }
        
    }
    
    /*
    //update champion friend count per org by events linked with n org
    public void updateChampionsFriendsCounts(DF_Event__c[] olddfEvent, DF_Event__c[] updateddfEvent, Map<ID, DF_Event__c> olddfEventMap){
    
    Map <String,Double> orgEventMap = new Map <String,Double>();
    List <Partner_Organisation__c> partnerlist = new List <Partner_Organisation__c>();
    Set <Id> partnerIds = new Set <Id>();
    Set <Id> updatedpIds = new Set <Id>();
    //on event creation calculate count only on these events    
    boolean eventcheck ;
    
    for(DF_Event__c event:updateddfEvent){
        eventcheck = (event.recordTypeId == DF_Utils.getDfEventRecordTypeId( SESSION_RT) && event.Partner_organisation__c != null  && event.Number_of_Attendees__c!=null );
       
       //new events
       if(eventcheck && olddfEventMap == null ){
     
           partnerIds.add(event.Partner_Organisation__c);
                 
       }
     //existing events
      if(event.recordTypeId == DF_Utils.getDfEventRecordTypeId( SESSION_RT)  && olddfEventMap != null){
        //existing events with attendee number change
         if(event.Partner_Organisation__c!=null && olddfEventMap.get(event.Id).Number_of_Attendees__c!=event.Number_of_Attendees__c){
          partnerIds.add(event.Partner_Organisation__c);      
       }
       //existing events with partner organisation change
       if( olddfEventMap.get(event.Id).Partner_organisation__c != event.Partner_organisation__c){
          //list with existing events with old Partner_organisation__c value
          partnerIds.add(olddfEventMap.get(event.Id).Partner_organisation__c);  
          //list with existing events with selected Partner_organisation__c value
          partnerIds.add(event.Partner_organisation__c); 
           
       }
       }
   }
   system.debug ('@@Partner IDs '+partnerIds);
   
    List<aggregateResult> PartnerOrganisationAgg =[SELECT partner_organisation__c
                                                           ,SUM(Number_of_Attendees__c) totalfriends
                                                           ,COUNT(id) event 
                                                   FROM DF_Event__c 
                                                   WHERE RecordTypeId =: DF_Utils.getDfEventRecordTypeId( SESSION_RT)  
                                                   AND  partner_organisation__c in:partnerIds
                                                GROUP BY partner_organisation__c limit 50000];
      
      system.debug ('@@PartnerOrganisationAgg '+PartnerOrganisationAgg .size());
      Map<Id, Integer> partnerFriendsCount = new Map<Id, Integer>();
      
      
      IF (PartnerOrganisationAgg .size()>0){
        
        for (AggregateResult argRec : PartnerOrganisationAgg ){
            Double Total_No_of_Friends_CreatedDouble = (Double)argRec.get('totalfriends');
            
            partnerFriendsCount.put( (Id)argRec.get('Partner_organisation__c') ,Total_No_of_Friends_CreatedDouble.IntValue());
           
        }
      }
    //update partner organisation count for orgs that already have linked DF events 
    for(Partner_Organisation__c partner:[select Number_Of_Friends_By_Org_Sessions__c,Number_of_Champions_Identified__c,Id from Partner_Organisation__c where id in:partnerFriendsCount.keyset()]){
       
       partner.Number_Of_Friends_By_Org_Sessions__c =partnerFriendsCount.get(partner.Id);
       partnerlist.add(partner);
       updatedpIds.add(partner.Id);
     }
     //partner orgs that do not have any link event other than the event on trigger context need removing numbers when change org on the session
     //these orgs not selected part of the aggregated query
     for(Partner_Organisation__c partner:[select Number_Of_Friends_By_Org_Sessions__c,Number_of_Champions_Identified__c,Id from Partner_Organisation__c where id in:partnerIds and id not in:updatedpIds]){
        partner.Number_Of_Friends_By_Org_Sessions__c = 0 ;
        partnerlist.add(partner);
     }
     //update orgs
     if(partnerlist.size()>0){
     update partnerlist;
     }
     
     
   }*/
      
    public void updateDFContactSessionStats(List<Id> sessionOrganisers)
    {
      
    //Get a List of DF_Events for the incoming sessionOrganisers.
    List<DF_Event__c> lstDFEvent = [SELECT Id,Session_Organiser__c,Event_Status__c,Request_Status__c,Number_of_Attendees__c,Public_Event__c 
                                    FROM DF_Event__c 
                                    WHERE Session_Organiser__c IN : sessionOrganisers];
    Set<Id> seshIds = new Set<Id>();
    
    for(DF_Event__c dfCon : lstDFEvent)
    {
      //Add the DF_Event Session_Organiser__c field to a List Collection.
      seshIds.add(dfCon.Session_Organiser__c);
    }

    //Get a List of DF_Contacts for all seshIds..
    List<DF_Contact__c> lstDFCon = [SELECT Id FROM DF_Contact__c WHERE Id IN : seshIds];

        if(lstDFCon.isEmpty() == false)
        {
          //Iterate over the Df_Contact Object for all records in lstDFCon. 
          for(Df_Contact__c dfc : lstDFCon)
          {
        Double noOfAttendees = 0.0;
              Double privateSessions = 0.0;
              Double publicSessions = 0.0;
              Double totalCompletedSessions = 0.0;
              Double totalAvailableSessions = 0.0;
              Double totalCancelledSessions = 0.0;
  
              for(Df_Event__c eventRec : lstDFEvent)
              {
                //Ensure the Session Organiser is the same as the DF_Contact.
                  if(eventRec.Session_Organiser__c == dfc.ID)
                  {
                      if(eventRec.Event_Status__c == 'Completed')
                      {
                          totalCompletedSessions = totalCompletedSessions + 1;
                          
                          if(eventRec.Number_of_Attendees__c == NULL)
                          {
                              eventRec.Number_of_Attendees__c = 0.0;
                          }else
                          {
                            noOfAttendees = noOfAttendees + eventRec.Number_of_Attendees__c;
                          }  
                          
                          if(eventRec.Public_Event__c == TRUE)
                          {
                              publicSessions = publicSessions + 1;
                          }else
                          {
                              privateSessions = privateSessions + 1;
                          }
                      }
                      else if(eventRec.Event_Status__c == 'Available')
                      {
                          totalAvailableSessions = totalAvailableSessions + 1;
                      }
                      else if(eventRec.Event_Status__c == 'Cancelled')
                      {
                        totalCancelledSessions = totalCancelledSessions + 1;  
                      }
                  }               
              } 
               dfc.Total_No_of_Completed_Info_Sessions__c = totalCompletedSessions;
               dfc.Total_No_of_Cancelled_Info_Sessions__c = totalCancelledSessions;
               dfc.Total_No_of_Available_Info_Sessions__c = totalAvailableSessions;
               dfc.Total_No_of_Friends_Created__c = noOfAttendees;
               System.debug('##### Totals: ' + ' totalCompleted: ' + totalCompletedSessions
                                + ' totalCancelled: ' + totalCancelledSessions
                                + ' totalAvailable: ' + totalAvailableSessions
                                + ' noOfAttendees: '  + noOfAttendees);
               
               if(totalCompletedSessions != 0.0){
                   dfc.Average_No_of_Friends_Created__c = noOfAttendees/totalCompletedSessions;
               }else {
                   dfc.Average_No_of_Friends_Created__c = 0;
               }
               dfc.Number_of_Private_Sessions_Run__c = privateSessions;
               dfc.Number_of_Public_Sessions_Run__c =  publicSessions;            
          }
          
          //Attempt to Update the DF_Contact record with the Session Stats. 
            try{
                update lstDFCon;
                System.debug('****** Update Session Stats ******');
            }
            catch(DMLException e){
                System.debug('****** Error Updating Session Stats ******');
            }          
        }
    }
    
    
    public void checkEventAddressUpdate(List<DF_Event__c> updateddfEvent, Map<ID, DF_Event__c> oldDFEventsMap){
        
        List<DF_Event__c> dfeToUpdate = new List<DF_Event__c>();
        
        for (DF_Event__c e :updateddfEvent) {
            if (oldDFEventsMap==null & e.postcode__c!=null){
                 
                e.Address_updated__c = true;
                dfeToUpdate.add(e);
            }
        
            if (oldDFEventsMap!=null & e.Street__c!=null){
               if(oldDFEventsMap.get(e.id).PostCode__c != e.PostCode__c)
        
              e.Address_updated__c = true;
              dfeToUpdate.add(e);
            }
         }

      }
}