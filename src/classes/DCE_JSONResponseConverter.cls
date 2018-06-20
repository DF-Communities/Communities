public with sharing class DCE_JSONResponseConverter {
    
    private static map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    //private static map<String, Schema.SObjectField> OrgAmendmentFieldMap = globalDescribe.get('dce_orgamend__c').getDescribe().Fields.getMap();
    
    public static SObject DCE_JSONResponseConvertSingleRecord(string objectToConvertTo, map<string, string> fieldConversionMap, string JSONString){
    	
    	if(Schema.getGlobalDescribe().get(objectToConvertTo.toLowerCase()) == null){throw new DCE_Exception('SObject type does not exist in this Salesforce instance.');}
    	
    	SObject record = Schema.getGlobalDescribe().get(objectToConvertTo.toLowerCase()).newSObject();
    	return recordPopulator(record, fieldConversionMap, JSONString);
    }
    
	public static SObject DCE_JSONResponseConvertSingleRecord(SObject existingRecord, map<string, string> fieldConversionMap, string JSONString){
		return recordPopulator(existingRecord, fieldConversionMap, JSONString);
    }
    
    /*
    	Turns a JSON string from an API SOQL query into field values for a record. Arguments:
    	1) SObject record - The record with the values to be populated
    	2) fieldConversionMap - A map which converts field names from the source org into the field names of this org (needs a one-to-one mapping for each field)
    	3) The JSON string. It needs to be in the usual format from the REST API query.
    */
    private static SObject recordPopulator(SObject record, map<string, string> fieldConversionMap, string JSONString){
    	
    	set<string> fieldConversionMapValues = new set<string>();
    	
    	for(string s : fieldConversionMap.values()){
    		if(fieldConversionMapValues.contains(s)){
    			throw new DCE_Exception('The map passed in needs to have a different value for every key, otherwise the field mappings will fail. Please re-check the map passed in.');
    		}
    		
    		fieldConversionMapValues.add(s);
    	}
    	
    	string recordTypeName = record.getSObjectType().getDescribe().getName();
    	
    	map<String, Schema.SObjectField> ObjectFieldMap = globalDescribe.get(recordTypeName).getDescribe().Fields.getMap();
    	
    	map<string, Object> m;
    	
    	try{
    		m = (map<string, Object>)JSON.deserializeUntyped(JSONString);
    		system.debug('Here is the map - '+m);
    	} catch (exception e ){
    		throw new DCE_Exception('Passed in string may not have been JSON. Please check inputs.', e);
    	}
    		
    	list<Object> returnedJSONRecords = (list<Object>)m.get('records');
    	
    	if(returnedJSONRecords == null){ 
    		throw new DCE_Exception('JSON String received does not resolve to SObject records. Please check inputs.');
    	}
    	
    	if(returnedJSONRecords.size() == 0){
    		throw new DCE_Exception('Request did not return any records. Please check inputs.');
    	}
    	
    	if(returnedJSONRecords.size() != 1){
    		throw new DCE_Exception('Request returned multiple SObject records. Please check inputs.');
    	}
    	
    	map<string, Object> JSONrecord = (map<string, Object>)returnedJSONRecords[0];
    	
    	boolean JSONContainsSourceField = false;
    	
    	for(string key : JSONrecord.keySet()){
    		
    		system.debug('Here is the JSON Key - '+key);
    		
    		string localFieldName = fieldConversionMap.get(key);
    		
    		if(localFieldName == null){ continue; }
    		
    		if(!JSONContainsSourceField){JSONContainsSourceField = true; }
    		
    		system.debug('Here is the JSON Key mapped to the correct field - '+localFieldName);
    		
    		system.debug('Does this field exist - '+ObjectFieldMap.containsKey(localFieldName));
    		
    		if(!ObjectFieldMap.containsKey(localFieldName)){ continue; }
    		
    		object o = JSONrecord.get(key);
    		
    		system.debug('Here is the value - '+o);
    		
    		if(localFieldName == 'Id'){ continue; }
    		
    		if(o == null){ 
    			record.put(localFieldName, null);
    			continue; 
    		}
    		
    		system.debug('Keeping on');
    		
    		//Create a JSON parser, as that will allow us to cast to type dynamically later on. The row - "Object fieldVal = parser.readValueAs(t);" where t is the dynamic type
    		//If a better way comes up to dynamically cast, should use that instead.
    		//First need to turn the content into a JSON string. This is a bit long winded, but allows the system to cope with quotation marks, new line characters, etc.
    		JSONGenerator newJSON = JSON.createGenerator(false);
    		newJSON.writeStartObject();
    		newJSON.writeStringField('', string.valueOf(o));
    		newJSON.writeEndObject();
    		newJSON.close();
    		
    		system.debug('Here is the JSON string'+newJSON.getAsString());
    		
    		JSONParser parser = JSON.createParser(newJSON.getAsString());
    		
    		parser.nextToken();
    		parser.nextValue();
    		
    		schema.DisplayType thisType = ObjectFieldMap.get(localFieldName).getDescribe().getType();
    		
    		system.debug('HEre is the display type - '+thisType);
    		
    		//Converts the local field type into an Apex type, so we can place the value into the record with the correct type
    		if(!typeConverter.containsKey(thisType.name())){ continue; }
    		
    		Type t = typeConverter.get(thisType.name());
    		
    		try{
	    		system.debug('HEre is the Type - '+t);
	    		
	    		Object fieldVal = parser.readValueAs(t);
	    		
	    		//Strings need to be handled differently, as they may have had line breaks in them.
	    		if(fieldVal instanceof string){
					string sfieldVal = (string)fieldVal;
					system.debug('Here is what is going into the field - '+sfieldVal);
					
					record.put(localFieldName, sfieldVal);
	    		} else {
	    			record.put(localFieldName, fieldVal);
	    		}
    		} catch (exception e){
    			system.debug('Failure, why? - '+e);
    			//This will prevent the whole process failing due to a single field
    		}
    	}
    	
    	if(!JSONContainsSourceField){throw new DCE_Exception('The JSON supplied does not contain any fields that match with the target SObject. Please check that input.');}
    	
    	return record;
    }
    
    /*Converts field types (the keys) into apex types (the values)*/
    public static map<string, Type> typeConverter{
    	get{
    		if(typeConverter != null){ return typeConverter; }
    		
    		typeConverter = new  map<string, Type>();
    		typeConverter.put('CURRENCY',Decimal.class);
    		typeConverter.put('DATE',Date.class);
    		typeConverter.put('DATETIME',DateTime.class);
    		typeConverter.put('BOOLEAN',Boolean.class);
    		typeConverter.put('EMAIL',string.class);
    		typeConverter.put('ID',Id.class);
    		typeConverter.put('INTEGER',Integer.class);
    		typeConverter.put('MULTIPICKLIST',string.class);
    		typeConverter.put('PERCENT',Decimal.class);
    		typeConverter.put('PHONE',string.class);
    		typeConverter.put('PICKLIST',string.class);
    		typeConverter.put('REFERENCE',Id.class);
    		typeConverter.put('STRING',string.class);
    		typeConverter.put('TEXTAREA',string.class);
    		typeConverter.put('URL',string.class);
    		
    		return typeConverter;
    	}
    	
    	set;
    }
}