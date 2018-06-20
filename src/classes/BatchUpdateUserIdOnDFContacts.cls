global class BatchUpdateUserIdOnDFContacts implements Database.Batchable<SObject>, Database.Stateful, Schedulable

 // Batch class to update df contacts with portal user
    {
    public String query;
 
        global void execute( SchedulableContext SC )
        {
          // batch run 
          BatchUpdateUserIdOnDFContacts batch = new BatchUpdateUserIdOnDFContacts();
          Database.executeBatch( batch, 4 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
      
           
          query = 
                'Select Id, ' +
                'Portal_User__c, ' +
                'Portal_Contact__c, '+
                'ownerid '+
                ' From ' +
                'DF_Contact__c ' +
                ' Where ' +
                'Portal_User__c !=  null ' +
                'and Portal_Contact__c !=  null';
                
    
            system.debug('+++Query+++'+ query);
            if(Test.isRunningTest())
                {
                    query += ' Limit 1';
                }

            return Database.getQueryLocator(query);
        }

        global void execute(Database.BatchableContext BC, List<SObject> scope)
        {
           Map<Id,Id> dfContactIdMap = new Map<Id,Id>();                  
           List<Df_Contact__c> lis = new List<DF_Contact__c>();
           List<Df_Contact__c> listoUpdate = new List<DF_Contact__c>();
           Set<Id> dfContactIdSet = new Set<Id>();
           system.debug('+++dfContactIdSet+++'+ dfContactIdSet);
           
            for ( sObject s : scope ) {
              
              DF_Contact__c  dfc = (DF_Contact__c)s;
             
              if(dfc.ownerid!=dfc.portal_user__c){
                  dfc.ownerid=dfc.Portal_user__c;
                listoUpdate.add(dfc);
            }
            }
             
           
           
            update listoUpdate;
            
        }


        global void finish(Database.BatchableContext BC)
        {
          // do something interesting
        }
    }