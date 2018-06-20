({
    assessGroupSizeAndValidateHelper : function(component, event, helper) {
        var cmp = event.getSource();    

        if(cmp.get("v.value") <= 10) {
            component.set("v.publicSessionSearchOnly", true);
        } else {
            component.set("v.showFindPublicSessionButton", false);
            component.set("v.publicSessionSearchOnly", false);
        }
        
        if(cmp.get("v.value") < 0 || cmp.get("v.value") > 999) {
            event.getSource().set("v.errors", [{message: "Not a valid number"}]);
            //helper.fireErrorEvent(1);
        } else {
            event.getSource().set("v.errors", null);
            //helper.fireErrorEvent(-1);
        }
    },
    
    validateComponentHelper : function(component, event, helper) {
        
        var auraIdsToValidateObjArr = component.get("v.auraIdsToValidate");
        var inputsAreValid = true;
        for(var key in auraIdsToValidateObjArr) {
            
            var obj = auraIdsToValidateObjArr[key];
            var auraId = obj.auraId;
            var isCustomCmp = obj.isCustomCmp;
            var cmpsToValidate = component.find(String(auraId)); 
            var areFieldsDefined = !$A.util.isUndefined(cmpsToValidate);

            // Check all required lightning:input fields for validity
            if(areFieldsDefined) {   
                var cumulativeCmpTypeValidity = true;
                
                if(Array.isArray(cmpsToValidate)) {
                        
                    	cumulativeCmpTypeValidity = cmpsToValidate.reduce(function (cumulativeValidity, inputCmp) {
                            if($A.util.isUndefined(inputCmp.get("v.label")) || inputCmp.get("v.label") == '') {
                                console.log("Reading component " + auraId + ": name: " + inputCmp.get("v.name"));
                            } else {
                                console.log("Reading component " + auraId + ": label: " + inputCmp.get("v.label"));
                            }
                            var isCmpValid = helper.assessComponent(inputCmp, isCustomCmp); 
                            return cumulativeValidity && isCmpValid;
                        });
                    
                } else {  
                    console.log("Reading only component " + auraId + ": " + cmpsToValidate.get("v.label"));
                    cumulativeCmpTypeValidity = helper.assessComponent(cmpsToValidate, isCustomCmp);
                } 
                
                console.log('Post loop: cumulativeCmpTypeValidity for key: ' + obj + ' is: ' + cumulativeCmpTypeValidity);
                inputsAreValid = cumulativeCmpTypeValidity && inputsAreValid;
                console.log('Post loop: inputsAreValid for key: ' + obj + ' is: ' + inputsAreValid);

            } else {
                console.log("No components with aura:id " + obj.auraId + " rendered in " + component.get("v.name"));                
            }
        }
        
        console.log("Exiting section validity with: " + inputsAreValid);
        return inputsAreValid;
    },
       
    assessComponent : function(inputCmp, isCustomCmp) {

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
        return isValid;
    },
    
    getOrgMembershipRemoved : function(component) {
        
        var action = component.get("c.getPartnerOrgs");
        action.setParam("dfContactId", component.get("v.dfContactId"));
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==="SUCCESS") {
                var apexMapList = response.getReturnValue();
                var isObjectEmpty = !Object.keys(apexMapList).length;
                if(isObjectEmpty) {
                    component.set("v.contactIsPoAdmin", false);
                } else {
                    component.set("v.contactIsPoAdmin", true);
                }
                component.set("v.memberOrgs", apexMapList);
            }
        });
        $A.enqueueAction(action);
    }
})