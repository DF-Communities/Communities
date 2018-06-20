({
	showSessionDetailsEvt : function(component, event, helper) {

        var sessionIndex = (event.target).dataset.id;
		var action = component.getEvent("DF_showInfoSessionDetailsEvt");
        action.setParams({"index" : sessionIndex});
        action.fire();
	}
})