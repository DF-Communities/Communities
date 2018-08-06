public with sharing class DCE_Dashboard_Controller extends DCE_ControllerUtils{
    
    public void initiation(){
    	loginRedirect();
    	services = services;
    	//initiateServices();
    	
    	/*
    	if(pageMessage != null){
    		displayPageMessage = true;
    		
    	}*/
    }
	
	public list<serviceHolder> services {
    	public get{
    		if(services != null){ return services; }
    		
    		//First query live Salesforce for the latest versions of all this partner's services
    		string queryEndPoint = WEBC_CommunityWrapper.getCustomSetting('RestEndpoint','DCE')+'/services/data/v35.0/query';
			queryEndPoint += '?q='+EncodingUtil.urlEncode('select id, Name, Service_Type__c, last_reviewed__c, Service_Reference__c, service_status__c from Services__c where Operated_By__c = \''+CRSAccountId+'\'', 'UTF-8'); //where Operated_By__c = \'0013E000001QUSy\'
			
			DCE_RestConnector restConnection = new DCE_RestConnector(queryEndPoint, 'GET');
			
			if(restConnection != null && restConnection.res != null){ system.debug('Here is the response body - '+restConnection.res.getbody()); }
			
			if(restConnection.restError){
				
				displayPageError(restConnection.restErrorMessage);
				return null;
			} else {
				
				map<string, Object> m = (map<string, Object>)JSON.deserializeUntyped(restConnection.res.getbody());
	    		
	    		system.debug('Here is the map - '+m);
	    		
	    		//Here are the returned records from live
	    		list<Object> returnedRecords = (list<Object>)m.get('records');
	    		
	    		services = new list<serviceHolder>();
	    		
	    		list<DCE_ServiceAmend__c> notYetInPortal = new list<DCE_ServiceAmend__c>();
	    		
	    		for(Object o : returnedRecords){
	    			map<string, Object> rMap = (map<string, Object>)o;
	    			
	    			system.debug('rMap.get(Id) - '+rMap.get('Id'));
	    			system.debug('rMap for this record - '+rMap);
	    			system.debug('Existing Amendment - '+amendmentMap.get((string)rMap.get('Id')));
	    			
	    			//Get the version of the amend that is in the portal
	    			DCE_ServiceAmend__c amend = amendmentMap.get((string)rMap.get('Id'));
	    			
	    			//If there isn't a version in the portal, create a basic version of it now
	    			if(amend == null){
	    				
	    				system.debug('No existing amendment in the portal');
	    				
	    				amend = new DCE_ServiceAmend__c(Name = (string)rMap.get('Name'), ServiceId__c = (string)rMap.get('Id'), Status__c='Accepted - Transfer Complete', DCEPartner__c=userWithDCEDetails.AccountId, ServiceOwner__c=userWithDCEDetails.id, Operated_By__c = CRSAccountId);
	    					
	    				amend.service_type__c = rMap.get('service_type__c') == null ? null : (string)rMap.get('service_type__c'); 
	    				amend.lastReviewed__c = rMap.get('Last_Reviewed__c') == null ? null : Date.valueOf((string)rMap.get('Last_Reviewed__c'));
	    				amend.service_status__c = rMap.get('service_status__c') == null ? null : (string)rMap.get('service_status__c');
	    				amend.service_reference__c = rMap.get('Service_Reference__c') == null ? null : (string)rMap.get('Service_Reference__c');
	    					
	    				notYetInPortal.add(amend);
	    				continue;
	    			}
	    			
	    			services.add(new serviceHolder((string)rMap.get('Name'), (string)rMap.get('Id'), (string)rMap.get('service_type__c'), (string)rMap.get('service_status__c'), amend));//, amendmentMap.containsKey((string)rMap.get('Id'))
	    		}
	    		
	    		if(notYetInPortal.size() > 0){
    				
    				system.debug('WE NEED TO ADD - '+notYetInPortal);
    				
    				list<Database.SaveResult> results = database.insert(notYetInPortal, false);
    				system.debug('Save result size - '+results);
    				
    				for(integer i = 0 ; i <results.size() ; i++){
    					
    					system.debug('Here is the save result - '+results[i]);
    					
    					Database.SaveResult result = results[i];
    					
    					if(result.isSuccess()){
    						
    						system.debug('Success');
    							
    						DCE_ServiceAmend__c amend = notYetInPortal[i];
    						
    						services.add(new serviceHolder(amend.Name, amend.ServiceId__c, amend.service_type__c, amend.service_status__c, amend));
    						
    						system.debug('services after adding new - '+services);
    					}
    					
    				}
    			}
			}
		
			//Pick up the amendments in the system that aren't yet in Dementia Connect
			for(DCE_ServiceAmend__c amend : Amendments){
				
				system.debug('Cycling through existing - '+amend);
				
				if(amend.ServiceId__c == null){
					
					system.debug('Not yet in the portal');
					
					services.add(new serviceHolder(amend.Name, null, amend.service_type__c, '', amend));
				}
			}
    		
    		if((services == null || services.size() == 0)){
    			displayPageSuccess('Your organisation does not currently have any services listed. If you would like to create one, start by clicking the "New service" button.');
    		}
    		
    		system.debug('services - '+services);
    		return services;
    	}
    	
    	private set;
	}
    
    /*A map of the services in the portal, keyed by their LIVE Id*/
    public map<string, DCE_ServiceAmend__c> amendmentMap{
    	public get{
    		if(amendmentMap != null){ return amendmentMap; }
    		
    		amendmentMap = new map<string, DCE_ServiceAmend__c>();
    		
    		for(DCE_ServiceAmend__c sa : Amendments){
    			if(sa.ServiceId__c != null){ amendmentMap.put(sa.ServiceId__c, sa); }
    		}
    		
    		return amendmentMap;
    	}
    	
    	private set;
    }
    
    /*The record for the partner account in the portal*/
    public Account partnerAccount{
    	public get{
    		if(partnerAccount != null){ return partnerAccount;}
    		
    		partnerAccount = [select id, Name,billingstreet, billingcity,billingstate,billingcountry,billingPostalCode,Phone
    							from Account
    							where id = :userWithDCEDetails.accountId];
    		
    		
    		system.debug('Here is the partner account - '+partnerAccount);
    		
    		return partnerAccount;
    	}
    	
    	private set;
    }
    
    public DCE_Dashboard_Controller(){
    	//services = services;
    }
    
    /*Wrapper class to display the Services on the page*/
    public class serviceHolder{
    	
		public string Name{get;set;}
		public string Id{get;set;}
		public string serviceType{get; set;}
		public DCE_ServiceAmend__c amend{get; set;}
        public string liveServiceStatus{get; set;}
        
        /*public boolean hasDraft{get; set;}
        public string status{get; set;}*/
    	
    	public serviceHolder(string Name, string Id, string ServiceType, string liveServiceStatus, DCE_ServiceAmend__c amend){
    		this.Name = Name;
    		this.Id = Id;
    		this.serviceType = serviceType;
    		this.liveServiceStatus = liveServiceStatus;
            
            this.amend = (amend != null) ? amend : new DCE_ServiceAmend__c(status__c ='Live');
    	}
    	
    }
    
    /*public string getBaseUrl(){
    	return system.URL.getSalesforceBaseUrl().ToExternalForm();
    }
    
    public string getBaseUrlHost(){
    	return system.URL.getSalesforceBaseUrl().getHost();
    }*/
    
    
}