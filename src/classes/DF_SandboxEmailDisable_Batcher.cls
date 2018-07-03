global class DF_SandboxEmailDisable_Batcher implements Database.Batchable<sObject> {
    
    String query;
    Integer i;
    
    global DF_SandboxEmailDisable_Batcher() {
    
        query = 'select id, email__c from DF_Contact__c where not Email__c like \'%.uat\'';
        i = 0;

    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    

        List<DF_Contact__c> lis = new List<DF_Contact__c>();

        for (Object o : scope) {

            DF_Contact__c dfc = (DF_Contact__c)o;

            if ( dfc.Email__c.length() < 76 ) {

	            if (!dfc.Email__c.endsWith('.uat')) {

	                dfc.Email__c = dfc.Email__c + '.uat';
	                lis.add(dfc);
	                i++;
	            }

        	}

        }

        update lis;

    }
    
    global void finish(Database.BatchableContext BC) {

        system.debug('DF Contact Email Disabler updated : ' + i);
        
    }
    
}