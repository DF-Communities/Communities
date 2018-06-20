/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : This class sends emails to DCE users where their org has services due a review. It's batchable, because we're assuming that the portal will be a BIG DEAL one day.
 *            
 *  Author  : Andy Rouse
 *  Date    : 02-2016
 *  Version : 1.0
 *
 *  Description:
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/

public with sharing class DCE_EmailServiceDigest_Batcher implements Database.Batchable<SObject>{
    
    private string query;
    
    public static integer EMAIL_BATCH_SIZE = 60;
    
    private string PSName = DCE_ControllerUtils.DCE_PERMISSION_SET_NAME; //Need to bring this variable into the class, so it is visible to the dynamic SOQL below.
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
    	
    	string query = 'Select id, FirstName, LastName from User where isActive = true and ID IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :PSName) and AccountId IN (Select DCEPartner__c from DCE_ServiceAmend__c where service_status__c = \'Open\' and (LastReviewed__c = null or (LastReviewed__c < LAST_N_MONTHS:9 and LastReviewed__c >= LAST_N_MONTHS:15 ) ) )';
    	
    	if(test.isRunningTest()){
    		query += ' LIMIT '+EMAIL_BATCH_SIZE;
    	}
    	
    	return Database.getQueryLocator(query);
    }
    
    public void execute (Database.BatchableContext BC, List<SObject> scope) {
    	DCE_MailUtils.monthlyMailDigest(scope);
    }
    
    public void finish(Database.BatchableContext bc){
    	
    }
    
}