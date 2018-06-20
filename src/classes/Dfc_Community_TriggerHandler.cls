/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX DFC Community Trigger Handler
 *
 *            Dementia Friendly Communities that have a central location need to be first approved by the 'Regional Lead'
 *            for the associated Dementia Action Alliance  (DFC_Alliance__c)

 *            Each Dementia Action Alliance belongs to a Region and the DAA Region record specifies
 *            the user who is the Regional Lead  (DAA_Regional_Lead__c)
 *
 *  Author  : Gary Grant
 *  Date    : 4/1/2015
 *  Version : 0.1 Unit Test
 *  
 *               
 *  Modification History
 *  Date            Who         Description 
 *
*******************************************************************************************/

public without sharing class Dfc_Community_TriggerHandler {
	

	public Dfc_Community_TriggerHandler() {

    System.debug('Dfc_Community_TriggerHandler()');
		
	}

	public void OnBeforeInsert(DFC_Community__c[] itemsNew, Map<ID, DFC_Community__c> itemsNewMap){

		applyRegionalLead(itemsNew);

   }

 	public void OnBeforeUpdate(DFC_Community__c[] itemsOld, Map<ID, DFC_Community__c> itemsOldMap, 
                               DFC_Community__c[] itemsNew, Map<ID, DFC_Community__c> itemsNewMap){

		applyRegionalLead(itemsNew);

  }

  /*
   *  If the Community is Submitted for recognition, the status is changed from Draft to Requested
   */

  public void onAfterUpdate(DFC_Community__c[] itemsOld, Map<ID, DFC_Community__c> itemsOldMap, 
                            DFC_Community__c[] itemsNew, Map<ID, DFC_Community__c> itemsNewMap) {
    
        System.debug('================= in onAfterUpdate method of Dfc_Community_TriggerHandler');

        for ( DFC_Community__c item : itemsNew ) {

           System.debug('=================' + item.Name__c);

            DFC_Community__c itemOld = itemsOldMap.get(item.Id);
            if ( item.Status__c == 'Requested' && itemOld.Status__c == 'Draft') {

                System.debug('=================  submitIntoApproval' + item.Name__c);

                submitIntoApproval(item);

            }
        }
    }

  public void onAfterInsert(DFC_Community__c[] itemsNew){
  	
  	populateActionAreas(itemsNew);
  }

  private void submitIntoApproval(DFC_Community__c community) {

        /// Create an approval request for the Community
        Approval.ProcessSubmitRequest asr = new Approval.ProcessSubmitRequest();
        asr.setObjectId(community.Id);

        System.debug('======================= Submitting community '+community.Name__c + community.Name__c + ' for approval');
        //asr.setComments('======================= Submitting community  request for approval.');

    
        //  Need to handle the case where the user record for the user doing the approval is Inactive
        //  Process failed. First exception on row 0; first error: MANAGER_NOT_DEFINED, Manager undefined.: []
        try {
              Approval.ProcessResult result = Approval.process(asr);
 
        } catch (Exception ex) {
            system.debug('ERROR SUBMITTING APPROVAL: ' + ex);
            // send an error to the administrators
/*
            ApexPages.addMessages(e);

             Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
             String[] toAddresses = new String[] {'developer@acme.com'};
             mail.setToAddresses(toAddresses);
             mail.setReplyTo('developer@acme.com');
             mail.setSenderDisplayName('Apex error message');
             mail.setSubject('Error from Org&nbsp;: ' + UserInfo.getOrganizationName());
             mail.setPlainTextBody(e.getMessage());
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */

        }

    }

    /* Where the Community has a central location, Update the Regional Lead field on the Community record 
     * based on the Community Region. This name is required for the approval process
     */
    private void applyRegionalLead(DFC_Community__c[] communities) {


        System.debug('================= Apply Regional Lead');

      // Get a map of all Regions and their Regional Leads (bulkification)
      Map <Id, DFC_DAA_Region__c> mapRegions = new 
      Map <Id, DFC_DAA_Region__c>( [SELECT Id, DAA_Regional_Lead__c FROM DFC_DAA_Region__c] );

      // For each DFC Community, if there is a Central Location and the Region is populated, update the Regional Lead field
      for (DFC_Community__c community : communities) {

        if ( community.Central_Location__c !='No' && community.Region__c != null ) {

          DFC_DAA_Region__c region = mapRegions.get(community.Region__c);

          if ( region != null ) {
            community.DAA_Regional_Lead__c = region.DAA_Regional_Lead__c;

          } 
        }
      }

/*

      // Get a map of all Dementia Action Alliances and their Regional Leads (bulkification)
      Map<Id, DFC_Alliance__c> mapAlliances = new 
      Map<Id, DFC_Alliance__c>([SELECT Id, DAA_Region__r.DAA_Regional_Lead__c FROM DFC_Alliance__c]);

      // For each DFC Community, if the Alliance is populated, update the Regional Lead field
    	for (DFC_Community__c community : communities) {

    		if ( community.DA_Alliance__c != null ) {

    			DFC_Alliance__c alliance = mapAlliances.get(community.DA_Alliance__c);

    			if ( alliance != null ) {
    				community.DAA_Regional_Lead__c = alliance.DAA_Region__r.DAA_Regional_Lead__c;

    			}	
    		}
    	}

      */

    }

    private void populateActionAreas(DFC_Community__c[] communities){
    
     DFC_Action_Area__c[] actionAreas =  [SELECT Name, Id FROM DFC_Action_Area__c where Active__c = true order by Sequence__c ASC];
     
     List<String> ids = new List<String>();
     for ( DFC_Community__c community : communities ) { ids.add(community.id); }

     DFC_Community_Action_Area__c[] commActionAreas =  [SELECT Name, Id, Action_Area__c, Community__c FROM DFC_Community_Action_Area__c where Community__c in:ids ];

     Map<String, DFC_Community_Action_Area__c> mapCommAreas = new Map<String, DFC_Community_Action_Area__c>();
     
     for ( DFC_Community_Action_Area__c commArea : commActionAreas ) { 

        String key = commArea.Community__c + '~' + commArea.Action_Area__c;
        mapCommAreas.put(key, commArea);
     
     }

     List < DFC_Community_Action_Area__c> lisToInsert = new List< DFC_Community_Action_Area__c>();
      
     for (DFC_Community__c community : communities) {
            
        for (DFC_Action_Area__c area : actionAreas) {     
      
          String key = community.id + '~' + area.id; 
          if ( mapCommAreas.get(key) == null ) { 

               DFC_Community_Action_Area__c caa = new DFC_Community_Action_Area__c();
               caa.Action_Area__c = area.Id;
               caa.Community__c = community.Id;
               lisToInsert.add(caa);

          }
      
        }               
    }
    
    insert lisToInsert;
    
    }
    
    /*
    private void populateActionAreas(DFC_Community__c[] communities){
    
     DFC_Action_Area__c[] actionAreas =  [SELECT Name, Id FROM DFC_Action_Area__c where Active__c = true order by Sequence__c ASC];
      List < DFC_Community_Action_Area__c> lisToInsert = new List< DFC_Community_Action_Area__c>();
      
      for (DFC_Community__c community : communities) {
      	
      	if(community.Number_Of_Action_Areas__c ==0){
          for (DFC_Action_Area__c area : actionAreas) {   	
    		
    		
    		
    			 DFC_Community_Action_Area__c caa = new DFC_Community_Action_Area__c();
                 caa.Action_Area__c = area.Id;
                 caa.Community__c = community.Id;
                 lisToInsert.add(caa);
    			
    			
    		}
    	}
    }
    
    insert lisToInsert;
    }
  */
}