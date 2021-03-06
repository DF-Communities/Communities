({    
    validateFourCharsMin : function(component, event, helper) {
        
        var field = event.getSource();
        var entry = field.get("v.value");  
        var isValidRegex = /\w/.test(entry); 
        
        if($A.util.isUndefined(entry) || entry.length < 3) {
            field.set("v.errors", [{message:"Please provide the full name"}]);
            component.set("v.validMarshalName", false);
        } else if(!isValidRegex) {
            field.set("v.errors", [{message:"Please enter a valid name"}]);
            component.set("v.validMarshalName", false);
        } else {
            event.getSource().set("v.errors", null);
            component.set("v.validMarshalName", true);
        }
    },
    
    validateUkPhone : function(component, event, helper) {
        
        var enteredPhoneNum = event.getSource().get("v.value");
        var isValidRegex = /^(((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4}))|((\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?|(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3})$/.test(enteredPhoneNum);
        
        if(isValidRegex) {
            event.getSource().set("v.errors", null);
            component.set("v.validMarshalNum", true);
        } else {
            event.getSource().set("v.errors", [{message: "Please enter a valid UK phone number"}]);
            component.set("v.validMarshalNum", false);
        }
    },
    
    publishThirdPartySafetyMarshalInfo : function(component, event, helper) {
        
        var smEvent = component.getEvent("DF_thirdPartySafetyMarshalInfo");
        
        if(component.get("v.validMarshalName") && component.get("v.validMarshalNum")) {
            smEvent.setParams({"isComplete" : true});
        } else {
            smEvent.setParams({"isComplete" : false});
        }
        smEvent.fire();
    },
    
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
                            //console.log("Reading component " + auraId + ": " + inputCmp.get("v.name"));
                        } else {
                            //console.log("Reading component " + auraId + ": " + inputCmp.get("v.label"));
                        }
                        var isCmpValid = helper.assessComponent(inputCmp, isCustomCmp); 
                        return cumulativeValidity && isCmpValid;
                    }, true);
                    
                } else {  
                    //console.log("Reading only component " + auraId + ": " + cmpsToValidate.get("v.label"));
                    inputsAreValid = helper.assessComponent(cmpsToValidate, isCustomCmp);
                } 
                
            } else {
                //console.log("No components with aura:id " + obj.auraId + " rendered in " + component.get("v.name"));                
            }
        }
        
        //console.log("All required fields in component: '" + component.get("v.name") + "' are valid?: " + inputsAreValid);
        return inputsAreValid;
    },
    
    assessComponent : function(inputCmp, isCustomCmp) {
        
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
                    //console.log("Reading field: " + inputCmp.get("v.name"));
                    var cmpObj = {};
                    cmpObj.name = "" + inputCmp.get("v.name") + "";
                    cmpObj.params = inputCmp.get("v.value");
                    cmpObj.isValid = inputCmp.get("v.isValid") || inputCmp.get("v.validity").isValid;
                    allCardParams.push(cmpObj); 
                    
                    inputCmp.showHelpMessageIfInvalid();
                    return inputsAreValid && !inputCmp.get("v.validity").valueMissing;
                    
                }, true);
                
            } else {      
                //console.log("Reading field: " + component.find("requiredInputField").get("v.name"));
                var inputCmp = component.find("requiredInputField");
                
                var cmpObj = {};
                cmpObj.name = "" + inputCmp.get("v.name") + "";
                cmpObj.params = inputCmp.get("v.value");
                cmpObj.isValid = inputCmp.get("v.isValid") || inputCmp.get("v.validity").valueMissing;
                allCardParams.push(cmpObj); 
            } 
        } else {
            //console.log('No requiredInputFields exist in ' + component.get("v.name"));
            var inputsAreValid = true;
        }
        
        // Check all child components for validity 
        var areChildCmpsDefined = !$A.util.isUndefined(component.find("childComponent"));
        if(areChildCmpsDefined) {
            
            if(Array.isArray(component.find("childComponent"))) {
                
                var childCmpsAreValid = component.find("childComponent").reduce(function (childCmpsAreValid, inputCmp) {
                    
                    console.log("Reading component: " + inputCmp.get("v.name"));
                    var childValues = inputCmp.getAllParams();
                    
                    allCardParams.push(childValues);
                    if(!childValues["isValid"]) {
                        console.log("invalid cmp: " + inputCmp.get("v.name"));
                    }
                    
                    return childCmpsAreValid && childValues["isValid"];        
                }, true);
                
            } else if(areChildCmpsDefined) {
                
                var inputCmp = component.find("childComponent");
                console.log("Reading component: " + inputCmp.get("v.name"));
                var childValues = component.find("childComponent").getAllParams();
                allCardParams.push(childValues);
                
                childCmpsAreValid = childValues["isValid"];
                
                if(!childValues["isValid"]) {
                    console.log("invalid cmp: " + inputCmp.get("v.name"));
                }
            }
            
        } else {   
            console.log('No childComponents exist in ' + component.get("v.name"));
            var childCmpsAreValid = true;   
        }
        
        if(!(inputsAreValid && childCmpsAreValid)) {
            console.log(component.get("v.name") + " IS INVALID");
        }
        
        // Return the input values of all the card children components
        console.log("+++ Leaving " + "inSessionScheduling card " + " with: " + JSON.stringify(allCardParams));
        return allCardParams;
        
    }
})