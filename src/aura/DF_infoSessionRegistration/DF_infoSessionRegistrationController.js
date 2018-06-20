({
    validateComponent : function(component, event, helper) {
        console.log("Validating Registration card");
        return helper.validateComponentHelper(component, event, helper);  
    },
    
    validateAndGetParams : function(component, event, helper) {
        return helper.getAllParams(component);  
    },
    
    validateOtherSafetyMarshalName : function(component, event, helper) {
        helper.validateFourCharsMin(component, event, helper);
        helper.publishThirdPartySafetyMarshalInfo(component, event, helper);
    },
    
    validateOtherSafetyMarshalNum : function(component, event, helper) {
        helper.validateUkPhone(component, event, helper);
        helper.publishThirdPartySafetyMarshalInfo(component, event, helper);
    },
    
    handleYesNoSelection : function(component, event, helper) {

        var selectedOption = event.getParam("selectedOption");
        var showDependentField = event.getParam("showDependentFieldWhenSelected_Option"); 
        var sourceCmpName = event.getSource().get("v.name");

        // Set the return value to a boolean or yes/no string
        var valueToAssign;
        if(event.getParam("returnAsBoolean")) {
            if(selectedOption == "Yes"){
                valueToAssign = true;
            } else {
                valueToAssign = false;
            }
        } else {
            valueToAssign = selectedOption;
        }

        if(sourceCmpName == "Session_Requester_is_Safety_Marshal__c") {
            component.set("v.isHealthSafetyPersonKnown", !showDependentField);
        } else if(sourceCmpName == "Venue_has_Public_Liability_Insurance__c") {
            component.set("v.noInsurance", showDependentField);
        }
        event.getSource().set("v.value", valueToAssign);
        
        // Now fire event to add red border to yesNo picklist
        var borderEvt = component.getEvent("DF_yesNoErrorEvt");
        borderEvt.fire();
    },
    
    /*toggleInsuranceConfirmation : function(component, event, helper) {
        
        var toggleCmp = event.getSource();
        console.log("toggle name is: " + toggleCmp.get("v.name"));
        var state = toggleCmp.get("v.checked");
        console.log(JSON.stringify(toggleCmp.get("v.body")));
        
        console.log("state is: " + state);
        if(state) {
            component.set("v.noInsurance", false);
            toggleCmp.set('v.validity', {valid:true, badInput:false});
        } else {
			component.set("v.noInsurance", true); 
            toggleCmp.set('v.validity', {valid:false, badInput:true});
        }
        //component.get("v.noInsurance"); 
    }*/
})