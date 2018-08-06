({
    publishStylingFrameworkToApp : function(component) {
        
        var useSldsAsSetInLightningOutApp = component.get("v.useSlds");
        console.log("!!!!!!!! useSlds from LtngOut app being set to : " + useSldsAsSetInLightningOutApp);
        var appEvent = $A.get("e.c:SldsVsCustomStylingEvt");
        appEvent.setParam("useSlds", useSldsAsSetInLightningOutApp);
        appEvent.fire();
        
    }, 
    
    defineApexUserInfoAction : function(component, event, helper, userId, eventId) {
        var action = component.get("c.getSiteUserInfo");
        action.setParams({"userId" : userId,
                          "eventId" : ($A.util.isEmpty(eventId) ? '' : eventId )});
        return action;
    },
    
    defineApexEventsAction : function(component, event, helper, eventId) {
        var action = component.get("c.getEventInfo");
        action.setParams({"eventId" : eventId});
        return action;
    },
    
     executeAction: function(component, action) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retVal=response.getReturnValue();
                    resolve(retVal);
                    //helper.gotoManageMySessionsPage(component, event, helper);
                }
                else if (state === "ERROR") {
                    console.log("Error detected");
                    var errors = response.getError();
                    console.log("Error follows:");
                    //console.log(JSON.stringify(errors));
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject(Error("Error message: " + errors[0].message));
                        }
                    }
                    else {
                        reject(Error("Unknown error"));
                    }
                }
            });
        $A.enqueueAction(action);
        });
    },
    
    parseGetEventsResponse : function(component, response) {
        
        var interimEventRec = component.get("v.simpleRecord");
        
        component.set("v.simpleRecord", response);
        component.set("v.isLoading", false);
        
 	},
    
    /*getSiteUserInfo : function(component, event, helper, userId, eventId) {
        console.log("Running getSiteUserInfo with " + userId);
        component.set("v.isLoading", true);
        var apexAction = component.get("c.getSiteUserInfo");
        apexAction.setParams({"userId" : userId,
                              "eventId" : eventId});
        
        apexAction.setCallback(this, function(response){
            
            var state = response.getState();
            if(state==="SUCCESS") {
                
                // Set the various component attributes from the response
                var responseMap = response.getReturnValue();
                
                helper.setKeyAttributes(component, event, helper, responseMap);
                
                component.set("v.isLoading", false); // Hide the spinner
                
                
            } else if(state==="INCOMPLETE") {
                console.log("Apex controller callback was incomplete");
                console.log(JSON.stringify(response));
                component.set("v.isLoading", false); // Hide the spinner
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
                component.set("v.isLoading", false); // Hide the spinner
            }
            
        });
        
        $A.enqueueAction(apexAction);
        
    },*/
    
    setKeyAttributes : function(component, event, helper, responseMap) {
        console.log('Setting attribute ......');
        component.set("v.userIsChampion", responseMap["isChampion"]);
        console.log('userIsChampion: ' + component.get("v.userIsChampion"));
        component.set("v.userIsRequester", responseMap["isRequester"]);
        console.log('userIsRequester: ' + component.get("v.userIsRequester"));
        
        var isCreatedSession = responseMap["isChampion"] && !responseMap["isRequestedSession"]; 
        console.log('isCreatedSession: ' + isCreatedSession);
        component.set("v.isCreatedSession", isCreatedSession);
        
        var isReqSessionOrganiserFirstSubmission = responseMap["isRequestedSession"] && !responseMap["isRequester"] && !responseMap["isChampFdbackSubmitted"]; 
        console.log('isReqSessionOrganiserFirstSubmission: ' + isReqSessionOrganiserFirstSubmission);
        component.set("v.isReqSessionOrganiserFirstSubmission", isReqSessionOrganiserFirstSubmission);
        
        var isReqSessionRequesterFirstSubmission = responseMap["isRequestedSession"] && responseMap["isRequester"] && !responseMap["isHostFdbackSubmitted"];
        console.log('isReqSessionRequesterFirstSubmission: ' + isReqSessionRequesterFirstSubmission);
        component.set("v.isReqSessionRequesterFirstSubmission", isReqSessionRequesterFirstSubmission);
        var eventId = component.get("v.eventId");
        var showPreForm = ((!$A.util.isEmpty(eventId) && !responseMap["isRequester"]) || (!responseMap["isRequester"] && responseMap["isChampion"]));
        console.log('SHOWPREFORM: ' + showPreForm);
        component.set("v.showPreForm", showPreForm);
        component.set("v.showMainForm", !showPreForm); 
        // handle the pick list org and list of session pending for reporting...
        // pick list dfEVENT 
        // 
        component.set("v.events" , responseMap["unReportedEvents"]);
        component.set("v.pOrgs" , responseMap["partnerOrgList"]);
        console.log("setKeyAttributes Events ... " + JSON.stringify(responseMap["unReportedEvents"]));
        
    },
    
    updateSfdcRecord : function(component, dfEvent) {
    	console.log("In updateSfdcRecord");
         component.set("v.isLoading", true);
         console.log("In here");
        var action = component.get("c.submitEventFeedback");
        
        action.setParams({dfEvent: dfEvent});
        console.log("Apex payload params set as: " + JSON.stringify(dfEvent));
        console.log("Still going");
         
        action.setCallback(this, function(response){
            var state = response.getState();
            
            console.log("SALESFORCE APEX RETURNED: " + state);
            
            if (state === "SUCCESS") {
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