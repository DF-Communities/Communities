({   
    validateComponent : function(component, event, helper) {
    	helper.validateComponentHelper(component,event,helper);
	},
    
    
    timeSlotSelection : function(component, event, helper) {
        
        var selectedTimeslot = event.getSource().get("v.value");
        component.set("v.selectedTimeslot", selectedTimeslot);
        
        // Reset the time on any period change
        var reconstitutedTimeField = component.find("reconstitutedTime"); // Reset the time to zero everytime it is not shown
        reconstitutedTimeField.set("v.value", "");
        
        // Show or hide time slot
        if(selectedTimeslot=="Specific time (hh:mm)") { 
            component.set("v.showHourMinuteSelection",true);
        } else if(selectedTimeslot=="") {
            component.set("v.showHourMinuteSelection",false);
        } else {
            component.set("v.showHourMinuteSelection",false);
        }
        
        helper.publishSelection(component, component.get("v.periodFieldApiName"), selectedTimeslot);
    },
    
    validateTimeEntry : function(component, event, helper) {
        
        var enteredTime = event.getSource().get("v.value");
        if(enteredTime == "") {
            event.getSource().set("v.errors", [{message: "Please select a time"}]);
        } else {
            event.getSource().set("v.errors", null);

            var label = event.getSource().get("v.label");
            
            if(label=="Time") {
                component.set("v.selectedTimeHour", enteredTime);
            } else {
                component.set("v.selectedTimeMinutes", enteredTime);
            }
            
            var selectedHour = component.get("v.selectedTimeHour");
            var selectedMinute = component.get("v.selectedTimeMinutes");
            
            if((!$A.util.isUndefined(selectedHour) && selectedHour != "")
               && (!$A.util.isUndefined(selectedMinute) && selectedMinute != "")) {
                var completeTimeEntry = selectedHour + ":" + selectedMinute;
                var constitutedTime = component.find("reconstitutedTime");
                component.set("v.selectedTime", completeTimeEntry);
                constitutedTime.set("v.value", completeTimeEntry);
                // Now publish the value for inclusion in the dfEvent instance
                helper.publishSelection(component, component.get("v.timeFieldApiName"), completeTimeEntry);

            }
        }
    },
    
    handleSelectedDate : function(component, event, helper){
        
        var dateEntry = event.getParam("date");
        component.set("v.selectedDate", dateEntry);
		helper.publishSelection(component, component.get("v.dateFieldApiName"), dateEntry);
    },
    
    removeRow : function(component, event, helper){
        
        if(component.get("v.totalNoRows") > 1) {
            component.set("v.showMaxRowsMessage", false);
        	helper.initiateRowAddOrRemove(component, event, helper, false);
        }
    },
    
    addRow : function(component, event, helper){

        if(component.get("v.totalNoRows") <= 3) {
            //var rowIsValid = helper.validateComponentHelper(component, event, helper)
            var rowIsValid = helper.verifyRequiredFieldsArePopulated(component, event);

            if(rowIsValid) {
                component.set("v.isValid", true);
                helper.initiateRowAddOrRemove(component, event, helper, true);
            } else {
                component.set("v.isValid", false);
            }
        } else {
            component.set("v.showMaxRowsMessage", true);
        }
    },
    
    disableEnableTimingRow : function(component, event, helper) {

        var oldRowCount = component.get("v.totalNoRows");
        var updatedRowCount = event.getParam("newTotalNoRows");
        component.set("v.totalNoRows", updatedRowCount);
        
        var timingRowName;
        if(updatedRowCount > oldRowCount) { 										// In new row actions, disable all rows but the new row
            timingRowName = "sessionTimePreference-" + updatedRowCount.toString();
            if(component.get("v.name") != timingRowName) { 	
                helper.toggleFieldAccess(component, true);
            }
        } else {																	// In remove row actions, enable the "new" last row which was previosu disabled
            timingRowName = "sessionTimePreference-" + updatedRowCount.toString();
            if(component.get("v.name") == timingRowName) {						   
                helper.toggleFieldAccess(component, false);
            }
        }        
    }
})