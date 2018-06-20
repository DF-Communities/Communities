/*
* 2014-06-03 : CSL : This code will be used to clean up DF_Contact__c records
* by making sure all records with a 'Name' field of the Record ID are set to 
* First Name +  ' ' + Last Name
*
*/

global with sharing class DFContactCleanup implements Database.Batchable <Sobject> {

	global String query {get; set;}
	global List<DF_Contact__c> saveList = new List<DF_Contact__c>();
	
	//Note - the query will be set when the code is called from an Execute Anonymous window
	//But will be set to [select d.Id, d.Name, d.First_Name__c, d.Last_Name__c from DF_Contact__c d where d.CreatedById = API PUBLIC USER ID];
	global Database.querylocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext info, List<Sobject> scope){
		system.debug('*** -- About to process ' + scope.size() + ' records in BatchContactCreate.execute -- ***');

		for (SObject s : scope){
			DF_Contact__c dfc = (DF_Contact__c) s;
			String checkName = dfc.First_Name__c + ' ' + dfc.Last_Name__c;
			if (dfc.Name != checkName){
				dfc.Name = checkName;
				saveList.add(dfc);
			}	
		}
		
		//Save the records
		system.debug('*** -- About to save ' + saveList.size() + ' records -- ***');
		update saveList;
				
	}
	
	global void finish(Database.BatchableContext BC){
		//This method has intentionally been left blank
	}

}