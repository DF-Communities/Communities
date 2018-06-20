public without sharing class Dfc_ActionArea_TriggerHandler {
	

	public Dfc_ActionArea_TriggerHandler() {
		
	}
	
	public void OnAfterInsert(List<DFC_Action_Area__c> lisUpdated){
		
		handleNewActionArea(lisupdated);
		
	}
	
	
	public void OnBeforeUpdate(List<DFC_Action_Area__c> lisOldActionArea,List<DFC_Action_Area__c> lisUpdated,Map<Id,DFC_Action_Area__c> oldActionAreaMap){
		
		handleNewActionArea(lisupdated);
		
	}

	private void handleNewActionArea(List<DFC_Action_Area__c> lisUpdated) {


		List<DFC_Community_Action_Area__c> lisToAdd = new List<DFC_Community_Action_Area__c>();

		List<DFC_Community__c> communities = [select id, (select id, Action_Area__c from Action_Areas__r) from DFC_Community__c];
		
		// Loop all the updated DFC_Action_Area__c
		for ( DFC_Action_Area__c area : lisUpdated ) {


			// For this Area, loop all Communities (watch max batch size here....)
			for ( DFC_Community__c community : communities ) {

				Set<String> existingList = new Set<String>();				

				// For this Community, loop the DFC_Community_Action_Areas__c
				for ( DFC_Community_Action_Area__c caa : community.Action_Areas__r ) {

					 // Capture which action areas already exist
					 existingList.add(caa.Action_Area__c);	

				}

				// if the area does not exist for this community, create it and add it to the list
				if ( !existingList.contains(area.id) ) {

					DFC_Community_Action_Area__c caa = new DFC_Community_Action_Area__c();
					caa.Action_Area__c = area.Id;
                 	caa.Community__c = community.Id;
                 	lisToAdd.add(caa);

				}


			}

		} 

		insert lisToAdd;

	}


}