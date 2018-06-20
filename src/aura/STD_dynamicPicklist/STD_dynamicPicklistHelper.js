({
    assessComponent : function(component, isCustomCmp, auraId) {

        var inputCmp = component.find(String(auraId));
        var isValid;
        if(isCustomCmp) {
            isValid = inputCmp.validateRequiredFields();
        } else {
            if($A.util.isUndefined(inputCmp.get("v.name"))) {  // ui: component
                var inputCmpVal = inputCmp.get("v.value");
                if(inputCmpVal == null || $A.util.isUndefined(inputCmpVal) || inputCmpVal == "") {
                	// Detected untouched required field, fire error
                    inputCmp.set("v.errors", [{message: "This is a required field"}]);
                    isValid = false;	
                } else {
                    isValid = (inputCmp.get("v.errors") == null) ? true : false;
                }
                
            } else { // lightning: component
                isValid = inputCmp.get("v.validity").isValid;
            }
        }
        console.log("All required fields in component : '" + component.get("v.name") + "' are valid?: " + isValid);
        return isValid;
    },
    
    validateUntouchedPicklist : function(component, event, helper) {
        if(component.get("v.required")) {
            if(event.getSource().get("v.value") == "") {
                event.getSource().set("v.errors", [{message: "Selection is required"}]);
            } else {
                event.getSource().set("v.errors", null);
            }
        }
    },
    
    getPicklistOptionsFromMetadata : function(component) {

        var sObjectApiName = component.get("v.sObjectApiName");
        var fieldApiName = component.get("v.sObjectFieldApiName");
        
        var action = component.get("c.getPicklistOptions"); // This is the apex controller method
        
        sObjectApiName = "{sobjectType : '" + sObjectApiName + "'}";
        
        action.setParams({"sObjectApiName": sObjectApiName,
                          "fieldApiName": fieldApiName});
            
        var picklistOptions = [];
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            
            if(state==="SUCCESS") {

                var returnedOptions = response.getReturnValue();

				// Set the default "please select" option
                if(returnedOptions != undefined && returnedOptions.length > 0) {
                    picklistOptions.push({
                        class: "optionClass",
                        label: "",
                        value: "Please select..."
                    });
                }

                for (var i = 0; i < returnedOptions.length; i++) {
                    picklistOptions.push({
                        class: "optionClass",
                        label: returnedOptions[i],
                        value: returnedOptions[i]
                    });
                }
                component.set("v.optionValueLabelMapList", picklistOptions);
                
            } else if(state==="ERROR"){

                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message) {
                        console.log('Error is: ' + errors[0].message);
                    } else {
                        console.log('Unknown error');
                    }
                }                
            }
        });
        
		$A.enqueueAction(action);        
        
    },
    
    getAllParams : function(component) {
        
        var allCardParams = {}
        allCardParams.name = component.get("v.name");
        allCardParams.params = component.get("v.value");
        allCardParams.isValid = (allCardParams.params != "Please select") ? true : false;
        return allCardParams;
        
    }
})