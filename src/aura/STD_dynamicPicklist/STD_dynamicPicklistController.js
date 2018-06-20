({
    setStylingFramework : function(component, event, helper) {
    	var useSlds = event.getParam("useSlds");
        component.set("v.useSlds", useSlds);
    },
    
    validateComponent : function(component, event, helper) {
        var auraId = "requiredInputField";
        return helper.assessComponent(component, false, auraId);   
    },
    
    validateUntouchedPicklist : function(component, event, helper) {
        helper.validateUntouchedPicklist(component, event, helper);
    },
    
	doInit : function(component, event, helper) {
        // Pull out the picklist options based upon the provided parameters 
        
        var optionValueLabelMapList = component.get("v.optionValueLabelMapList");
        var sObjectApiName = component.get("v.sObjectApiName");
        var sObjectFieldApiName = component.get("v.sObjectFieldApiName");
        
		var isPicklistItemsSpecified = !$A.util.isUndefined(optionValueLabelMapList);
		var isObjectSpecified = !$A.util.isUndefined(sObjectApiName);	
        var isFieldSpecified = !$A.util.isUndefined(sObjectFieldApiName);	
        
        if(isPicklistItemsSpecified && isObjectSpecified && isFieldSpecified) {
            // Create the picklist items from the field meta data
            helper.getPicklistOptionsFromMetadata(component);
        } else if(!isPicklistItemsSpecified && (!isObjectSpecified || !isFieldSpecified)) {
            // No parameters have been defined, create a place holder only
        }
	},
    
    validateAndGetParams : function(component, event, helper) {
    	console.log("Getting all parameters from " + component.get("v.name"));
      	return helper.getAllParams(component);  
    },
    
    publishSelection : function(component, event, helper) {
        
        helper.validateUntouchedPicklist(component, event, helper);
        component.set("v.value", event.getSource().get("v.value"));
    }
})