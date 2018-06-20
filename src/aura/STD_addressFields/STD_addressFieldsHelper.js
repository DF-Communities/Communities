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
                                console.log("Reading " + (isCustomCmp ? " custom " : "") + " component " + auraId + ": " + inputCmp.get("v.name"));
                            } else {
                                console.log("Reading " + (isCustomCmp ? " custom " : "") + " component " + auraId + ": " + inputCmp.get("v.label"));
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
                console.log("Address validation: " + inputCmpVal);
                if(inputCmpVal == null || $A.util.isUndefined(inputCmpVal) || inputCmpVal == "") {
                	// Detected untouched required field, fire error
                    inputCmp.set("v.errors", [{message: "This is a required field"}]);
                    isValid = false;	
                } else {
                    isValid = true;
                }
                
            } else { // lightning: component
                isValid = inputCmp.get("v.validity").isValid;
            }
        }
        console.log('Exit validity: ' + isValid);
        return isValid;
    },
    
    getAllParams : function(component) {
		
        // Initialise results map
        // params: contains all the inputs for this component
        // isValid: is used to allow idenfitication of which component is erroneous 
        var allCardParams = [];

        var areFieldsDefined = !$A.util.isUndefined(component.find("requiredInputField"));

        // Check all required lightning:input fields for validity 
        if(areFieldsDefined) {
            if(Array.isArray(component.find("requiredInputField"))) {

                var inputsAreValid = component.find("requiredInputField").reduce(function (inputsAreValid, inputCmp) {
                    console.log("Reading field: " + inputCmp.get("v.name"));
                    var cmpObj = {};
                    cmpObj.name = "" + inputCmp.get("v.name") + "";
                    cmpObj.params = inputCmp.get("v.value");
                    cmpObj.isValid = inputCmp.get("v.isValid") || inputCmp.get("v.validity").valueMissing;
                    allCardParams.push(cmpObj); 
                    
                    inputCmp.showHelpMessageIfInvalid();
                    return inputsAreValid && !inputCmp.get("v.validity").valueMissing;
                    
                }, true);
                
            } else {      
                console.log("looking at one requiredInputField");
                console.log("Reading field: " + component.find("requiredInputField").get("v.name"));
                var inputCmp = component.find("requiredInputField");
                
                var cmpObj = {};
                cmpObj.name = "" + inputCmp.get("v.name") + "";
                cmpObj.params = inputCmp.get("v.value");
                cmpObj.isValid = inputCmp.get("v.validity").valueMissing;
                allCardParams.push(cmpObj); 
            } 
    	} else {
            console.log('No requiredInputFields exist in ' + component.get("v.name"));
            var inputsAreValid = true;
        }
                
        // Check all child components for validity 
        var areChildCmpsDefined = !$A.util.isUndefined(component.find("childComponent"));
        if(areChildCmpsDefined) {

            if(Array.isArray(component.find("childComponent"))) {
                
                var childCmpsAreValid = component.find("childComponent").reduce(function (childCmpsAreValid, inputCmp) {
                    
                    console.log("RowitemCmp is reading component: " + inputCmp.get("v.name"));
                    var childValues = inputCmp.getAllParams();
                    allCardParams = allCardParams.concat(childValues);
                    
                    if(!childValues["isValid"]) {
                        console.log("invalid cmp: " + inputCmp.get("v.name"));
                    }
                    
                    return childCmpsAreValid && childValues["isValid"];        
             	}, true);
                
            } else if(areChildCmpsDefined) {
                
                console.log("Reading single component: " + component.find("childComponent").get("v.name"));
                var childValues = component.find("childComponent").getAllParams();
                console.log("out of r child compoennt");
                allCardParams = allCardParams.concat(childValues);
            }
            
        } else {   
            console.log('No childComponents exist in ' + component.get("v.name"));
            var childCmpsAreValid = true;   
        }
        
        if(!(inputsAreValid && childCmpsAreValid)) {
            console.log(component.get("v.name") + " IS INVALID");
        }
        
        // Return the input values of all the card children components
        console.log("+++ Leaving " + component.get("v.name") + " with: " + JSON.stringify(allCardParams));
        return allCardParams;
        
    }
})