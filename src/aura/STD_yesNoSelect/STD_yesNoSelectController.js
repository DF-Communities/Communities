({
    
    doInit: function(component, event, helper) {
    	
        component.set("v.uiCompatValue", component.get("v.value"));
        
    },
    
    setStylingFramework : function(component, event, helper) {
        if($A.util.isUndefined(component.get("v.sldsOverride"))) {
            var useSlds = event.getParam("useSlds");
            component.set("v.useSlds", useSlds);
        } else {
            component.set("v.useSlds", component.get("v.sldsOverride"));
        }
    },
    
    validateComponent : function(component, event, helper) {
        var auraId = "yesNoSelect";
        return helper.assessComponent(component, false, auraId);  
    },
    
    handleSelectionChange : function(component, event, helper) {
        
        if(event.getSource().get("v.value") == "") {
            event.getSource().set("v.errors", [{message: "Selection is required"}]);
        } else {
            event.getSource().set("v.errors", null);
        }

        // Determine if the toggle attribute has been defined
        var useSlds = component.get("v.useSlds");
        var isSelectionBasedEvent = component.get("v.showDependentFieldWhenSelected_Option");
        var selectedValue;
        var cmp = event.getSource();
        if(useSlds) {  // Use ltng:
        	selectedValue = cmp.get("v.value");
            if(cmp.get('v.validity').valueMissing) {
                cmp.set("v.errors", [{message: "This is a required field"}]);
            }
        } else { // Use ui:
            selectedValue = component.find("yesNoSelect").get("v.value"); 
            if(cmp.get("v.required") && selectedValue == "") {
                cmp.set("v.errors", [{message: "This is a required field"}])
            }
        }

        var returnAsBoolean = component.get("v.returnSelectionAsBoolean");
        var showDependentField;
        if(isSelectionBasedEvent) {
            if(selectedValue == component.get("v.showDependentFieldWhenSelected_Option")) {
                showDependentField = true;
            } else {
                showDependentField = false;
            }
        } else {
            showDependentField = false;
        }

        // Set the field value
        if(useSlds) {
            if(selectedValue == "Yes") {
                component.set("v.value", true);
            } else {
                component.set("v.value", false);
            }
        } else {
            component.set("v.value", selectedValue);
        }

        // Fire the field visibility toggle event
        var cmpEvt = component.getEvent("STD_yesNoSelectEvt");
        cmpEvt.setParams({
            			  showDependentFieldWhenSelected_Option: showDependentField,
                          returnAsBoolean: returnAsBoolean,
                          selectedOption: selectedValue,
                          yesNoComponentName: component.get("v.name")
                         });
        
        cmpEvt.fire();
        
    },
    
    validateAndGetParams : function(component, event, helper) {
        console.log("Getting all parameters from " + component.get("v.name"));
        return helper.getAllParams(component);  
    }
})