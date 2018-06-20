public class STD_DynamicLightningUtils {
    
    /*
     * Method that populates the lightning STD_dynamicPicklist component from the underlying
     * Salesforce field's schema
     */ 
    @AuraEnabled
    public static List<String> getPicklistOptions(sObject sObjectApiName, String fieldApiName) {

        List<String> allOptions = new List<String>();
        
        // Get the object schema
        Schema.sObjectType objType = sObjectApiName.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        // Get the field schema
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List<Schema.PicklistEntry> picklistVals = fieldMap.get(fieldApiName).getDescribe().getPickListValues();

        for(Schema.PicklistEntry field : picklistVals) {
            //optionMap.put(field.getLabel(), field.getValue());
            allOptions.add(field.getValue());
        }
        
        return allOptions;
    }
}