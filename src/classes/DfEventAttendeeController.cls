/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : 
 *  Author  : Venkat Akula
 *  Date    : 07/02/2013
 *  Version : 1
 *
 *  Description: Controller for the DF Event Attendee Page.  
 *               Allows user to update the status of the attendees at a DF Champions Training meeting.   
 *                  
 *               
 *  Modification History
 *  Date            Who         Description 
 *  07/03/2014      Sri Tadikonda        Add Champion Status
 *  11/04/2014      CSL         Removed the Trainer__c field from DF_Contact__c as per Ian Smith 11/04/2014
 *  14/04/2014      Mike Tinson Add Page header so user knows which event is being processed.
 *  17/04/2014      Mike Tinson Check that records have not been updated by someone else after page has been loaded.
 ******************************************************************************************/
Public Class DfEventAttendeeController
{
    Private Final DF_Event__c dfEvent;
    Public String EventTitle {get;set;}
    Public String EventRT {get;set;}
    List<DF_EventAttendee__c> listEventAttendees;
    List<DF_EventAttendee__c> listCurrentEventAttendees;
    List<DF_Contact__c> listDFContacts;
    List<Id> contactIds = new List<Id>();
    public string CHAMPION_RT = 'Champion_Training_Course';
    
    public DfEventAttendeeController(ApexPages.StandardController stdController)
    {
        this.dfEvent= (DF_Event__c)stdController.getRecord();
        
        Id dfEventId = dfEvent.Id;
        DF_Event__c dfEventRec = [Select id,recordtypeId,name from DF_Event__c  where id=:dfEventId ];
        EventTitle = dfEventRec.Name;
        EventRT = [select DeveloperName from RecordType where sObjectType = 'DF_Event__c' and isActive=true and Id=:dfEventRec.RecordTypeId].DeveloperName;
        
        //get list of attendees for the current event.
        listEventAttendees = (List<DF_EventAttendee__c>)[Select Id, Name, DF_Contact__r.Name, DF_Event__c, 
                       DF_Contact__r.Contact_Number__c,DF_Contact__r.Partner_Organisation_ID__c ,DF_EventAttendee__c.DF_Contact__r.Status__c,DF_EventAttendee__c.DF_Contact__r.Email__c,
                       DF_EventAttendee__c.DF_Contact__r.Name__c,DF_Event__r.Session_Organiser__c,EventAttendeeStatus__c, DF_Event__r.Trainer__c,Event_Record_type__c,
                       DF_Event__r.Event_Date_Time__c,DF_Contact__r.Type_of_Champion__c, LastModifiedDate,DF_Contact__r.LastModifiedDate,DF_Event__r.RecordTypeId 
                       FROM DF_EventAttendee__c Where DF_Event__c = : dfEventId];
       //standard sort order 
       listEventAttendees.sort();
       
       for(DF_EventAttendee__c rec:listEventAttendees)
       {
           contactIds.add(rec.DF_Contact__c);
       }
        //2014-04-11 : CSL : Removed Trainer__c field from DF_Contact__c
        //listDFContacts = [Select Name,Status__c,Email__c,Trainer__c,Type_of_Champion__c,Date_of_Champion_Training__c, Contact_Number__c FROM DF_Contact__c Where DF_Contact__c.Id IN:contactIds]; 
        listDFContacts = [Select Name,Status__c,Email__c,Partner_Organisation_ID__c,Type_of_Champion__c,Date_of_Champion_Training__c, Contact_Number__c FROM DF_Contact__c Where DF_Contact__c.Id IN:contactIds];
                                                            
    }                                                          
    public List<DF_EventAttendee__c> getListEventAttendees()
    {
        return listEventAttendees;
    }
 public List<selectOption> getPartnerOrgs() {

List<selectOption> orgOptions = new List<selectOption>(); 

  //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
  orgOptions.add(new selectOption('', '- None -')); 
  
  //query for User records with allowed profile
  for (Partner_Organisation__c orgs :[
   Select Id,Name
   FROM Partner_Organisation__c
                WHERE Active__c = true
                ORDER BY Name
              
            ])
  
{ 
//for all records found - add them to the picklist options
orgOptions.add(new selectOption(orgs.Id, orgs.Name)); 
}

//return the picklist options
return orgOptions; 

}
    
    public Pagereference save()
    {
        //re-read event records to get current modified date
        
        listCurrentEventAttendees = (List<DF_EventAttendee__c>)[Select Id
                                                                , Name
                                                                , LastModifiedDate
                                                                , DF_Contact__r.LastModifiedDate 
                                                                FROM DF_EventAttendee__c 
                                                                WHERE  DF_Event__c =:dfEvent.Id];
        
        //update date of training on Contact record.
        //also check for simulatious update on record.
        for(DF_EventAttendee__c rec :listEventAttendees)
        {
            for(DF_Contact__c dfContact: listDFContacts)
            {
                if(rec.DF_Contact__c == dfContact.Id && rec.DF_Event__r.RecordTypeId== DF_Utils.getsobjectRecordTypeId('DF_Event__c',CHAMPION_RT))
                {
                     if(rec.DF_Contact__r.Status__c == 'Converted')
                     {
                         dfContact.Status__c = rec.DF_Contact__r.Status__c;                       
                         dfContact.Date_of_Champion_Training__c = rec.DF_Event__r.Event_Date_Time__c.date();
                         //2014-04-11 : CSL : Removed Trainer__c field from DF_Contact__c
                         //dfContact.Trainer__c = rec.DF_Event__r.Session_Organiser__c;
                         dfContact.Type_of_Champion__c = rec.DF_Contact__r.Type_of_Champion__c;  
                         dfContact.Partner_Organisation_ID__c = rec.DF_Contact__r.Partner_Organisation_ID__c;  
                     }
                     else
                     {
                         dfContact.Status__c = rec.DF_Contact__r.Status__c;
                         dfContact.Date_of_Champion_Training__c = NULL;
                         //2014-04-11 : CSL : Removed Trainer__c field from DF_Contact__c
                         //dfContact.Trainer__c = NULL;
                         dfContact.Type_of_Champion__c = NULL;
                         dfContact.Partner_Organisation_ID__c = rec.DF_Contact__r.Partner_Organisation_ID__c; 
                     }
                     break;
                }
            }
            for (DF_EventAttendee__c dfCurrentEA: listCurrentEventAttendees)
            {
                //Compare Last Modified date on Event Attendee record AND the DF contact record.  If there has been a change on either raise an error and do not proceed.
                if (rec.Id == dfCurrentEA.Id){
                    if ((rec.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss.SSS') <> dfCurrentEA.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss.SSS'))||
                        (rec.DF_Contact__r.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss.SSS') <> dfCurrentEA.DF_Contact__r.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss.SSS'))){
                        system.debug ('££££££££££ record update clash ' + rec.id + ' ' + rec.DF_Contact__r.Name );
                        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'An error occurred while saving event attendees.: One or more records have been updated by another user.' + 
                                                                            ' Please re-display the records before editing again.') ;
                        ApexPages.addMessage(message);
                        return null;
                    }
                }   
                
            }
        }
        SavePoint sp=Database.setSavePoint();
        try{
            update listDFContacts;
            update listEventAttendees;
            return (new ApexPages.StandardController(dfEvent)).view();
        }
        catch (Exception ex){ 
                Database.rollback(sp);
                String msg=ex.getMessage();
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'An error occurred while saving event attendees.: ' + msg);
                ApexPages.addMessage(message);
                return null;
            }
    }

}