({
	validateComponent : function(component, event, helper) {
        return helper.validateComponentHelper(component, event, helper);  
    },
    
    disableDateInput : function(component, event, helper) {

        var superDateField = component.find("dateField");    
        var bodybits = component.get("v.body");
        for(var i=0; i<bodybits.length; i++){
            //console.log("bit: " + JSON.stringify(bodybits[i]));
        }

	}
})