({    
    handleSubsequentSessionRequest : function(component, event, helper) {
		var action = component.getEvent("DF_subsequentSessionEvt");
        action.fire();
	}
})