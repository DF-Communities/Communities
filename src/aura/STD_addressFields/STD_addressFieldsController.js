({
	handleStylingFramework: function(component, event, helper) {
    	var isSlds = event.getparam("useSlds");
        component.set("v.useSlds", isSlds);
    },
    
    validateComponent : function(component, event, helper) {
        console.log("Validating Location card");
        return helper.validateComponentHelper(component, event, helper);  
    },
    
    handleApplicationEvent : function(component, event, helper) {
    	var evtPayload = event.getParam("payload");
        
        if(evtPayload != undefined){
            // Update the address fields 
            component.set("v.extStreet1Value", evtPayload["street1"]);
            component.set("v.extStreet2Value", evtPayload["street2"]);
            component.set("v.extStreet3Value", evtPayload["street3"]);
            component.set("v.extCityValue", evtPayload["city"]);
            component.set("v.extCountyValue", evtPayload["county"]);
            component.set("v.extPostcodeValue", evtPayload["postcode"]);
            
            console.log("+++++ Saved VF address in STD_addressFields cmp with payload: " + JSON.stringify(evtPayload));
        }
	},
    
    addressChange : function(component, event, helper) {
        var addressValuesMapFromVf = component.get("v.addressValuesMapFromVf");

        if(addressValuesMapFromVf != undefined){
            // Update the address fields 
            component.set("v.extStreet1Value", addressValuesMapFromVf["street1"]);
            component.set("v.extStreet2Value", addressValuesMapFromVf["street2"]);
            component.set("v.extStreet3Value", addressValuesMapFromVf["street3"]);
            component.set("v.extCityValue", addressValuesMapFromVf["city"]);
            component.set("v.extCountyValue", addressValuesMapFromVf["county"]);
            component.set("v.extPostcodeValue", addressValuesMapFromVf["postcode"]);
        }
        
    },
   
    getAllInputValues : function(component, event, helper) {
        
        var inputsMap = {};
        
        var validSoFar = component.find("addressDetailInput").reduce(function(validSoFar, inputCmp){
            
            inputsMap[inputCmp.get("v.name")] = inputCmp.get("v.value");
			                        
            if(!inputCmp.get("v.validity").valid) {
                console.log("FIELD " + inputCmp.get("v.name") + "  WAS INVALID");
            }
            
            return validSoFar && inputCmp.get("v.validity").valid;
        }, inputsMap);
        
        // Put the return structure in the correct format
        var cmpParamMap = {"params" : inputsMap,
                           "isValid" : validSoFar};
        
        return cmpParamMap; 
    }
})