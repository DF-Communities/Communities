window._extJsFormValidation = (function(component, event, helper) {
    
    return {
        
        getCompName: function(component) {
            return component.get("v.name");
            
        },
        
        validateComponentHelper : function(component, event, helper, auraIdsToValidate) {
            return this.visitEverySpecifiedComponentByAuraId(component, event, helper, auraIdsToValidate, "verifyRequiredFieldsArePopulated");
        },
        
        visitEverySpecifiedComponentByAuraId : function(component, event, helper, auraIdsToValidate, operationName) {
            
        var inputsAreValid = true;
        for(var key in auraIdsToValidate) {
            
            var obj = auraIdsToValidate[key];
            var auraId = obj.auraId;
            var isCustomCmp = obj.isCustomCmp;
            var cmpsToValidate = component.find(String(auraId)); 
            var areFieldsDefined = !$A.util.isUndefined(cmpsToValidate);

            // Check all required lightning:input fields for validity
            if(areFieldsDefined) {   
                var cumulativeCmpTypeValidity = true;
                console.log('Preloop: inputsAreValid for key: ' + obj + ' is: ' + inputsAreValid);
                if(Array.isArray(cmpsToValidate)) {
                        
                    	cumulativeCmpTypeValidity = cmpsToValidate.reduce(function (cumulativeValidity, inputCmp) {
                            if($A.util.isUndefined(inputCmp.get("v.label"))) {
                            	console.log("Reading component " + auraId + ": " + inputCmp.get("v.name"));
                            } else {
                                console.log("Reading component " + auraId + ": " + inputCmp.get("v.label"));
                            }
                            var isCmpValid = this.assessComponent(inputCmp, isCustomCmp); 
                            return cumulativeValidity && isCmpValid;
                        });
                    
                } else {  
                    console.log("Reading only component " + auraId + ": " + cmpsToValidate.get("v.label"));
                    cumulativeCmpTypeValidity = this.assessComponent(cmpsToValidate, isCustomCmp);
                } 
                
                console.log('Post loop: cumulativeCmpTypeValidity for key: ' + obj + ' is: ' + cumulativeCmpTypeValidity);
                inputsAreValid = cumulativeCmpTypeValidity && inputsAreValid;
                console.log('Post loop: inputsAreValid for key: ' + obj + ' is: ' + inputsAreValid);

            } else {
                console.log("No components with aura:id " + obj.auraId + " rendered in " + component.get("v.name"));                
            }
        }
        
        console.log("Exiting section validity with: " + inputsAreValid);
        return inputsAreValid;
        },
        
        assessComponent : function(inputCmp, isCustomCmp) {

        var isValid;
        if(isCustomCmp) {
            isValid = inputCmp.validateRequiredFields();
        } else {
            if($A.util.isUndefined(inputCmp.get("v.name"))) {  // ui: component
                var inputCmpVal = inputCmp.get("v.value");
                console.log('INPUTCMPVAL: ' + inputCmpVal);
                console.log('inputCmpVal == null: ' + (inputCmpVal == null));
                console.log('inputCmpVal == "": ' + (inputCmpVal == ""));
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
        return isValid;
    },
    
        
        performOperation : function(component, event, helper, auraId, cmpInFocus, isCustomCmp, operationName) {
            
            var singletonTest;
            var cmpSpecificMessage;
            if($A.util.isUndefined(cmpInFocus.get("v.label"))) {
                cmpSpecificMessage = "Operating on component " + auraId + ": " + cmpInFocus.get("v.name");
            } else {
                cmpSpecificMessage = "Operating on component " + auraId + ": " + cmpInFocus.get("v.label");
            }
            console.log(cmpSpecificMessage);
            
            if(isCustomCmp) {
                // Search recursively into nested component 
                singletonTest = cmpInFocus.validateRequiredFields(); 
            } else {
                // Perform the actual operation on the ui: or lightning: base components 
                singletonTest = this.operationsLibrary(helper, cmpInFocus, operationName);
            }
            
            if($A.util.isUndefined(singletonTest)) {
                console.log("WARNING: Could not get a boolean test outcome for: " + cmpSpecificMessage);
            }
            
            return singletonTest;
        },
        
        operationsLibrary : function(helper, cmpInFocus, operationName) {
            
            if(operationName == "verifyRequiredFieldsArePopulated") {
                return this.verifyRequiredFieldsArePopulated(helper, cmpInFocus);
            } else if(operationName == "disableComponents") {
                return this.disableComponents(helper, cmpInFocus);
            }
            
        },
        
        disableComponents : function(helper, cmpInFocus) {
            // Both ui: and lightning: components have a disabled attribute
            var isOperationSuccessful;
            if($A.util.isUndefined(cmpInFocus.get("v.disabled"))) {
                console.log("No disabled attribute found on current cmp. " +
                            "This is due to attempting to validate non lightning (ui: or lightning: ) markup.");
                isOperationSuccessful = false;
            } else {
                cmpInFocus.set("v.disabled", true);
                isOperationSuccessful = true;
            }
            return true;
        },
        
        verifyRequiredFieldsArePopulated : function(helper, cmpInFocus) {
            
            var isValid;
            if($A.util.isUndefined(cmpInFocus.get("v.validity"))) {  // ui: component
                var focusCmpVal = cmpInFocus.get("v.value");
                
                if(focusCmpVal == null || $A.util.isUndefined(focusCmpVal) || focusCmpVal == "") {
                    // Detected untouched required field, fire error
                    cmpInFocus.set("v.errors", [{message: "This is a required field"}]);
                    isValid = false;	
                } else {
                    isValid = (cmpInFocus.get("v.errors") == null) ? true : false;
                }
                
            } else { // lightning: component
                isValid = cmpInFocus.get("v.validity").isValueMissing;
            }
            console.log("Result: " + isValid);
            return isValid;
        }
        
    };
    
    
}());