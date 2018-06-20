global class BatchUpdateOldFriendCountsByChamps implements Database.Batchable<SObject>, Database.Stateful, Schedulable{
public String query;
 
        global void execute( SchedulableContext SC )
        {
          // batch run 
          BatchUpdateOldFriendCountsByChamps batch = new BatchUpdateOldFriendCountsByChamps();
          Database.executeBatch( batch, 4 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
        Id RT_CHAMPION = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
           
          query = 
                'Select Id, ' +
                'Total_No_of_Friends_Created__c, '+
                'Partner_Organisation_Id__c '+                              
                ' From ' +
                'DF_Contact__c ' +
                ' Where ' +
                'Partner_Organisation_Id__c !=  null and ' +
                'recordTypeId = :RT_CHAMPION and '+ 
                '(Total_No_of_Friends_Created__c!= 0 or ' +
                ' Total_No_of_Friends_Created__c!= null)' ;
                
    
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
         List<DF_Contact__c> liscon = new List<DF_Contact__c> ();
         Set <Id> partnerIds = new Set <Id>();
         
           for ( sObject s : scope ) {
              
              DF_Contact__c  dfc = (DF_Contact__c)s;
             
              liscon.add(dfc);
            }
            
          for(DF_Contact__c dfc : liscon){
            
            partnerIds.add(dfc.partner_organisation_id__c);
            
          }
          List<aggregateResult> PartnerOrganisationAgg =[SELECT partner_organisation_id__c
                                                           ,SUM(Total_No_of_Friends_Created__c) totalfriends
                                                           ,COUNT(id) champ 
                                                   FROM DF_contact__c 
                                                   WHERE RecordType_Name__c = 'Dementia Friend Champion' 
                                                   AND  partner_organisation_id__c in:partnerIds
                                                GROUP BY partner_organisation_id__c];
      
      Map<Id, Integer> partnerFriendsCount = new Map<Id, Integer>();
      Map<Id, Integer> partnerChampionsCount = new Map<Id, Integer>();
      
      IF (PartnerOrganisationAgg .size()>0){
        
        FOR (AggregateResult argRec : PartnerOrganisationAgg ){
            Double Total_No_of_Friends_CreatedDouble = (Double)argRec.get('totalfriends');
            Double Total_No_of_Champion_CreatedDouble = (Double)argRec.get('champ');
            
            partnerFriendsCount.put( (Id)argRec.get('partner_organisation_id__c') ,Total_No_of_Friends_CreatedDouble.IntValue());
            partnerChampionsCount.put((Id)argRec.get('partner_organisation_id__c') ,Total_No_of_Champion_CreatedDouble.intValue());
        
        }
      }
        
     for(Partner_Organisation__c partner:[select Number_Of_Friends_Created_By_Champions__c,Number_of_Champions_Identified__c,Id from Partner_Organisation__c where id in:partnerFriendsCount.keyset()]){
       
       partner.Number_Of_Friends_Created_By_Champions__c =partnerFriendsCount.get(partner.Id);
       partner.Number_of_Champions_Identified__c = partnerChampionsCount.get(partner.Id);
       listToUpdate.add(partner);
     }
     
     update listToUpdate;
    
   

         
         
        }
        
        global void finish(Database.BatchableContext BC)
        {
          // do something interesting
        }


    
}