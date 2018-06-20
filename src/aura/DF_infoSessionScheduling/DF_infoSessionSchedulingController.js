({    
    doInitRemoved : function(component, event, helper) {
    	helper.getOrgMembership(component);    
    },
    
    /*getEnteredValuesMap : function(component, event, helper) {
        //return helper.getEnteredValuesMapHelper(component);  
    },*/
    
    validateComponent : function(component, event, helper) {
        console.log("Validating Scheduling card");
        return helper.validateComponentHelper(component, event, helper);  
    },
    
    handleStylingFramework: function(component, event, helper) {
    	var isSlds = event.getparam("useSlds");
        component.set("v.useSlds", isSlds);
    },
    
    clearError: function(component, event, helper) {
        component.set("v.publicSessionSearchOnly", false);
        event.getSource().set("v.errors", null);
    },
    
    validateFourCharsMin : function(component, event, helper) {
    
        var field = event.getSource();
        var entry = field.get("v.value");  
        var isValidRegex = /\w/.test(entry); 
                
        if($A.util.isUndefined(entry) || entry.length < 3) {
            field.set("v.errors", [{message:"Please provide a meaningful name with letters and numbers only"}]);
        	//helper.fireErrorEvent(1);
        } else if(!isValidRegex) {
            field.set("v.errors", [{message:"Please enter alphanumeric characters only"}]);
        	//helper.fireErrorEvent(1);
        } else {
            event.getSource().set("v.errors", null);
            //helper.fireErrorEvent(-1);
        }
    },
    
    validateUntouchedPicklist : function(component, event, helper) {
        if(event.getSource().get("v.value") == "") {
            event.getSource().set("v.errors", [{message: "Selection is required"}]);
            //helper.fireErrorEvent(1);
        } else {
            event.getSource().set("v.errors", null);
            //helper.fireErrorEvent(-1);
        }
    },
    
    validateNumberWithinRange : function(component, event, helper) {
        var enteredNum = event.getSource().get("v.value");
        if(enteredNum < 0 || enteredNum > 100) {
            event.getSource().set("v.errors", [{message: "Please enter a whole number between 0 and 100"}]);
            //helper.fireErrorEvent(1);
        } else {
            event.getSource().set("v.errors", null);
            //helper.fireErrorEvent(-1);
        }
    },
    
    assessGroupSizeAndValidate : function(component, event, helper) {
        helper.assessGroupSizeAndValidateHelper(component, event, helper);
    },
    
    revalidateGroupSize : function(component, event, helper) {
        if(component.get("v.publicSessionSearchOnly")) {
        helper.assessGroupSizeAndValidateHelper(component, event, helper);
        }
    },
        
    sessionVisibility : function(component, event, helper) {
    	
        var cmp = event.getSource();    

		// Reset the public and private places
		component.set("v.dfEvent.Private_Places__c", undefined);
        component.set("v.dfEvent.Public_Places__c", undefined);
        component.set("v.showFindPublicSessionButton", false);
        component.set("v.publicSessionSearchOnly", false);
        
        if(cmp.get("v.value") == "true") {
            component.set("v.isSessionPublic", true);
            cmp.set("v.errors", null);
        } else if(cmp.get("v.value") == "false") {
            component.set("v.isSessionPublic", false);
            cmp.set("v.errors", null);
        } else {
            cmp.set("v.errors", [{message: "This is a required field"}]);
        }
    },
    
    handleYesNoEvents : function(component, event, helper) {
        
        var evtName = event.getSource().get("v.name");
        
        if(evtName === "isSessionForOrgYesNo") {
            var evtVar = event.getParam("showDependentFieldWhenSelected_Option");
        	component.set("v.showFindOrg", evtVar);
        } else if(evtName === "healthAndSafety") {
			var evtVar = event.getParam("showDependentFieldWhenSelected_Option");
        	component.set("v.ishealthSafetyPersonKnown", evtVar);        
        }     
    }
})