({
    doInit : function(component, event, helper) {
        
        //helper.fireCmpSelectionEvt();
        
    },
    
    validateComponent : function(component, event, helper) {
        console.log("++++++++++ Validating DF_infoSessionDatePeriodTime card");
        //return helper.validateComponentHelper(component, event, helper);  
        console.log('Commencing Vaidation of: ' + _extJsFormValidation.getCompName(component));
        return _extJsFormValidation.validateComponentHelper(component, event, helper, component.get("v.auraIdsToValidate"));
    },
    
    getDateFromEvt : function(component, event, helper) {
        
        var selectedDate = event.getParam("date");
        component.set("v.selectedDate", selectedDate);
    },
    
    timeSlotSelection : function(component, event, helper) {
        
        console.log(component.get("v.name"));
        console.log(component.get("v.errors"));
        console.log(component.get("v.value"));
        var selectedTimeslot = event.getSource().get("v.value");
        var selectedDate = component.get("v.selectedDate");
        
        component.set("v.selectedTime", null); // Reset the time to zero everytime it is not shown
        component.set("v.isValid", false);
        component.set("v.selectedPeriod", selectedTimeslot);
        
        if(selectedTimeslot=="Specific time (hh:mm)") { // Show time slot
            
            component.set("v.showSpecificTime",true);
            var selectedTime = component.get("v.selectedTime");
            console.log('time is: ' + selectedTime);
            component.set("v.isValid", false);
            //component.set("v.errors", null);
            
        } else if(selectedTimeslot!="") {
            
            component.set("v.showSpecificTime",false);
            component.set("v.isValid", true);   
            //component.set("v.errors", [{message: "Required field"}]);
            helper.fireCmpSelectionEvt(true, "newSetting");
            
        }
    },
    
    /*
     * Run on change of the session time 
     * All fields on page are visible when this is called
    */
    validateTimeEntry : function(component, event, helper) {
        
        var enteredTime = event.getSource().get("v.value");
        console.log("enteredTime: " + enteredTime);
        var label = event.getSource().get("v.label");
        console.log("label: " + label);
        
        if(label=="Time") {
            component.set("v.selectedTimeHour", enteredTime);
        } else {
            component.set("v.selectedTimeMinutes", enteredTime);
        }
        
        var selectedHour = component.get("v.selectedTimeHour");
        var selectedMinute = component.get("v.selectedTimeMinutes");
        console.log("Selected time so far: " + selectedHour + ":" + selectedMinute);
        
        if(!$A.util.isUndefined(selectedHour) && !$A.util.isUndefined(selectedMinute)) {
            
            var completeTimeEntry = selectedHour + ":" + selectedMinute;
            console.log("time is :" + completeTimeEntry);
            component.set("v.selectedTime", completeTimeEntry);
        }
    },
    
    getAllParams : function(component, event, helper) {
        console.log("In getAllParams of DF_setSessionPeriod");        
        var compValuesMap = {};

        compValuesMap["name"] = component.get("v.name") + component.get("v.instanceNo");
        compValuesMap["params"] = {
            "date": component.get("v.selectedDate"),
            "period": (component.get("v.selectedPeriod")==undefined) ? "Please select..." : component.get("v.selectedPeriod"),
            "time": component.get("v.selectedTime")
        }
        compValuesMap["isValid"] = component.get("v.isValid");
        
        // If a row is valid, disable the controls
        if(compValuesMap["isValid"]){

            var auraIdsToValidateObjArr = component.get("v.auraIdsToValidate");
            var cmpsToDisable = [];
            for(var key in auraIdsToValidateObjArr) {
                
                var obj = auraIdsToValidateObjArr[key];
                var auraId = obj.auraId;
                var isCustomCmp = obj.isCustomCmp;
                
                var cmps = component.find(String(auraId));
                console.log("Cmps: " + auraId + " " + JSON.stringify(cmps));
                if(Array.isArray(cmps)) {
                	cmpsToValidate.concat(cmps); 
                } else if(!$A.util.isUndefined(cmps)) {
                    cmpsToValidate.push(cmps); 
                }
            }
            console.log("Cmps to diable: " + JSON.stringify(cmpsToValidate));
            
            var allDisabled = cmpsToValidate.reduce(function (disabler, inputCmp) {
                inputCmp.set("v.disabled", true);
            }, true);
        }
        
        console.log("Exiting session period controller which shows: " + JSON.stringify(compValuesMap));
        return compValuesMap;
    }
})