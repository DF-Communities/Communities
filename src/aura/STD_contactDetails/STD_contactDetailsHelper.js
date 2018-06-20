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
                if(inputCmpVal == null || $A.util.isUndefined(inputCmpVal) || inputCmpVal == "") {
                	// Detected untouched required field, fire error
                    inputCmp.set("v.errors", [{message: "This is a required field"}]);
                    isValid = false;	
                } else {                    
                    if(inputCmp.get("v.errors") == null) {
                        isValid = true;
                    } else if(Array.isArray(inputCmp.get("v.errors"))) {
                        // Annoying quirk with Lightning: inputSecret fields return 
                        // an empty array instead of null on error message
                        isValid = (inputCmp.get("v.errors").length == 0) ? true : false;
                    } else {
                        isValid = false;
                    }
                }
                
            } else { // lightning: component
                isValid = inputCmp.get("v.validity").isValid;
            }
        }
        var resultMsg = (isValid) ? "Passed validation" : "Failed validation: " + JSON.stringify(inputCmp.get("v.errors") )
        return isValid;
    },
    
    getAllParams : function(component) {
		console.log("Running contact details doign nothing I think ");
        // Initialise results map
        // params: contains all the inputs for this component
        // isValid: is used to allow idenfitication of which component is erroneous 
        var allCardParams = [];

        console.log("Standard components: " + JSON.stringify(allCardParams));
                
        // Return the input values of all the card children components
        console.log("Leaving getallparams now");
        return allCardParams;
        
    }
	
    
})