global without sharing class DF_RegionStats_Process_Batcher implements Database.Batchable<sObject>,Schedulable{
    
    global String query;
    global Integer i;

    global DF_RegionStats_Process_Batcher() {
        
        query='select id, name from DF_Region__c';
        i=0;

    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {


        DF_RegionStats_Processor proc = new DF_RegionStats_Processor();
        
        for (sObject o : scope) {

            DF_Region__c region = (DF_Region__c)o;            
            proc.processStats(region);                
            i++;
        }
        
        proc.doUpdate();

    }
    
    global void finish(Database.BatchableContext BC) {

        system.debug('DF_RegionStats_Process_Batcher records updated :' + i );
        
    }
    
     global void execute(SchedulableContext sc) {

        DF_RegionStats_Process_Batcher batcher = new DF_RegionStats_Process_Batcher();
        database.executebatch(batcher);

    }


}