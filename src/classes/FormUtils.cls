public class FormUtils {
    
	public static List<SelectOption> getPicklistSelectOptions(sObject sObjectInstance, String fieldApiName) {
        
        
        //Map<String, String> optionMap = new Map<String, String>(); 
        System.debug('Entered getInfoSessionTypesForPicklist');
        List<SelectOption> allOptions = new List<SelectOption>();
           System.debug(sObjectInstance);
        // Get the object schema
        Schema.sObjectType objType = sObjectInstance.getSObjectType();
        System.debug(objType);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        System.debug(objDescribe);
        // Get the field schema
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        System.debug('getMaps: ' + fieldMap);
        List<Schema.PicklistEntry> picklistVals = fieldMap.get(fieldApiName).getDescribe().getPickListValues();
        System.debug('picklistvals: ' + picklistVals);
        for(Schema.PicklistEntry field : picklistVals) {
            allOptions.add(new SelectOption(field.getValue(), field.getValue()));
        }
        
        return allOptions;
    }
    
    /*@AuraEnabled
    public static List<String> getPicklistOptions(sObject sObjectInstance, String fieldApiName) {
        //Map<String, String> optionMap = new Map<String, String>(); 
        System.debug('Entered getInfoSessionTypesForPicklist');
        List<String> allOptions = new List<String>();
           
        // Get the object schema
        Schema.sObjectType objType = sObjectInstance.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get the field schema
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List<Schema.PicklistEntry> picklistVals = fieldMap.get(fieldApiName).getDescribe().getPickListValues();

        for(Schema.PicklistEntry field : picklistVals) {
            allOptions.add(field.getValue());
        }
        
        return allOptions;
    }*/
}