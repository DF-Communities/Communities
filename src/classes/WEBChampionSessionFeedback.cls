/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBChampionSessionFeedback.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBChampionSessionFeedback class.
 *                  This is used to create Session Feedback records for DF Events
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class WEBChampionSessionFeedback extends DF_WEBC_ControllerBase {
    
    public final String STATUS_CANCELLED = 'Cancelled';  
    public final String STATUS_COMPLETED = 'Completed';      
    public static final String SESSION_RT = 'Dementia_Friend_Awareness_Session';
    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}
    public Boolean ispartnerSession {get;set;}
    public DF_Contact__c dfc {get;set;}
    public String partnerError {get;set;}
    public Boolean isOrgChampion {get;set;}
    public Boolean isOrgAdmin {get;set;}
    public List<SelectOption> partnerList {
        get {

            if (partnerList == null)
                partnerList = new List<SelectOption>();
                
            return partnerList;

        }

        set;

    }
    
    public Integer partnerListSize {

        get {

            return partnerList.size();

        }

        set;

    }

    public DF_Event__c event {

        get {
            if (event == null)
                event = new DF_Event__c();
            return event;
        }
        set;

    }

    public List<SelectOption> sessionList {

        get {

            if (sessionList == null)
                sessionList = new List<SelectOption>();
            return sessionList;

        }

        set;

    }

    public Integer sessionListSize {

        get {

            return sessionList.size();

        }

        set;

    }

    public Boolean thereAreNoSessions {get;set;}
    public String selectedSession {get;set;}
    public string selectedPartner {get;set;}
    public Integer noOfAttendees {get;set;}
    public String sessionComments {get;set;}

    public List<DF_Event__c> eventsRequiringFeedback {

        get {
            if (eventsRequiringFeedback == null)
                eventsRequiringFeedback = new List<DF_EVENT__c>();
            
            return eventsRequiringFeedback;
        }
        set;

    }

    //Save method
    public PageReference save() {
        partnerError='';
        
        
        if(ispartnerSession && selectedPartner == 'none' ){
            
            partnerError='Please select partner organisation';
            return null;
        }

        if (event.Id == null && selectedSession != null) {
            event = [SELECT Id, Name, Event_Description__c, Partner_Organisation__c,Comments__c, Number_of_Attendees__c, Event_Status__c
                        FROM DF_Event__c
                        WHERE Id = :selectedSession ];
        }

        if (event.Id == null && selectedSession != null && selectedPartner != null) {
            event = [SELECT Id, Name,Partner_Organisation__c, Event_Description__c, Comments__c, Number_of_Attendees__c, Event_Status__c
                        FROM DF_Event__c
                        WHERE Id = :selectedSession  and Partner_Organisation__r.name =: selectedPartner ];
         
         }

        if (event != null ) {
           if(isPartnerSession==False) {
           	event.Partner_Organisation__c = null;
           	selectedPartner = null;
           }
           else{
           	event.Partner_Organisation__c = selectedPartner;
           }
            event.Number_of_Attendees__c = noOfAttendees;
            event.Comments__c = sessionComments;
            event.Event_Status__c = STATUS_COMPLETED;
                     
            upsert event;

        }
        
            PageReference pr = Page.WEBChampionManageMySessions;
            //google tracking QP-9
            pr.getParameters().put('info_session_reported','true');
            pr.getParameters().put('eventshare',noOfAttendees.format());
            return pr;
       

    }
    
    public PageReference cancelSession() {

        if (event.Id == null && selectedSession != null) {
            event = [SELECT Id, Name, Event_Description__c, Comments__c, Number_of_Attendees__c, Event_Status__c
                        FROM DF_Event__c
                        WHERE Id = :selectedSession];
        }

        if (event != null) {
            event.Event_Status__c = STATUS_CANCELLED;
            event.Comments__c = sessionComments;
            event.Number_of_Attendees__c=0;
            
            upsert event;
        }
        
        return Page.WEBChampionManageMySessions;

    }

    //Constructor
    public WEBChampionSessionFeedback() {
    	//list with duplicate partner name
    	List<SelectOption> partnerOrgList = new List<SelectOption> (); 
    	//create a unique partner list to select
    	Set<SelectOption> partnerSet =new Set <SelectOption> ();
        dfc = (currentdfc!=null? currentdfc:new DF_Contact__c());
        noOfAttendees = 0;
        sessionComments = '';
        thereAreNoSessions = FALSE;
        partnerError='';
        isPartnerSession=False;
        selectedPartner = 'none';
        String currentSession = ApexPages.currentPage().getParameters().get('eventId');
        isOrgChampion = (dfc.Partner_Organisation_Id__c != null && !dfc.Partner_Organisation_Id__r.Internal_purpose__c ? true: false);
        List<po_administrator__c> poadminlis = new List<po_administrator__c> ();
        poadminlis =[select name,Partner_Organisation__c,Partner_Organisation__r.Name from po_administrator__c where df_contact__c =:dfc.id and Status__c = 'Registered'];
        
        if(poadminlis.size()>0) { isOrgAdmin = true ;}
         for(po_administrator__c po : poadminlis){
            
                system.debug('partner admin'+po);
                if(po!=null && po.Partner_Organisation__c !=null ){
                
                partnerOrgList.add(new SelectOption(po.Partner_Organisation__c,po.Partner_Organisation__r.Name));
               
                }
            }
      
         	
         if(isOrgChampion){         	
              
               partnerOrgList.add(new SelectOption(dfc.Partner_Organisation_Id__c,dfc.Partner_Organisation_Id__r.Name));
          }
   
   //adding to a set make a unique list
    if(partnerOrgList.size()>0){
    	
        partnerSet.addAll(partnerOrgList);         
      }
   //unique partner list
       partnerList.addAll(partnerSet);
      
            
        if (currentSession != null) {
            
            
                
            event = [SELECT Id, Name, Event_Description__c, Partner_Organisation__c ,Partner_Organisation__r.name,Comments__c, Number_of_Attendees__c, Event_Status__c
                        FROM DF_Event__c
                        WHERE Id = :currentSession];

            if (event != null) {

                if (event.Number_of_Attendees__c != null)
                    noOfAttendees = event.Number_of_Attendees__c.intValue();

                if (event.Comments__c != null)
                    sessionComments = event.Comments__c;
               
                if (event.Partner_Organisation__c != null  )
                    selectedPartner = event.Partner_Organisation__c;
                    
                   
                isPartnerSession=(selectedPartner != 'none' && selectedPartner != null)?true:false;
                  
                
                
            } else {

                thereAreNoSessions = TRUE;

            }
        
        } else {

            // Choosing multiple sessions           
            String sdt = Datetime.now().format('yyyy-MM-dd HH:mm:ss', 'Europe/London');
            Datetime dt = Datetime.valueOf(sdt);

            eventsRequiringFeedback = [SELECT Id, Name, Event_Date_Time__c,Partner_Organisation__c, Event_End_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Places__c 
                                        FROM DF_Event__c 
                                        WHERE Session_Organiser__c = :dfc.id
                                        AND Event_End_Date_Time__c <: datetime.now()
                                        AND (Number_of_Attendees__c = null OR Number_of_Attendees__c = 0) 
                                        And RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT)
                                        and Event_Status__c != :STATUS_CANCELLED LIMIT 10];
            system.debug('dfc.id '+ dfc.id+'datetime.now()');
            //TEST CODE
            //eventsRequiringFeedback = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Places__c FROM DF_Event__c WHERE Session_Organiser__r.Portal_Contact__r.Id = :WEBController.thisUser.ContactId AND Event_Date_Time__c <= TODAY LIMIT 10];

            if (eventsRequiringFeedback == null || eventsRequiringFeedback.size() == 0) {
                thereAreNoSessions = TRUE;

                return;

            }

            for (DF_Event__c sess : eventsRequiringFeedback) {
                SelectOption s = new SelectOption(sess.Id, sess.Name + ' ' + sess.Event_Date_Time__c.format('dd/MM/yyyy'));
                sessionList.add(s);

            }
            
           

        }
        

    }
   
     
}