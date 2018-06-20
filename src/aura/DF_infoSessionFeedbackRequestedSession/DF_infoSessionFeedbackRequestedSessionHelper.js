({
	 updateSfdcRecord : function(component, dfEvent) {
    	console.log("In updateSfdcRecord");
         component.set("v.isLoading", true);
         console.log("In here");
        var action = component.get("c.submitEventFeedback");
         console.log("Another one");
        action.setParams({dfEvent: dfEvent});
        console.log("Apex payload params set as: " + JSON.stringify(dfEvent));
        console.log("Still going");
         
        action.setCallback(this, function(response){
            var state = response.getState();
            
            console.log("SALESFORCE APEX RETURNED: " + state);
            
            if (state === "SUCCESS") {
                //component.set("v.feedbackSubmittedSuccessfully",true); // Show confirmation dialogue
                if(component.get("v.userIsChampion")) {
                	window.location.href = "/WEBChampion?fdBackSubmitted=true";
                } else {
                    window.location.href = "/WEBFriend?fdBackSubmitted=true";
                }
            } else if (state === "INCOMPLETE") {
                console.log("Incomplete Apex call detected");
                component.set("v.isLoading", false);
            }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } 
                	component.set("v.isLoading", false);
                }
            
        });
        $A.enqueueAction(action);
        
    }
})