public with sharing class DCE_OrgAmendWrapper extends DCE_ControllerUtils{
    
    public DCE_OrgAmend__c partner{get; set;}
    private static map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    private static map<String, Schema.SObjectField> OrgAmendmentFieldMap = globalDescribe.get('dce_orgamend__c').getDescribe().Fields.getMap();
    
    public static string fieldsOfInterestProduction{
    	get{
    		if(fieldsOfInterestProduction != null){ return fieldsOfInterestProduction; }
    			
    		fieldsOfInterestProduction = '';
    		
    		for(string s : productionToPortalFieldMap.keySet()){
    			fieldsOfInterestProduction += s+',';
    		}
    		
    		fieldsOfInterestProduction = fieldsOfInterestProduction.substring(0, fieldsOfInterestProduction.length()-1);
    		
    		return fieldsOfInterestProduction;
    	}
    	
    	private set;
    }
    
    public static string fieldsOfInterestLocal{
    	get{
    		if(fieldsOfInterestLocal != null){ return fieldsOfInterestLocal; }
    			
    		fieldsOfInterestLocal = '';
    		
    		for(string s : productionToPortalFieldMap.values()){
    			fieldsOfInterestLocal += s+',';
    		}
    		
    		fieldsOfInterestLocal = fieldsOfInterestLocal.substring(0, fieldsOfInterestLocal.length()-1);
    		
    		return fieldsOfInterestLocal;
    	}
    	
    	private set;
    }
    
    private static map<string, string> productionToPortalFieldMap{
    	get{
    		if(productionToPortalFieldMap != null){ return productionToPortalFieldMap; }
    		
    		productionToPortalFieldMap = new map<string, string>();
    		
    		productionToPortalFieldMap.put('Id', 'OrganisationId__c');
    		productionToPortalFieldMap.put('Name', 'Name__c');
    		productionToPortalFieldMap.put('Office_Contact_Hours__c', 'Office_Contact_Hours__c');
    		productionToPortalFieldMap.put('Phone', 'Phone__c');
    		productionToPortalFieldMap.put('BillingStreet', 'BillingStreet__c');
    		productionToPortalFieldMap.put('BillingCity', 'BillingCity__c');
    		productionToPortalFieldMap.put('BillingState', 'BillingState__c');
    		productionToPortalFieldMap.put('BillingCountry', 'BillingCountry__c');
    		productionToPortalFieldMap.put('BillingPostalCode', 'BillingPostalCode__c');
    		
    		return productionToPortalFieldMap;
    	}
    	
    	set;
    }
    
    public static map<string, string> PortalToProductionFieldMap{
    	public get{
    		if(PortalToProductionFieldMap != null){ return PortalToProductionFieldMap; }
    		
    		PortalToProductionFieldMap = new map<string, string>();
    		
    		for(string s : productionToPortalFieldMap.keySet()){
    			
    			string value = productionToPortalFieldMap.get(s);
    			
    			PortalToProductionFieldMap.put(value, s);
    		}
    		
    		return PortalToProductionFieldMap;
    	}
    	
    	private set;
    }
    
    public DCE_OrgAmendWrapper(string JSONString){
    	
    	partner = (DCE_OrgAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('dce_orgamend__c', productionToPortalFieldMap, JSONString);
    	partner.Organisation__c = currentUser.AccountId;
    	partner.Status__c = 'Draft';
    }
    
    public DCE_OrgAmendWrapper(string JSONString, SObject existingRecord){
    	
    	partner = (DCE_OrgAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord(existingRecord, productionToPortalFieldMap, JSONString);
    	partner.status__c = 'Draft';
    	//partner.Organisation__c = currentUser.AccountId;
    }
}