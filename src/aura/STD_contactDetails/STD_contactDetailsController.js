({
    validateComponent : function(component, event, helper) {
        console.log("Validating ContactDetails card");
        return helper.validateComponentHelper(component, event, helper);  
    },
    
    /*validateComponent : function(component, event, helper) {
        
        return _map.validateComponentHelper(component, event, helper, component.get("v.auraIdsToValidate"));    
    },*/
    
    checkFieldIsPopulated : function(component, event, helper) {
        if(event.getSource().get("v.value") == "") {
            event.getSource().set("v.errors", [{message: "This is a required field"}]);
            component.set("v.isOtherTitle", false);
        } else if(event.getSource().get("v.value") == "Other") { 
            component.set("v.isOtherTitle", true);
            event.getSource().set("v.errors",null);
        } else {
            component.set("v.isOtherTitle", false);
            event.getSource().set("v.errors", null);
        }
    },
    
    handleOtherTitle : function(component, event, helper) {
    	var contactInstance = component.get("v.contactInstance");
        contactInstance.Title__c = event.getSource().get("v.value");
        component.set("v.contactInstance", contactInstance);
    },
    
    assessEmailComposition : function(component, event, helper) {
        if(event.getSource().get("v.value") == "") {
            event.getSource().set("v.errors", [{message: "This is a required field"}]);
        } else {
            var isValidRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(event.getSource().get("v.value")); 
            if(isValidRegex) {
        		event.getSource().set("v.errors", null);
            } else {
                event.getSource().set("v.errors", [{message: "Please enter a valid email address"}]); 
            }
        }
    },
    
    handleSelDynPicklistOption : function(component, event, helper) {
        var picklistIdentifier = event.getParam("picklistIdentifier"); 
        var option = event.getParam("selectedOption");
        // assign this option to the JSON object
        if(picklistIdentifier == "Ethnic_Group__c") {
     	   //component.find("dynSelectionsEthnicity").set("v.value", option);
     	   component.set("v.contactInstance.contactEthnicity", option);
    	} else if(picklistIdentifier == "Proximity_to_dementia__c") {
     	   //component.find("dynSelectionsProximity").set("v.value", option);
           component.set("v.contactInstance.contactProximity", option);
    	}
    },
    
    validateTwoCharsMin : function(component, event, helper) {
    
        var field = event.getSource();
        var entry = field.get("v.value");  
        var isValidRegex = /^[A-z]+$/.test(entry); 
                
        if($A.util.isUndefined(entry) || entry.length < 2) {
            field.set("v.errors", [{message:"A minimum of two characters are required"}]);
        } else if(!isValidRegex) {
            field.set("v.errors", [{message:"Please enter alphanumeric characters only"}]);
        } else {
            field.set("v.errors",null);
        }

    },
    
    
    validateEmailEntry : function(component, event, helper) {
        
        var contactEmail = component.get("v.contactInstance.Email__c");
        var contactEmailConfirm = event.getSource().get("v.value");
        if((contactEmailConfirm != null) && (contactEmail != contactEmailConfirm)) {            
            event.getSource().set("v.errors", [{message:"Emails do not match"}]);
        } else {
            event.getSource().set("v.errors", null);
        }
    },
    
    validatePasswordEntry : function(component, event, helper) {
        
        var contactPassword = component.get("v.enteredPassword");
        var contactPasswordConfirm = event.getSource().get("v.value"); 
        
        var isValidRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/.test(contactPassword);
        
        if((contactPasswordConfirm != null) && (contactPassword != contactPasswordConfirm)) {
			event.getSource().set("v.errors", [{message:"Passwords do not match"}]);
        } else if(!isValidRegex || contactPassword.indexOf('password') != -1) {
        	event.getSource().set("v.errors", [{message:"Passwords must be numbers and letters and at least 8 characters. Your password may not contain the word 'password' or your email address."}]);
        } else {
            event.getSource().set("v.errors", null);
        }        
    },
    
    
    firePasswordChange : function(component, event, helper) {
        var evt = component.getEvent("STD_passwordEntryEvt");
        evt.setParams({passwordValue: event.getParam("value")});
        evt.fire();
    },
 
    validateAndGetParams : function(component, event, helper) {

        var evt = component.getEvent("STD_contactDetailsOutputEvt");
        var passwordEntry = component.get("v.enteredPassword");
        evt.setParams({
            password : passwordEntry,
            areContactDetailsValid : true
                       });
        evt.fire();
        return helper.getAllParams(component, event); ; 
    }

})