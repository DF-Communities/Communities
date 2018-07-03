({
    doInit : function(component, event, helper) {
    },
    onLoadEventArray : function(component, event ) {
		//console.log('## array change ' +  JSON.stringify(component.get("v.events")));
        //console.log('## eventId change ' +  JSON.stringify(component.get("v.eventId")));
        var dfEvents = component.get("v.events");
        var dfEventId = component.get("v.eventId");
        if (!$A.util.isEmpty(dfEventId)) {
            for (var evt in dfEvents) {
                if (evt.recordId == dfEventId) {
                    component.set("v.isFirstSubmission", evt.isFirstSubmission);
                    if (!$A.util.isEmpty(evt.partnerOrgId)) {
                        component.set("v.partnerOrgSelected", true);
                    }
                    console.log("####Loaded..." + JSON.stringify(evt));
                    break;
                }
            }
        }
    },
    handleCancelledSession : function(component, event, helper) {
        
        var dfEvent = component.get("v.simpleRecord");
        if (!helper.findDFEventFromCache(component, dfEvent.Id).isRequestedSession) {
        	dfEvent.Event_Status__c = "Cancelled";
            dfEvent.Request_Status__c = "";
        } else {
            dfEvent.Event_Status__c = "Cancelled";
        	dfEvent.Request_Status__c = "Withdrawn";
        }
        helper.updateSfdcRecord(component, dfEvent);
    },
    togglePartnerOrgs : function(component, event, helper) {
        console.log('@@@@@ pOrgSection ' ); 
        var pOrgSection = component.find("porg-section");        
        $A.util.toggleClass(pOrgSection, "toggle");
    },

    handleSubmit : function(component, event, helper) {
        console.log("In here");
        if (!component.get("v.partnerOrgSelected")) {
            var simpleRecord = component.get("v.simpleRecord");
            simpleRecord.Partner_Organisation__c = '';
            component.set("v.simpleRecord", simpleRecord);
        }
        if(component.get("v.isUntouched")) {
            component.set("v.isFriendsCreatedComplete", false);
        } else if(component.get("v.isFriendsCreatedComplete")) {
            var action = component.getEvent("DF_commonFdbackPgSubmit");
            console.log("In here");
            action.setParams({"fdbackValues" : component.get("v.simpleRecord")});
            console.log("In here firing...");
            action.fire();
        }
    },
    handleDFEventSelection : function(component, event, helper) {
       var eventRecord = component.get("v.simpleRecord");
       var events = component.get("v.events");
       for (var dfEvent in events) {
           if (dfEvent.recordId == eventRecord.Id) { 
               console.log('### matching record ' + JSON.stringify(dfEvent));
               //component.set("v.simpleRecord", dfEvent); 
               eventRecord.Partner_Organisation__c = dfEvent.partnerOrgId;
               component.set("v.simpleRecord", eventRecord); 
               component.set("v.isReqSessionFirstSubmission", dfEvent.isRequestedSession);
               break;
           }
        }
    },    
    validateFieldAndRegisterEdit : function(component, event, helper) {
        console.log('here');
        if(event.getSource().get("v.value") < 1 || event.getSource().get("v.value") == null) {
            console.log('here2');
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
        console.log('here4');
    },
    
    registerFormEdit : function(component, event, helper) {
        console.log('runing registerFormEdit');
        var fieldValue = event.getSource().get("v.value");
        console.log('Input registered as: ' + event.getSource().get("v.value"));
        console.log('Local Id: ' + event.getSource().getLocalId());
        
        if(fieldValue != '' && fieldValue != null) {
            component.set("v.isUntouched", false);
        } else if(event.getSource().getLocalId() == "friendsCreated") {
            event.getSource().set("v.value", 0);
        } else if(event.getSource().getLocalId() == "comments") {
            // Prevent overrides of the underlying sfdc record data by removing this item from the edit record map
            var editRecord = component.get("v.simpleRecord");
            console.log("record: " + editRecord);
            delete editRecord["Comments__c"];
            console.log("Just deleted the comments");
            component.set("v.simpleRecord", editRecord);
        }
    }
})