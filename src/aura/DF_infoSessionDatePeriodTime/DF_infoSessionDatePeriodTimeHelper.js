({

    
	validateComponentHelper : function(component, event, helper) {
        
        var auraIdsToValidateObjArr = component.get("v.auraIdsToValidate");
        var inputsAreValid = true;
        for(var key in auraIdsToValidateObjArr) {
            
            var obj = auraIdsToValidateObjArr[key];
            var auraId = obj.auraId;
            var isCustomCmp = obj.isCustomCmp;
            var cmpsToValidate = component.find(String(auraId)); 
            var areFieldsDefined = !$A.util.isUndefined(cmpsToValidate);

            // Check all required lightning:input fields for validity
            if(areFieldsDefined) {                
                if(Array.isArray(cmpsToValidate)) {
                        
                    	inputsAreValid = cmpsToValidate.reduce(function (cumulativeValidity, inputCmp) {
                            if($A.util.isUndefined(inputCmp.get("v.label"))) {
                            	console.log("Reading component " + auraId + ": " + inputCmp.get("v.name"));
                            } else {
                                console.log("Reading component " + auraId + ": " + inputCmp.get("v.label"));
                            }
                            var isCmpValid = helper.assessComponent(inputCmp, isCustomCmp); 
                            return cumulativeValidity && isCmpValid;
                        }, true);
                    
                } else {  
                    console.log("Reading only component " + auraId + ": " + cmpsToValidate.get("v.label"));
                    inputsAreValid = helper.assessComponent(cmpsToValidate, isCustomCmp);
                } 

            } else {
                console.log("No components with aura:id " + obj.auraId + " rendered in " + component.get("v.name"));                
            }
        }
        
        console.log("All required fields in component: '" + component.get("v.name") + "' are valid?: " + inputsAreValid);
        return inputsAreValid;
    },
       
    assessComponent : function(inputCmp, isCustomCmp) {

        var isValid;
        if(isCustomCmp) {
            isValid = inputCmp.validateRequiredFields();
        } else {
            if($A.util.isUndefined(inputCmp.get("v.name"))) {  // ui: component
                var inputCmpVal = inputCmp.get("v.value");
                console.log("+++ inputCmpVal: " + inputCmpVal + " " + inputCmp.get("v.label"));
                if(inputCmpVal == null || $A.util.isUndefined(inputCmpVal) || inputCmpVal == "") {
                	// Detected untouched required field, fire error
                	console.log("SET A@N E@RRO@RS THEN");
                    inputCmp.set("v.errors", [{message: "This is a required field"}]);
                    isValid = false;	
                } else {
                    isValid = (inputCmp.get("v.errors") == null) ? true : false;
                }
                
            } else { // lightning: component
                isValid = inputCmp.get("v.validity").isValid;
            }
        }
        return isValid;
    },
    
    fireCmpSelectionEvt : function(isValid, params) {
        // Initialise the entry to being invalid
        var evt = component.getEvent("DF_rowItemDetailEvt");
        evt.setParams({
            "isValid": isValid,
            "params": params
        });
        evt.fire();
        
        var a = component.get('c.validateTimeEntry');
        $A.enqueueAction(a);
    }

})