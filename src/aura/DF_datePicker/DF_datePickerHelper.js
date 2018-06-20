({
	validateComponentHelper : function(component, event, helper) {
        return helper.visitEverySpecifiedComponentByAuraId(component, event, helper, "verifyRequiredFieldsArePopulated");
    },
    
    visitEverySpecifiedComponentByAuraId : function(component, event, helper, operationName) {
        
        var auraIdsToValidateObjArr = component.get("v.auraIdsToValidate");
        var outcome = true;
        
        for(var key in auraIdsToValidateObjArr) {
            
            var obj = auraIdsToValidateObjArr[key];
            var auraId = obj.auraId;
            var isCustomCmp = obj.isCustomCmp;
            var cmpsToValidate = component.find(String(auraId)); 
            var areFieldsDefined = !$A.util.isUndefined(cmpsToValidate);
            var singletonTest;
            
            // Check all required lightning:input fields for validity
            if(areFieldsDefined) {                
                if(Array.isArray(cmpsToValidate)) {
                    
                    outcome = cmpsToValidate.reduce(function (outcomeSoFar, cmpInFocus) {
                        var operationOutcome = helper.performOperation(component, event, helper, auraId, cmpInFocus, isCustomCmp, operationName);
                        outcomeSoFar = outcomeSoFar && operationOutcome;
                    }, true);
                    
                } else {  
                    var operationOutcome = helper.performOperation(component, event, helper, auraId, cmpsToValidate, isCustomCmp, operationName);
                    outcome = outcome && operationOutcome;
                } 
                
            } else {
                console.log("No components with aura:id " + obj.auraId + " rendered in " + component.get("v.name"));                
            }
        }
        
        console.log(operationName + " operation completed on specified fields in component: '" + component.get("v.name") + "' with the outcome: " + outcome);
        return outcome;
    },
    
    performOperation : function(component, event, helper, auraId, cmpInFocus, isCustomCmp, operationName) {

        var singletonTest;
        if($A.util.isUndefined(cmpInFocus.get("v.label"))) {
            console.log("Reading component " + auraId + ": " + cmpInFocus.get("v.name"));
        } else {
            console.log("Reading component " + auraId + ": " + cmpInFocus.get("v.label"));
        }
        
        if(isCustomCmp) {
            // Search recursively into nested component 
            singletonTest = cmpInFocus.validateRequiredFields(); 
        } else {
            // Perform the actual operation on the ui: or lightning: base components 
            singletonTest = helper.operationsLibrary(helper, cmpInFocus, operationName);
        }
        
        return singletonTest;
    },
    
    operationsLibrary : function(helper, cmpInFocus, operationName) {
        
        if(operationName == "verifyRequiredFieldsArePopulated") {
            return helper.verifyRequiredFieldsArePopulated(helper, cmpInFocus);
        } else if(operationName == "disableComponents") {
            return helper.disableComponents(helper, cmpInFocus);
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
        
        return isValid;
    }
})