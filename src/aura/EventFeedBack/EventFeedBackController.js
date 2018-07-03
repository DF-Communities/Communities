({
	doInit : function(component, event, helper) {
		 component.set("v.isLoading", true);
        
        helper.publishStylingFrameworkToApp(component);
        console.log("useSlds is: " + component.get("v.useSlds"));
                
        var eventId = component.get("v.eventId");
        //component.set("v.recordId", component.get("v.eventId"));
        
        var dfEvent = component.get("v.simpleRecord");
        dfEvent["Id"] = eventId;
        component.set("v.simpleRecord", dfEvent);
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log("User Id is: " + userId);
        console.log("eventId: " + component.get("v.recordId"));
        
        var getUserInfoAction = helper.defineApexUserInfoAction(component, event, helper, userId, eventId);
        var onInitPromise=helper.executeAction(component, getUserInfoAction);
        
        onInitPromise.then(
            $A.getCallback(function(result){
                console.log("User Info apex response: " + JSON.stringify(result));
                helper.setKeyAttributes(component, event, helper, result);
                if (!$A.util.isEmpty(eventId)) {
                    console.log("Starting second promise: returned getEventsAction");
                    var getEventsAction = helper.defineApexEventsAction(component, event, helper, eventId);
                    var eventsPromise=helper.executeAction(component, getEventsAction);
                    return eventsPromise;
                } else {
                    /* no event Id found...*/
                }
            })
        )
        .then(
            $A.getCallback(function(result){
                // We have run the second method, handle its output here
                if (!$A.util.isEmpty(eventId)) {
                    console.log("About to parse the events: " + JSON.stringify(result));
                    helper.parseGetEventsResponse(component, result);
                    
                }
                component.set("v.isLoading", false);
            })
        	
        )
        .catch(
            $A.getCallback(function(error){
                // Something went wrong
                console.log("Error occurred in a returned promise, being handled in line 64 controller");
                if (error) {
                    console.log("Error is: " + JSON.stringify(error));
                    if (error[0] && error[0].message) {
                        console.log("Error message: " + 
                                    error[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.isLoading", false);
            })
        );
	},
    handleCommonFdbackValues : function(component, event, helper) {
		console.log("Habndling event"); 
        var fdbackValues = event.getParam("fdbackValues");
        console.log(JSON.stringify(fdbackValues));
        component.set("v.simpleRecord", fdbackValues);

        if(component.get("v.isReqSessionOrganiserFirstSubmission")) {
            // proceed to the next page
            console.log('Proceeding to next page');
            var eventId = component.get("v.eventId");
            if (!$A.util.isEmpty(eventId)) {
                component.set("v.userIsChampion", true);
                component.set("v.userIsRequester", false);
            }
            component.set("v.showPreForm", false);
            component.set("v.showMainForm", true);
        } else {
            helper.updateSfdcRecord(component, fdbackValues);
        }
	}
})