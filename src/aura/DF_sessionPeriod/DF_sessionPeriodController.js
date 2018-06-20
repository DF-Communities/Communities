({
    doInit : function(component, event, helper) {
    	
        // Initialise the entry to being invalid
        var evt = component.getEvent("DF_rowItemDetailEvt");
        evt.setParams({
            			"isValid": false,
			            "params": null
        			  });
        evt.fire();
        
        var a = component.get('c.validateTimeEntry');
        $A.enqueueAction(a);
        
    },
    
    getDateFromEvt : function(component, event, helper) {

        var selectedDate = event.getParam("date");
        component.set("v.selectedDate", selectedDate);
    },
    
	timeSlotSelection : function(component, event, helper) {
        
    	var selectedTimeslot = event.getSource().get("v.value");
        var selectedDate = component.get("v.selectedDate");
	
        component.set("v.selectedTime", null); // Reset the time to zero everytime it is not shown
		component.set("v.isValid", false);
        component.set("v.selectedPeriod", selectedTimeslot);
        
        if(selectedTimeslot=="Please select") {
			component.set("v.selectedPeriod", "Please select");
        } else if(selectedTimeslot=="Specific time (hh:mm)") { // Show time slot
			component.set("v.showSpecificTime",true);
            
            var selectedTime = component.get("v.selectedTime");
           
            component.set("v.isValid", false);
            
        } else {

            component.set("v.showSpecificTime",false);
            component.set("v.isValid", true);                        
        }
    },
    
    /*
     * Run on change of the session time 
     * All fields on page are visible when this is called
    */
    validateTimeEntry : function(component, event, helper) {
        
        var enteredTime = event.getSource().get("v.value");
        component.set("v.selectedTime", enteredTime);
        
    },
    
    getAllParams : function(component,event,helper) {

        var compValuesMap = {};

        compValuesMap["name"] = component.get("v.name") + component.get("v.instanceNo");
        compValuesMap["params"] = {
            "date": component.get("v.selectedDate"),
            "period": (component.get("v.selectedPeriod")==undefined) ? "Please select..." : component.get("v.selectedPeriod"),
            "time": component.get("v.selectedTime")
        }
        compValuesMap["isValid"] = component.get("v.isValid");
        
        return compValuesMap;
    }
})