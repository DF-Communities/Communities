({
    doInit : function(component, event, helper) {
    },
    onLoadEventArray : function(component, event ) {
        var dfEvents = component.get("v.events");
        var dfEventId = component.get("v.eventId");
        if (!$A.util.isEmpty(dfEventId)) {
            for (var index in dfEvents) {
                if (dfEvents[index].recordId == dfEventId) {
                    component.set("v.isFirstSubmission", dfEvents[index].isFirstSubmission);
                    if (!$A.util.isEmpty(dfEvents[index].partnerOrgId)) {
                        component.set("v.partnerOrgSelected", true);
                    }
                    console.log("####Loaded..." + JSON.stringify(dfEvents[index]));
                    break;
                }
            }
        }
    },
    handleCancelledSession : function(component, event, helper) {
        
        var dfEvent = component.get("v.simpleRecord");
        if (helper.findDFEventFromCache(component, dfEvent.Id).isRequestedSession) {
        	dfEvent.Event_Status__c = "Cancelled";
            dfEvent.Request_Status__c = "";
        } else {
            dfEvent.Event_Status__c = "Cancelled";
        	dfEvent.Request_Status__c = "Withdrawn";
        }
        helper.updateSfdcRecord(component, dfEvent);
    },
    togglePartnerOrgs : function(component, event, helper) {
        var pOrgSection = component.find("porg-section");        
        $A.util.toggleClass(pOrgSection, "toggle");
    },
    /*handleSaveRecord : function(component, event, helper) {
        
        console.log("In saverecord");
        var objAsStr = JSON.stringify(component.get("v.simpleRecord"));
        console.log("Attempting save with object: " + objAsStr);
        console.log("Submitting: " + JSON.stringify(component.get("v.simpleRecord")));
        var dfEvent = component.get("v.simpleRecord");
        
        if(component.get("v.userIsRequester")) {
        	dfEvent.Host_Feedback_Submitted__c = true;
        } if(!component.get("v.userIsRequester")) {
            dfEvent.Champion_Feedback_Submitted__c = true;
        } 
        
        helper.updateSfdcRecord(component, dfEvent);
    }*/
    
    handleSubmit : function(component, event, helper) {
        console.log("In here");
        if (!component.get("v.partnerOrgSelected")) {
            var simpleRecord = component.get("v.simpleRecord");
            simpleRecord.Partner_Organisation__c = '';
            component.set("v.simpleRecord", simpleRecord);
        }
       /* if(component.get("v.isUntouched")) {
            console.log("un touched is true....");
            component.set("v.isFriendsCreatedComplete", false);
        } else if(component.get("v.isFriendsCreatedComplete")) {*/
            var action = component.getEvent("DF_commonFdbackPgSubmit");
            console.log("In here");
            action.setParams({"fdbackValues" : component.get("v.simpleRecord")});
            console.log("In here firing...");
            action.fire();
       // }
    },
    handleDFEventSelection : function(component, event, helper) {
       var eventRecord = component.get("v.simpleRecord");
       var events = component.get("v.events");
       for (var index in events) {
           if (events[index].recordId == eventRecord.Id) { 
               console.log('### matching record ' + JSON.stringify(events[index]));
               eventRecord.Partner_Organisation__c = events[index].partnerOrgId;
               eventRecord.Number_of_Attendees__c = 0;
               eventRecord.Comments__c = '';
               component.set("v.simpleRecord", eventRecord); 
               component.set("v.isReqSessionFirstSubmission", events[index].isRequestedSession);
               break;
           }
        }
    },    
    validateFieldAndRegisterEdit : function(component, event, helper) {
        if(event.getSource().get("v.value") < 1 || event.getSource().get("v.value") == null) {
            component.set("v.errors", [{message: "A value of greater than 1 is required"}]);
            component.set("v.isFriendsCreatedComplete", false);
            var action = component.get("c.registerFormEdit");
            $A.enqueueAction(action);
        } else {
            console.log('here3');
            component.set("v.errors", null);
            component.set("v.isFriendsCreatedComplete", true);
        }
        component.set("v.isUntouched", false);
    },
    
    registerFormEdit : function(component, event, helper) {
        var fieldValue = event.getSource().get("v.value");
        
        if(fieldValue != '' && fieldValue != null) {
            component.set("v.isUntouched", false);
        } else if(event.getSource().getLocalId() == "friendsCreated") {
            event.getSource().set("v.value", 0);
        } else if(event.getSource().getLocalId() == "comments") {
            // Prevent overrides of the underlying sfdc record data by removing this item from the edit record map
            var editRecord = component.get("v.simpleRecord");
            delete editRecord["Comments__c"];
            component.set("v.simpleRecord", editRecord);
        }
    }
})