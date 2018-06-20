({
    doInit : function(component, event, helper) {
        
        console.log("useSlds is: " + component.get("v.useSlds"));
        helper.publishStylingFrameworkToApp(component);
        component.set("v.isLoading", false);
        var eventId = component.get("v.eventId");
        console.log("Event Id is: " + component.get("v.eventId"));
        component.set("v.recordId", component.get("v.eventId"));
        console.log("Record Id is: " + component.get("v.recordId"));
        var dfEvent = component.get("v.simpleRecord");
        dfEvent["Id"] = component.get("v.recordId");
        component.set("v.simpleRecord", dfEvent);
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log("User Id is: " + userId);
        console.log("eventId: " + component.get("v.recordId"));
        
        helper.getSiteUserInfo(component, userId, eventId);
        
    },
    
    handleRecordUpdated : function(component, event, helper) {
        console.log("Detected change in record");  
    },
    
    handleRatingSelection : function(component, event, helper) {
        
        /*var fieldApiName = event.getParam("fieldApiName");
        var selectedRating = event.getParam("selectedRating");*/
        var selectedRating = event.getSource.get("v.value");
        var fieldApiName = event.getSource.get("v.correspondingFieldApiName")
        console.log("fieldApiNameNoEvt: " + fieldApiName);
        console.log("selectedRatingNoEvt: " + selectedRating);
        //component.set("v.fieldApiName", fieldApiName);
        //component.set("v.selectedRating", selectedRating);
        
        //var recordToUpdate = component.find("eventRecord");
        //recordToUpdate[fieldApiName] = selectedRating;
        
        var dynFieldName = "{!v.simpleRecord." + fieldApiName + "}";
        console.log("dynFieldName: " + dynFieldName);
        component.set("{!v.simpleRecord." + fieldApiName + "}", selectedRating);
        
        console.log("OIOI: " + JSON.stringify(component.get("{!v.simpleRecord}")));
        
    },
    
    handleDynAddInfoBoxes : function(component, event, helper) {
        console.log('OI OI!!!');
        var evtCmp = event.getSource();
        var nameOfSection = evtCmp.get("v.name");
        var questionSet = evtCmp.getLocalId();
        console.log("nameOfSection: " + nameOfSection 
                    + " with aura:id: " + questionSet
                    + " and value: " + evtCmp.get("v.value"));
        component.set("{!v." + evtCmp.get("v.name") + "}", false);
        //var showMoreInfoBox = evtCmp.get("v.value");
        var showMoreInfoBox = component.find(questionSet).reduce(function(validFields, inpCmp){
            console.log("lopping one with name: " + inpCmp.get("v.name"));
            console.log("lopping one with value: " + inpCmp.get("v.value"));
            console.log("lopping one with body: " + inpCmp.get("v.body"));
            if(inpCmp.get("v.value") == "No") {
                console.log("+++++ 'No' was asnwered for " + inpCmp.get("v.name"));
                console.log("{!v." + inpCmp.get("v.name") + "}");
                component.set("{!v." + inpCmp.get("v.name") + "}", true);
            }
        }, true);
        
        /*console.log("After reduce, the results was " + showMoreInfoBox);
        if(showMoreInfoBox) {
            console.log("Attempting to show the additional info box for section " + questionSet);
            var infoBoxCmp = component.find(nameOfSection);
            console.log("Found component is: " + infoBoxCmp);
            
            $A.util.addClass(infoBoxCmp, 'hide');
        }*/
        
    },
    
    /*handleSaveFeedback : function(component, event, helper) {
        console.log("In handleSaveFeedback: ");
        helper.handleSaveRecord(component);
    },*/
    
    handleSaveRecord : function(component, event, helper) {
        
        console.log("In saverecord");
        var objAsStr = JSON.stringify(component.get("v.simpleRecord"));
        console.log("Attempting save with object: " + objAsStr);
        console.log("Submitting: " + JSON.stringify(component.get("v.simpleRecord")));
        var dfEvent = component.get("v.simpleRecord");
        
        if(component.get("v.userIsRequester")) {
        	dfEvent.Host_Feedback_Submitted__c = true;
        } if(!component.get("v.userIsRequester")) {
            dfEvent.Champion_Feedback_Submitted__c = true;
        } else {
            // Submit error
        }
        
        var action = component.get("c.submitEventFeedback");
        action.setParams({dfEvent: dfEvent});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            console.log("SALESFORCE APEX RETURNED: " + state);
            
            if (state === "SUCCESS") {
                component.set("v.feedbackSubmittedSuccessfully",true); // Show confirmation dialogue
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
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
        $A.enqueueAction(action);
    },
    
    
    handleCancelledSession : function(component, event, helper) {
        console.log("In handleCancelledSession: ");
        var eventRec = component.get("v.simpleRecord");
        eventRec["Event_Status__c"] == "Cancelled";
        component.set("v.simpleRecord", eventRec);
        helper.handleSaveRecord(component);
    }
    
})