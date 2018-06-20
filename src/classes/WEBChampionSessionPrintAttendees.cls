/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBChampionSessionPrintAttendees.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBChampionSessionPrintAttendees class.
 *                  This returns the relevent event record to the page for rendering as PDF
 *               
 *  Modification History
 *  Date            Who         Description 
 *  2014-07-28      CSL         Changing the code that brings in the DF Event Attendees so it doesn't
 *                              look at records with status CANCELLED          
*******************************************************************************************/
public without sharing class WEBChampionSessionPrintAttendees extends DF_WEBC_ControllerBase {

    public final String STATUS_CANCELLED = 'Cancelled';
    public Boolean isChampion {get;set;}
    public DF_Event__c event {
       get{ if (event == null) event = new DF_Event__c();
        return event;
        }
       set;
    }
    
    public List<DF_EventAttendee__c> attendees {
        get {
            if (attendees == null)
                attendees = new List<DF_EventAttendee__c>();
            return attendees;
        }
        set;
    }

    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}
    public Double offset {get; set;}
    public Integer noOfAttendees {
        get {
            return attendees.size();
        }
    }

    //Constructor
    public WEBChampionSessionPrintAttendees() {
        isChampion = DF_Utils.isChampion(currentDfc);
        offset = DF_Utils.offset;
        String currentSession = ApexPages.currentPage().getParameters().get('eventId');

        if (currentSession != null) {
            System.debug('*** Found Event Parameter ' + currentSession);
                
            attendees = [SELECT Id,DF_Event__r.Name,DF_Event__r.Event_Date_Time__c, DF_Event__r.Postcode__c,
                        DF_Event__r.Street__c,DF_Event__r.City__c,DF_Event__r.County__c,DF_Contact__r.Title__c, 
                        DF_Contact__r.First_Name__c, DF_Contact__r.Last_Name__c, DF_Contact__r.Email__c 
                        FROM DF_EventAttendee__c 
                        WHERE DF_Event__r.Id = :currentSession
                        AND Event_Status__c != :STATUS_CANCELLED];
            event = [select Id,Name,Street__c,Event_Date_Time__c,City__c,County__c,Postcode__c from DF_Event__c where Id = :currentSession];
        }
    }
}