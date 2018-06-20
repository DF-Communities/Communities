({
	handleStylingFramework: function(component, event, helper) {
    	var isSlds = event.getparam("useSlds");
        component.set("v.useSlds", isSlds);
    },
    
    checkFieldIsPopulated : function(component, event, helper) {
        if(event.getSource().get("v.value") == "") {
            event.getSource().set("v.errors", [{message: "This is a required field"}]);
        } else {
        	event.getSource().set("v.errors", null);
        }
    },
    
    validateComponent : function(component, event, helper) {
        
        return _extJsFormValidation.validateComponentHelper(component, event, helper, component.get("v.auraIdsToValidate"));    
    },
    
    validateAndGetParams : function(component, event, helper) {
   
        console.log("+++ Getting all parameters from infoSessionContactDetails");
        return helper.getAllParams(component);

	}
    
    
})