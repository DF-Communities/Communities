public without sharing class Dfc_DAA_Region_TriggerHandler {
	
	public Dfc_DAA_Region_TriggerHandler() {
		
	}


	public void OnAfterInsert(DFC_DAA_Region__c[] itemsNew, Map<ID, DFC_DAA_Region__c> itemsNewMap){

		applyRegionId(itemsNew);
        applyRegionaLeadToCommunities(itemsNewMap);

    } 


 	public void OnAfterUpdate(DFC_DAA_Region__c[] itemsOld, Map<ID, DFC_DAA_Region__c> itemsOldMap, DFC_DAA_Region__c[] itemsNew, Map<ID, DFC_DAA_Region__c> itemsNewMap){

		applyRegionId(itemsNew);
		applyRegionaLeadToCommunities(itemsNewMap);

    } 

    /* Update DFC_Alliance records that have been imported but not yet allocated to a region */
    private void applyRegionId(DFC_DAA_Region__c[] itemsNew) {

    	List<String> lisRegionNames = new List<String>();

    	for ( DFC_DAA_Region__c region : itemsNew ) {

    		lisRegionNames.add(region.Name);

    	}

    	List<DFC_Alliance__c> lisToUpdate = new List<DFC_Alliance__c>();

    	List<DFC_Alliance__c> lisAlliances = 
                [select Id, Region__c, DAA_Region__c from DFC_Alliance__c where Region__c in: lisRegionNames ];

    	for ( DFC_DAA_Region__c region : itemsNew ) {

    		lisToUpdate.addAll(getAlliancesToUpdate(lisAlliances, region));
    	}

    	update lisToUpdate; 

    }


    private List<DFC_Alliance__c> getAlliancesToUpdate(List<DFC_Alliance__c> lisAlliances, DFC_DAA_Region__c region) {

    List<DFC_Alliance__c> lisToUpdate = new List<DFC_Alliance__c>();
     	for ( DFC_Alliance__c alliance : lisAlliances ) {

   			if ( (alliance.Region__c == region.Name) && (alliance.DAA_Region__c != region.Id) ) {
  				 alliance.DAA_Region__c = region.id;
  				 lisToUpdate.add(alliance);
    		}
    	
    	}

    	return lisToUpdate;  
    } 


    // Update the regional lead for Communities linkeed to a region 
    private void applyRegionaLeadToCommunities(Map<ID, DFC_DAA_Region__c> itemsNewMap) {
        
        Set<ID> ids = itemsNewMap.keySet();    

        List<DFC_Community__c> lisToUpdate = new List<DFC_Community__c>();
        List<DFC_Community__c> lisCommunities = [select id, Region__c, DAA_Regional_Lead__c from DFC_Community__c where Region__c in: ids];
        
        for ( DFC_Community__c community : lisCommunities ) {

          DFC_DAA_Region__c region = itemsNewMap.get(community.Region__c); 
          if (community.DAA_Regional_Lead__c != region.DAA_Regional_Lead__c) {
              community.DAA_Regional_Lead__c = region.DAA_Regional_Lead__c;
              lisToUpdate.add(community);
          }
        
        } 

        update lisToUpdate;
    }


    /*  July 16        
        These methods are based on the old process where all Communities were linked to a DAA. 
        As of July 2016 Communities may be non-geographic, or not have a DAA to link to (like Wales) 
        and they now have RegionId stored on the record

        ****
    
    private void applyDaaRegionalLead(DFC_DAA_Region__c[] itemsNew, Map<ID, DFC_DAA_Region__c> itemsOldMap) {

    	// Use the Text Name for the match so that new entries are captured
    	//   Alliances are imported with the String value of the region. Creating a new region
    	//   will apply the value to the Alliance
    	  
    	List<DFC_DAA_Region__c> lisUpdatedRegions = new List<DFC_DAA_Region__c>();

    	if ( itemsOldMap == null ) {

    		lisUpdatedRegions.addAll(itemsNew);

    	} else {


    		for ( DFC_DAA_Region__c region1 : itemsNew ) {

    			DFC_DAA_Region__c regionOld = itemsOldMap.get(region1.id);
    			if ( region1.DAA_Regional_Lead__c != regionOld.DAA_Regional_Lead__c ) {
    				lisUpdatedRegions.add(region1);
    			}

    		} 

    	} 

    	List<String> lisRegionNames = new List<String>(); 
    	for ( DFC_DAA_Region__c regionUpdated : lisUpdatedRegions ) {

    		lisRegionNames.add(regionUpdated.Name);

    	}

    	// Use Region Name, not ID to support newly imported Alliances, that were created with the text name of the 
        // region before the region record was created
    	List<DFC_Community__c> lisCommunities = 

                [SELECT Id, 
                        DA_Alliance__r.DAA_Region__c, 
                        DA_Alliance__r.Region__c, 
                        DAA_Regional_Lead__c 
                 FROM DFC_Community__c 
                 WHERE DA_Alliance__r.Region__c IN: lisRegionNames ];

    	List<DFC_Community__c> lisToUpdate = new List<DFC_Community__c>();

    	for (DFC_DAA_Region__c region : itemsNew) {

    		lisToUpdate.addAll(getCommunitiesToUpdate(lisCommunities, region));

    	}

    	update lisToUpdate;
    	

    }

    */

    /*
    private List<DFC_Community__c> getCommunitiesToUpdate(List<DFC_Community__c> lisCommunities, DFC_DAA_Region__c region) {

    	List<DFC_Community__c> lisToUpdate = new List<DFC_Community__c>();
    	for ( DFC_Community__c community : lisCommunities ) {

   			if ( (community.DA_Alliance__r.DAA_Region__c == region.Id) && 
                 (community.DAA_Regional_Lead__c != region.DAA_Regional_Lead__c) ) {
  				  community.DAA_Regional_Lead__c = region.DAA_Regional_Lead__c;
  				  lisToUpdate.add(community);
    		}
    	
    	} 

    	return lisToUpdate;
    }

    */

}