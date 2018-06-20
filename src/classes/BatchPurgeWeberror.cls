/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Batch APEX Class to to delete weberror records that are older than 30 days.
 *  Author  : Mike Tinson
 *  Date    : 25-06-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Batch APEX Class to delete weberror records that are older than 30 days.
 *                  
 *
 *        //Called via the Execute Anonymous window. 
 *        BatchPurgeWeberror webErrBatch = new BatchPurgeWeberror ();
 *        webErrBatch.query = 'Select name, id from weberror_record__c where owner.name=\'Mike Tinson\' and name >=\'WE-16122014-3002\' and name < \'WE-16122014-3010\'';
 *        //Invoke the Batch class.
 *        ID batchprocessid = Database.executeBatch(webErrBatch, 20);
 *                  
 *  Modification History
 *  Date            Who         Description 
 *                     
*******************************************************************************************/
global class BatchPurgeWeberror implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable 
{
Public string query;
Private string defaultQuery = 'Select name, id from weberror_record__c where  CreatedDate < LAST_N_DAYS:45 limit 50000';


global Database.QueryLocator start(Database.BatchableContext BC)
   {
    String queryCmd;
    if (query==null) {
    queryCmd = defaultQuery;
    }
    else {
    queryCmd = query;
    }
    return Database.getQueryLocator(queryCmd);
   }
global void execute(Database.BatchableContext BC, List<sObject> scope)
    {

    List<WEBError_Record__c> webErrRec = new List<WEBError_Record__c>();
    List<WEBError_Record_Detail__c> webErrDetailRec = new List<WEBError_Record_Detail__c>();
    Set<WEBError_Record__c> WebErrSet = new Set<WEBError_Record__c>();

    for(sObject s : scope){
        WEBError_Record__c wErrRec = (WEBError_Record__c)s;
        webErrRec.add(wErrRec);
    }
    System.Debug('webErrRec Size = ' + webErrRec.size());
    WebErrSet.addAll(webErrRec);
    //get associated details records
    webErrDetailRec = [select name, id from WEBError_Record_Detail__c where WEBError_Record__c in :WebErrSet];
    
     Savepoint sp = Database.setSavepoint();
       Boolean hasDMLExceptionRaised=false;
    //now delete the web errors and associated details
     try{
    
        delete webErrDetailRec;
        delete webErrRec;
     }
     catch(Exception ex){hasDMLExceptionRaised=true;}
          // Revert the database to the original state on Exception
      if(hasDMLExceptionRaised)
      {
        Database.rollback(sp); 
      }
  
    }
 
global void finish(Database.BatchableContext BC)
    {
       
    
    }
 global void execute(SchedulableContext SC) 
  {
      BatchPurgeWeberror batchPurge = new BatchPurgeWeberror();
      Database.executeBatch(batchPurge,20);
  }
}