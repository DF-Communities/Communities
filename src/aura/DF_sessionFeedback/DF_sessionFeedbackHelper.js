({
    publishStylingFrameworkToApp : function(component) {
        
        var useSldsAsSetInLightningOutApp = component.get("v.useSlds");
        console.log("!!!!!!!! useSlds from LtngOut app being set to : " + useSldsAsSetInLightningOutApp);
        var appEvent = $A.get("e.c:SldsVsCustomStylingEvt");
        appEvent.setParam("useSlds", useSldsAsSetInLightningOutApp);
        appEvent.fire();
        
    }, 
    
    showToast : function(component, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
    
    
    handleSaveRecord : function(component) {
        console.log("In handled save for event: " + JSON.stringify(component.get("v.recordId")));
        component.set("v.simpleRecord.Id", component.get("v.recordId"));
        //console.log("HERE: " + component.find("hostFeedbackRating").get("v.value"));
        console.log(JSON.stringify(component.find("eventRecord")));
        
        component.find("eventRecord").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("SUCCUSS");
                
                component.set("v.feedbackSubmittedSuccessfully",true); // Show confirmation dialogue
            }
            else if (saveResult.state === "INCOMPLETE") {
                console.log("INCOMPLETE");
                console.log("User is offline, device doesn't support drafts.");
            }
                else if (saveResult.state === "ERROR") {
                    console.log("ERROR");
                    console.log('Problem saving contact, error: ' +
                                JSON.stringify(saveResult.error));
                }
                    else {
                        console.log("UNKNOWN");
                        console.log('Unknown problem, state: ' + saveResult.state +
                                    ', error: ' + JSON.stringify(saveResult.error));
                    }
        });
    },
    
    getSiteUserInfo : function(component, userId, eventId) {
        console.log("Running getSiteUserInfo with " + userId);
        
        var apexAction = component.get("c.getSiteUserInfo");
        apexAction.setParams({"userId" : userId,
                              "eventId" : eventId});
        
        apexAction.setCallback(this, function(response){
            
            var state = response.getState();
            if(state==="SUCCESS") {
                
                // Set the various component attributes from the response
                var responseMap = response.getReturnValue();
                console.log("Returned Contact params are: " + JSON.stringify(responseMap));
                console.log("Portal Contact Id IS: " + responseMap["portalContactId"]);
                component.set("v.userIsChampion", responseMap["isChampion"]);
                component.set("v.userIsRequester", responseMap["isRequester"]);
                component.set("v.isLoading", false);
                
                console.log("userIsChampion: " + component.get("v.userIsChampion"));
                console.log("userIsRequester: " + component.get("v.userIsRequester"));
                component.set("v.isLoading", false); // Hide the spinner
                
            } else if(state==="INCOMPLETE") {
                console.log("Apex controller callback was incomplete");
                console.log(JSON.stringify(response));
            } else if(state==="ERROR") {
                console.log("Error occurred in apex callback");
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        
        $A.enqueueAction(apexAction);
        
    }
})