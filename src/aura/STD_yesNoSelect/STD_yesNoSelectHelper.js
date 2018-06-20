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
    
    getAllParams : function(component) {
        
        var allCardParams = {}
        allCardParams.name = component.get("v.name");
        var yesNoSelect = component.find("yesNoSelect");
        allCardParams.params = yesNoSelect.get("v.value");
        allCardParams.isValid = (yesNoSelect.get("v.value") == "Please select...") ? false : true;
        
        // Return the input values of all the card children components
        return allCardParams;
        
    }
})