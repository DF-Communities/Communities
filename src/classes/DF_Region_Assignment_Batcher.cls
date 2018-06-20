/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Batch Class to update region postcodes
 *  Author  : Gary Grant
 *  Date    : June 2015
 *  Version : 0.1 Unit Test
 *
 *  Description:    Batch update for linking DFCs to Regions
 *               
 *  Modification History
 *  Date            Who       Description 
 *  
*******************************************************************************************/

global class DF_Region_Assignment_Batcher implements Database.Batchable<sObject> {
    
    global String query;
    global Map<String, String> mapPostCodes;
    global Integer i;
    
    global DF_Region_Assignment_Batcher(Map<String, String> mapPostCodes) {

        this.mapPostCodes = mapPostCodes;
        i = 0;

        Integer c = 1;
        String RT_CHAMPION = DF_Utils.getDfcRecordTypeId(DF_UTILS.RT_CHAMPION);
        
        query = 'SELECT id, Postcode_Sector__c, DF_Region__c from DF_Contact__c where ' +
                ' ( ' + 
                ' ( RecordTypeId =\'' +  RT_CHAMPION + '\' and Status__c != \'' +  DF_Utils.STATUS_PROSPECTIVE + '\' )' +  
                ' OR ' +
                ' ( RecordTypeId !=\'' +  RT_CHAMPION + '\' and Total_No_of_Completed_Info_Sessions__c > 0 )' +  
                ' ) ' +
                ' and Postcode_Sector__c in (' ;
        
                for (String sPostCode : mapPostCodes.keySet()) { 

                    query = query + '\'' + sPostCode + '\'';
                    if (c < mapPostCodes.keySet().size()) { 
                        query = query + ',';
                    }            
        
                    c++;
                }
        
        query = query + ')';
        system.debug('Query = ' + query);
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    
        List<DF_Contact__c> lis = new List<DF_Contact__c>();

        for (sObject o : scope) {

            DF_Contact__c dfc = (DF_Contact__c)o;
            system.debug('Batch Executing :' + dfc.id);

            String sRegionId = mapPostCodes.get(dfc.Postcode_Sector__c);

            if (dfc.DF_Region__c != sRegionId) {

                dfc.DF_Region__c = sRegionId;
                lis.add(dfc);
                i++;

            }

        }

        update lis;

    }


    
    global void finish(Database.BatchableContext BC) {

        system.debug('DF_Region_Assignment_Batcher records updated :' + i );
        
    }


    
}