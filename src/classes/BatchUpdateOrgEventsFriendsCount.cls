global without sharing class BatchUpdateOrgEventsFriendsCount implements Database.Batchable<SObject>, Database.Stateful,Schedulable{
public String query;
public String SESSION_RT = 'Dementia_Friend_Awareness_Session';
public Id RT= DF_Utils.getDfEventRecordTypeId(SESSION_RT);
 
        global void execute( SchedulableContext SC )
        {
          // batch run 
          BatchUpdateOrgEventsFriendsCount batch = new BatchUpdateOrgEventsFriendsCount();
          Database.executeBatch( batch, 20 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
        
           
          query = 
                'Select Id, ' +
                'Number_of_Attendees__c, '+
                'Partner_Organisation__c '+                              
                ' From ' +
                'DF_Event__c ' +
                ' Where ' +
                'Number_of_Attendees__c != 0 and '+
                'Partner_Organisation__c !=  null and ' +
                'recordTypeId = :RT';
                
    
            system.debug('+++Query+++'+ query);
            if(Test.isRunningTest())
                {
                    query += ' Limit 1';
                }

            return Database.getQueryLocator(query);
        }

        global void execute(Database.BatchableContext BC, List<SObject> scope)
        {
         List <Partner_Organisation__c> listToUpdate = new List <Partner_Organisation__c>();
         List<DF_Event__c> lisevent = new List<DF_Event__c> ();
         Set <Id> partnerIds = new Set <Id>();
         
           for ( sObject s : scope ) {
              
              DF_Event__c  event = (DF_Event__c)s;
             
              lisevent.add(event);
            }
            
          for(DF_Event__c  event : lisevent){
            
            partnerIds.add(event.partner_organisation__c);
            
          }
          List<aggregateResult> PartnerOrganisationAgg =[SELECT partner_organisation__c
                                                           ,SUM(Number_of_Attendees__c) totalfriends
                                                           ,COUNT(id) event 
                                                   FROM DF_Event__c 
                                                   WHERE RecordTypeId =: RT
                                                   AND Event_Status__c != 'Cancelled'  
                                                   AND  partner_organisation__c in:partnerIds
                                                GROUP BY partner_organisation__c];
          Map<Id, Integer> partnerFriendsCount = new Map<Id, Integer>();
      
      
        IF (PartnerOrganisationAgg .size()>0){
        
          for (AggregateResult argRec : PartnerOrganisationAgg ){
            Double Total_No_of_Friends_CreatedDouble = (Double)argRec.get('totalfriends');
            
            partnerFriendsCount.put( (Id)argRec.get('Partner_organisation__c') ,Total_No_of_Friends_CreatedDouble.IntValue());
           
           }
        }
      
      
      
     for(Partner_Organisation__c partner:[select Number_Of_Friends_By_Org_Sessions__c,Number_of_Champions_Identified__c,Id from Partner_Organisation__c where id in:partnerFriendsCount.keyset()]){
       
       partner.Number_Of_Friends_By_Org_Sessions__c =partnerFriendsCount.get(partner.Id);
       listToUpdate.add(partner);
       
     }
    
     //update orgs
       if(listToUpdate.size()>0){
          update listToUpdate;
        }
     }
        
    global void finish(Database.BatchableContext BC)
    {
          // do something interesting
     }


    
}