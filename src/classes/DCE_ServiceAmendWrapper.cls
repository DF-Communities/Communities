public without sharing class DCE_ServiceAmendWrapper extends DCE_ControllerUtils{
    
	private static map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    private static map<String, Schema.SObjectField> ServiceAmendmentFieldMap = globalDescribe.get('dce_serviceamend__c').getDescribe().Fields.getMap();
    
    public static set<string> editingStatuses = new set<string>{'Draft', 'In Approval', 'Accepted - Pending Transfer'};
    
    @testVisible private static map<string, string> productionToPortalFieldMap{
    	get{
    		if(productionToPortalFieldMap != null){ return productionToPortalFieldMap; }
    		
    		productionToPortalFieldMap = new map<string, string>();
    		
    		productionToPortalFieldMap.put('Id', 'serviceid__c');
    		productionToPortalFieldMap.put('Portal_ID__c', 'Id');
    		productionToPortalFieldMap.put('Name', 'Name');
    		productionToPortalFieldMap.put('service_type__c', 'service_type__c');
    		productionToPortalFieldMap.put('service_description__c', 'service_description__c');
    		productionToPortalFieldMap.put('Opening_Times_Guidebook__c', 'Opening_Times_Guidebook__c');
    		productionToPortalFieldMap.put('service_email__c', 'service_email__c');
    		productionToPortalFieldMap.put('service_telephone__c', 'service_telephone__c');
    		productionToPortalFieldMap.put('Secondary_telephone_number__c', 'Secondary_telephone_number__c');
    		productionToPortalFieldMap.put('Street_Line_1__c', 'Street_Line_1__c');
    		productionToPortalFieldMap.put('Street_Line_2__c', 'Street_Line_2__c');
    		productionToPortalFieldMap.put('Street_Line_3__c', 'Street_Line_3__c');
    		productionToPortalFieldMap.put('Street_Line_4__c', 'Street_Line_4__c');
    		productionToPortalFieldMap.put('service_street__c', 'service_street__c');
    		productionToPortalFieldMap.put('service_street__c', 'service_street__c');
    		productionToPortalFieldMap.put('service_city__c', 'service_city__c');
    		productionToPortalFieldMap.put('service_county__c', 'service_county__c');
    		productionToPortalFieldMap.put('service_postcode__c', 'service_postcode__c');
    		productionToPortalFieldMap.put('service_country__c', 'service_country__c');
    		productionToPortalFieldMap.put('Additional_Information__c', 'Additional_Information__c');
    		productionToPortalFieldMap.put('Funder_restriction__c', 'Funder_restriction__c');
    		productionToPortalFieldMap.put('Getting_There__c', 'Getting_There__c');
    		productionToPortalFieldMap.put('National_Service__c', 'National_Service__c');
    		productionToPortalFieldMap.put('Operated_By__c', 'Operated_By__c');
    		productionToPortalFieldMap.put('Parking__c', 'Parking__c');
    		productionToPortalFieldMap.put('Price__c', 'Price__c');
    		productionToPortalFieldMap.put('Primary_Contact_External__c', 'Primary_Contact_External__c');
    		productionToPortalFieldMap.put('Referral_only__c', 'Referral_only__c');
    		productionToPortalFieldMap.put('Refreshments__c', 'Refreshments__c');
    		productionToPortalFieldMap.put('Last_Reviewed__c', 'LastReviewed__c');
    		productionToPortalFieldMap.put('Toilet_Facilities__c', 'Toilet_Facilities__c');
    		productionToPortalFieldMap.put('Accessibility__c', 'Accessibility__c');
    		productionToPortalFieldMap.put('service_website__c', 'service_website__c');
    		productionToPortalFieldMap.put('Advertising_Start_Date__c', 'Advertising_Start_Date__c');
    		productionToPortalFieldMap.put('Advertising_end_date__c', 'Advertising_end_date__c');
    		productionToPortalFieldMap.put('service_closedate__c', 'service_closedate__c');
    		productionToPortalFieldMap.put('Service_Criteria__c', 'Service_Criteria__c');
    		productionToPortalFieldMap.put('service_status__c', 'service_status__c');
    		productionToPortalFieldMap.put('Service_Reference__c', 'Service_Reference__c');
    		productionToPortalFieldMap.put('Days__c', 'Days__c');
    		productionToPortalFieldMap.put('Recurrence__c', 'Recurrence__c');
    		productionToPortalFieldMap.put('Start_time_Hours__c', 'Start_time_Hours__c');
    		productionToPortalFieldMap.put('Start_time_Minutes__c', 'Start_time_Minutes__c');
    		productionToPortalFieldMap.put('End_time_Hours__c', 'End_time_Hours__c');
    		productionToPortalFieldMap.put('End_time_Minutes__c', 'End_time_Minutes__c');
    		productionToPortalFieldMap.put('Opening_times_Other__c', 'Opening_times_Other__c');
    		productionToPortalFieldMap.put('Further_contact_requirements__c', 'Further_contact_requirements__c');
    		productionToPortalFieldMap.put('Reach__c', 'Reach__c');
    		productionToPortalFieldMap.put('Where_does_this_service_operate__c', 'Where_does_this_service_operate__c');
    		
    		return productionToPortalFieldMap;
    	}
    	
    	set;
    }
    
    public static string fieldsOfInterest{
    	get{
    		if(fieldsOfInterest != null){ return fieldsOfInterest; }
    		
    		fieldsOfInterest = '';
    		
    		for(string s : productionToPortalFieldMap.keySet()){
    			fieldsOfInterest += s+', ';
    		}
    		
    		fieldsOfInterest = fieldsOfInterest.substring(0, fieldsOfInterest.length()-2);
    		
    		return fieldsOfInterest;
    	}
    	
    	private set;
    }
    
    public static map<string, string> portalToProductionFieldMap{
    	public get{
    		if(portalToProductionFieldMap != null){ return portalToProductionFieldMap;}
    		
    		portalToProductionFieldMap = new map<string, string>();
    		
    		for(string s : productionToPortalFieldMap.keySet()){
    			string value = productionToPortalFieldMap.get(s);
    			
    			portalToProductionFieldMap.put(value, s);
    		}
    		
    		return portalToProductionFieldMap;
    	}
    	
    	private set;
    }
    
    public static string fieldsOfInterestPortal{
    	get{
    		if(fieldsOfInterestPortal != null){ return fieldsOfInterestPortal; }
    		
    		fieldsOfInterestPortal = '';
    		
    		for(string s : portalToProductionFieldMap.keySet()){
    			fieldsOfInterestPortal += s+', ';
    		}
    		
    		fieldsOfInterestPortal = fieldsOfInterestPortal.substring(0, fieldsOfInterestPortal.length()-2);
    		
    		return fieldsOfInterestPortal;
    	}
    	
    	private set;
    }
    
    public DCE_ServiceAmend__c amend{get; set;}
    
    /*This constructor will create a service Amendment record from a JSON string*/
    public DCE_ServiceAmendWrapper(string JSONString){
    	
    	amend = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('dce_serviceamend__c', productionToPortalFieldMap, JSONString);
    	
    	system.debug('Here is the amendment with details - '+amend);
    	
    	if(amend==null){
    		system.debug('Error');
    		//displayPageError('No record can be found. Please check your URL and try again.');
    	} else {
	    	amend.DCEPartner__c = currentUser.AccountId;
	    	amend.ServiceOwner__c = currentUser.id;
	    	amend.Status__c = 'Draft';
    	}
    }
    
    public DCE_ServiceAmendWrapper(string JSONString, SObject existingRecord, string mode){
    	
    	amend = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord(existingRecord, productionToPortalFieldMap, JSONString);
    	
    	system.debug('Here is the amendment with details - '+amend);
    	
    	if(amend==null){
    		system.debug('Error');
    		//displayPageError('No record can be found. Please check your URL and try again.');
    	} else {
	    	if(mode=='edit'){
	    		amend.ServiceOwner__c = currentUser.id;
	    		amend.Status__c = 'Draft';
	    	}
    	}
    }
    
    //private static map<String, Schema.SObjectField> externalServiceFieldMap = globalDescribe.get('services_c__x').getDescribe().Fields.getMap();
    /*This constructor will create a service Amendment record from a provided Service from Dementia Connect
    public DCE_ServiceAmendWrapper(Services_c__x externalService){
    	
    	amend = new DCE_ServiceAmend__c();
    	
    	system.debug('externalServiceFieldMap - '+externalServiceFieldMap);
        system.debug('ServiceAmendmentFieldMap - '+ServiceAmendmentFieldMap);
        
        if (externalServiceFieldMap != null &&  ServiceAmendmentFieldMap != null){
        	
        	for (Schema.SObjectField ft : externalServiceFieldMap.values()){
        		
        		system.debug('ft - '+ft);
        		
        		Schema.DescribeFieldResult fd = ft.getDescribe();
        		
        		string externalName = fd.getName();
        		
        		system.debug('externalName - '+externalName);
        		
        		// Some fields we don't want to copy to the amendment
        		if(fieldsNotToCopy.contains(externalName)){ continue; }
        		
        		string amendName;
        		
        		if(externalName.contains('_c__c')){
        			amendName = externalName.replace('_c__c','__c');
        		} else if(externalName.contains('__c')) {
        			amendName = externalName.replace('__c','');
        		}
        		
        		system.debug('Amend Name - '+amendName);
        		
        		system.debug('ServiceAmendmentFieldMap.containsKey(amendName) - '+ServiceAmendmentFieldMap.containsKey(amendName));
        		
        		if(!ServiceAmendmentFieldMap.containsKey(amendName)){ continue; }
        		
        		Schema.DescribeFieldResult fdAmend = ServiceAmendmentFieldMap.get(amendName).getDescribe();
        		
        		system.debug('ServiceAmendmentFieldMap.get(amendName).getDescribe() - '+ServiceAmendmentFieldMap.get(amendName).getDescribe());
        		
        		system.debug('fd.getType() - '+fd.getType());
        		system.debug('fdAmend.getType() - '+fdAmend.getType());
        		
        		if(fd.getType() == fdAmend.getType() || (fieldTypeMappings.get(fdAmend.getType().name()) != null && fieldTypeMappings.get(fdAmend.getType().name()).contains(fd.getType().name()))){ 
        		
	        		system.debug('fdAmend.isUpdateable() - '+fdAmend.isUpdateable());
	        		
	        		if(!fdAmend.isUpdateable()){ continue; }
	        		
	        		system.debug('Putting in this value - '+externalService.get(fd.getName()));
	        		
	        		amend.put(amendName, externalService.get(fd.getName()));
        		}
        	}
        }
    }*/  
    
    //private static set<string> fieldsNotToCopy = new set<string>{'id','createdbbByid','createddate','lastmodifiedbyid','lastmodifieddate','systemmodstamp','service_reference__c', 'recordtypeId'};
    
	/*This map allows certain field types in External Objects to be moved into the objects in this one
    private static map<string, set<string>> fieldTypeMappings{
    	
    	private get{
    		if(fieldTypeMappings != null){ return fieldTypeMappings;}
    		
    		fieldTypeMappings = new map<string, set<string>>();
    		
    		fieldTypeMappings.put('PICKLIST', new set<string>{'STRING'});
    		
    		return fieldTypeMappings;
    	}
    	
    	private set;
    
    }*/
}