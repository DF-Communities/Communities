({
	proceedToForm : function(component, event, helper) {
		// Fires an event to the parent component to control form appearance
		console.log("in button process");
        var proceedEvt = component.getEvent("DF_proceedToFormEvt");
        proceedEvt.setParam("useSlds", component.get("v.useSlds"));
        proceedEvt.fire();
	},
    
    handleStylingFramework: function(component, event, helper) {
    	console.log("IN STYLING FRAMESWORK with " + JSON.stringify(event.getParams()));
        var isSlds = event.getParam("useSlds");
        component.set("v.useSlds", isSlds);
    }
})