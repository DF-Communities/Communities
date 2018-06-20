({
    initiateRowAddOrRemove : function(component, event, helper, isNewRow) {
        
        // Get event and set the parameter of Aura:component type, as defined in the event above.
        var compEvent = $A.get("e.c:STD_dynCreateComponentEvt");
        compEvent.setParams({"isCreateNewComponent": isNewRow,
                             "cmpRowNo": component.get("v.totalNoRows"),
                             "entireRowCmp": component});
        compEvent.fire();
        // Increment the total row count to show the correct icon
    },
    
    publishSelection : function(component, fieldApiName, fieldApiValue) {

        var isString = (typeof(fieldApiValue) === "String") ? true : false;
        
        var evt = component.getEvent("DF_infoSessionTimePreferenceEvt");
        if(isString) {
            evt.setParams({
                "fieldApiName" : fieldApiName,
                "fieldValueStr" : fieldApiValue
            });
        } else {
            evt.setParams({
            "fieldApiName" : fieldApiName,
            "fieldValueDate" : fieldApiValue
        });
        }
        evt.fire();
    },
    
    lockRow : function(component, event, helper) {
        // Loop through all fields and and disable events on them
        return helper.visitEverySpecifiedComponentByAuraId(component, event, helper, "disableComponents");
    },
    
    validateRow : function(component, event, helper) {
        return helper.visitEverySpecifiedComponentByAuraId(component, event, helper, "verifyRequiredFieldsArePopulated");
    },
    
    validateComponentHelper : function(component, event, helper) {
        return helper.visitEverySpecifiedComponentByAuraId(component, event, helper, "verifyRequiredFieldsArePopulated");
    },
    
    visitEverySpecifiedComponentByAuraId : function(component, event, helper, operationName) {
        
        var auraIdsToValidateObjArr = component.get("v.auraIdsToValidate");
        var outcome = true; // Pass if component has no required fields
        
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
                        return outcomeSoFar && operationOutcome;
                    }, true);

                } else {  
                    var operationOutcome = helper.performOperation(component, event, helper, auraId, cmpsToValidate, isCustomCmp, operationName);
                    outcome = outcome && operationOutcome;
                } 
                
            } else {
                console.log("No components with aura:id " + obj.auraId + " rendered in " + component.get("v.name"));                
            }
        }
        
        console.log(operationName + " operation completed on specified fields in component: '" 
                    + component.get("v.name") 
                    + "' with the outcome: " + outcome);
        return outcome;
    },
    
    performOperation : function(component, event, helper, auraId, cmpInFocus, isCustomCmp, operationName) {

        var singletonTest;
        var cmpSpecificMessage;
        if($A.util.isUndefined(cmpInFocus.get("v.label"))) {
            cmpSpecificMessage = "Operating on component " + auraId + ": " + cmpInFocus.get("v.name");
        } else {
            cmpSpecificMessage = "Operating on component " + auraId + ": " + cmpInFocus.get("v.label");
        }
        
        if(isCustomCmp) {
            // Search recursively into nested component 
            singletonTest = cmpInFocus.validateRequiredFields(); 
        } else {
            // Perform the actual operation on the ui: or lightning: base components 
            singletonTest = helper.operationsLibrary(component, helper, cmpInFocus, operationName);
        }
        
        if($A.util.isUndefined(singletonTest)) {
            console.log("WARNING: Could not get a boolean test outcome for: " + cmpSpecificMessage);
        }
        
        return singletonTest;
    },
    
    operationsLibrary : function(component, helper, cmpInFocus, operationName) {
        
        if(operationName == "verifyRequiredFieldsArePopulated") {
            return helper.verifyRequiredFieldsArePopulated(component, helper, cmpInFocus);
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
    
    verifyRequiredFieldsArePopulated : function(component, helper, cmpInFocus) {

        var isValid;
        var dateValidity = !$A.util.isUndefined(component.get("v.selectedDate"));
        var periodValidity = component.get("v.selectedTimeslot") != "";
        
        var timeValidity; // Only applicable for the specifc time selection
        if(component.get("v.selectedPeriod") == "Specific time (hh:mm)") {
            timeValidity = !$A.util.isUndefined(component.get("v.selectedTime"));
        } else {
            timeValidity = true;
        }

        isValid = dateValidity && periodValidity && timeValidity;
        return isValid;
    },
    
    toggleFieldAccess : function(component, isDisableField){
        
        // Disable all existing time row elements
        var dateField = component.find("requiredChildComponent");
        dateField.set("v.disabled", isDisableField);
        
        var timeFields = component.find("requiredInputField");
        if(Array.isArray(timeFields)) {
            for(var ind in timeFields) {
                timeFields[ind].set("v.disabled", isDisableField);
            }
        } else {
            timeFields.set("v.disabled", isDisableField);
        }        
    }
    
})