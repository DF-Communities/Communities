({
        
    verifyDateInRangeHelper : function(component, event, helper) {
        
    	var daysOffset = component.get("v.daysOffsetFromToday");        
        // Only run the validation if the componetn is not the bootstrap datepicker which handes validation within itself
        var dateCmp = event.getSource();
        if((!$A.util.isUndefined(dateCmp.validity) || !$A.util.isUndefined(dateCmp.get("v.errors")))
           && !$A.util.isUndefined(daysOffset) && component.get("v.enforceOffset")) {
            // Check date is at least as many days in the future as specified in the daysOffsetFromToday attribute
            var enteredDate = new Date(component.find("dateField").get("v.value")); 
            var verificationDate = new Date();
            verificationDate.setDate(verificationDate.getDate() + daysOffset);
            
            if(verificationDate.getDate() > enteredDate.getDate()) {

                if(!$A.util.isUndefined(dateCmp.get("v.errors"))) { //ui: component
                    dateCmp.set("v.errors", [{message:"Date must be at least " + daysOffset + " days in the future"}]);
                    component.set('v.setDate', verificationDate.getFullYear() + "-" + (verificationDate.getMonth() + 1) + "-" + verificationDate.getDate());
                } else if(!$A.util.isUndefined(dateCmp.validity)) { //lightning: component
                    dateCmp.set("v.errors", [{message:"Date must be at least " + daysOffset + " days in the future"}]);
                    component.set('v.setDate', verificationDate.getFullYear() + "-" + (verificationDate.getMonth() + 1) + "-" + verificationDate.getDate());
                } 
            } else {
                dateCmp.set("v.errors", null);
                component.set("v.value", verificationDate);
                helper.fireDateValueEvt(component);
            }
        } else {
            helper.fireDateValueEvt(component);
        }
    },
    
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
    
    setDefaultDate : function(component) {
        
        var dateOffset = component.get("v.daysOffsetFromToday");
        var targetDate = new Date;
        if(!$A.util.isUndefined(dateOffset)) {
            targetDate.setDate(targetDate.getDate() + dateOffset);
        } 
        
        // Workaround to avoid errors on the UI component where the date errors 
        // if in the format d/mm/yyy as opposed to 0d/mm/yyyy
        var dateStrCmp = targetDate.getFullYear() + "-" + ('0' + (targetDate.getMonth() + 1)).slice(-2) + "-" + ('0' + targetDate.getDate()).slice(-2);
        component.set('v.setDate', dateStrCmp);
        
        // Set the text visible on the component
        var dateStrField = ('0' + targetDate.getDate()).slice(-2) + "/" + ('0' + (targetDate.getMonth() + 1)).slice(-2) + "/" + targetDate.getFullYear();
        var domId = "datepicker-" + component.get("v.name");
     	var domEle = document.getElementById(domId);   
        domEle.value = dateStrField;
    },
    
    fireDateValueEvt : function(component) {
        var cmpEvt = component.getEvent("STD_datePickerSelectionEvt");

        cmpEvt.setParams({
            "date": component.get("v.value")
        });
        cmpEvt.fire();  
    }
    
})