({
    publishStylingFrameworkToApp : function(component) {
        
        var useSldsAsSetInLightningOutApp = component.get("v.useSlds");
        component.set("v.useSlds", useSldsAsSetInLightningOutApp);
        var appEvent = $A.get("e.c:SldsVsCustomStylingEvt");
        appEvent.setParam("useSlds", useSldsAsSetInLightningOutApp);
        
    },
    
    executeAction: function(component, action, callback) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retVal=response.getReturnValue();
                    resolve(retVal);
                    
                    if(component.get("v.signupConfirmation")) {
                        console.log('Heading to redirect');
                        helper.gotoManageMySessionsPage(component, event, helper);
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log(JSON.stringify(errors));
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
    
    defineApexGetEventsAction : function(component, isInit) {
        
        var recordsToDisplay = component.get("v.recordsToDisplay");
        var pageNumber = component.get("v.pageNumber");
        var selectedSessionType = component.find("sessionTypePicklist").get("v.value");
        var selectedSessionType = (selectedSessionType=='Please select...') ? '' : selectedSessionType;
        
        var action = component.get("c.searchRequestedSessions");
        var endDate = component.get("v.endDate");
        
        action.setParams({
            "searchRadius" : component.get("v.radius"),
            "dfContactId" : component.get("v.dfContactId"),
            "dfContactLat" : component.get("v.dfContactLat"),
            "dfContactLng" : component.get("v.dfContactLng"),
            "fromDateStr" : component.get("v.startDate"),
            "toDateStr" : endDate,
            "sessionType" : selectedSessionType,
            "pageNumber" : pageNumber,
            "recordsToDisplay" : recordsToDisplay
        })  
        console.log("Initial params are: " + JSON.stringify(action.getParams()));
        
        return action;
    },
    
    /*
     * 	To be inherited by dfc common component
     */
    parseGetSiteUserInfoResponse : function(component, response) {
        
        component.set("v.dfContactId", (response["dfContactId"] != null) ? response["dfContactId"] : null);
        component.set("v.radius", response["eventSearchRadius"]);
        var radiusPicklist = component.find("searchRadiusSelect");
        radiusPicklist.set("v.value", response["eventSearchRadius"]);
        component.set("v.userId", String.valueOf(response["userId"]));
        component.set("v.dfContactLat", response["dfContactLat"]);
        component.set("v.dfContactLng", response["dfContactLng"]);
        
    },
    
    getFormattedDate : function(unformattedDate) {
        var formattedDate = unformattedDate.getFullYear() + "-" + 
            ('0' + (unformattedDate.getMonth() + 1)).slice(-2) + "-" + 
            ('0' + unformattedDate.getDate()).slice(-2);  
        
        return formattedDate;
    },
    
    parseGetEventsResponse : function(component, responses) {
        
        var recordsToDisplay = component.get("v.recordsToDisplay");
        var response = JSON.parse(responses);
        
        // Add some fields to compare teh various preference dates to today's date 
        // so that only valid ones are shown
        var dateNow = Date.now();
        for(var ind in response["events"]) {
            
            var pref1Date = new Date(response["events"][ind].Preference_1_Date__c);
            var pref2Date = new Date(response["events"][ind].Preference_2_Date__c);
            var pref3Date = new Date(response["events"][ind].Preference_3_Date__c);
            
            // Append a '0' for values less than 10 
            var pref1FormattedMonth = (pref1Date.getMonth()+1 < 10) ? '0' + (pref1Date.getMonth()+1) : pref1Date.getMonth()+1;
            var pref1FormattedDay = (pref1Date.getDate() < 10) ? '0' + (pref1Date.getDate()) : pref1Date.getDate();
            var pref2FormattedMonth = (pref2Date.getMonth()+1 < 10) ? '0' + (pref2Date.getMonth()+1) : pref2Date.getMonth()+1;
            var pref2FormattedDay = (pref2Date.getDate() < 10) ? '0' + (pref2Date.getDate()) : pref2Date.getDate();
            var pref3FormattedMonth = (pref3Date.getMonth()+1 < 10) ? '0' + (pref3Date.getMonth()+1) : pref3Date.getMonth()+1;
            var pref3FormattedDay = (pref3Date.getDate() < 10) ? '0' + (pref3Date.getDate()) : pref3Date.getDate();
            
            response["events"][ind].isPref1InFuture = (pref1Date > dateNow) ? true : false;
            response["events"][ind].pref1DateUserFriendly = pref1FormattedDay + "/" + pref1FormattedMonth + "/" + pref1Date.getFullYear();
            response["events"][ind].isPref2InFuture = (pref2Date > dateNow) ? true : false;
            response["events"][ind].pref2DateUserFriendly = pref2FormattedDay + "/" + pref2FormattedMonth + "/" + pref2Date.getFullYear();
            response["events"][ind].isPref3InFuture = (pref3Date > dateNow) ? true : false;
            response["events"][ind].pref3DateUserFriendly = pref3FormattedDay + "/" + pref3FormattedMonth + "/" + pref3Date.getFullYear();
        }
        
        component.set("v.searchResults", response.events);
        component.set("v.pageNumber", response.page);
        component.set("v.total", response.total);
        component.set("v.pages", Math.ceil(response.total / recordsToDisplay));    
    },
    
    createSessionTimeStructure : function(component, sessionRecord) {
        
        var timeOptions = {};
        timeOptions['Morning (7am-12pm)'] = ["Select time","07:00","08:00","09:00","10:00","11:00","12:00"];
        timeOptions['Afternoon (12pm-5pm)'] = ["Select time","12:00","13:00","14:00","15:00","16:00","17:00"];
        timeOptions['Evening (5pm-10pm)'] = ["Select time","17:00","18:00","19:00","20:00","21:00","22:00"];  
        timeOptions['Specific time'] = ["Select time","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00"];  
        timeOptions['Any time'] = ["Select time","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00"];  
        
        var sessionTimeDefinitions = [];
        
        if(sessionRecord.hasOwnProperty("Preference_1_Date__c") && Boolean(sessionRecord.isPref1InFuture)) {    
            var selections1 = {};
            selections1["date"] = sessionRecord.pref1DateUserFriendly;
            selections1["period"] = sessionRecord.Preference_1_Period__c;
            if(sessionRecord.hasOwnProperty("Preference_1_Time__c")) {
                selections1["timeOptions"] = ["Select time",sessionRecord.Preference_1_Time__c];
            } else {
                selections1["timeOptions"] = timeOptions[sessionRecord.Preference_1_Period__c];
            }
            sessionTimeDefinitions.push(selections1);
        }
        
        if(sessionRecord.hasOwnProperty("Preference_2_Date__c") && Boolean(sessionRecord.isPref2InFuture)) {    
            var selections2 = {};
            selections2["date"] = sessionRecord.pref2DateUserFriendly;
            selections2["period"] = sessionRecord.Preference_2_Period__c;
            if(sessionRecord.hasOwnProperty("Preference_2_Time__c")) {
                selections2["timeOptions"] = ["Select time",sessionRecord.Preference_2_Time__c];
            } else {
                selections2["timeOptions"] = timeOptions[sessionRecord.Preference_2_Period__c];
            }
            sessionTimeDefinitions.push(selections2);
        }
        
        if(sessionRecord.hasOwnProperty("Preference_3_Date__c") && Boolean(sessionRecord.isPref3InFuture)) {    
            var selections3 = {};
            selections3["date"] = sessionRecord.pref3DateUserFriendly;
            selections3["period"] = sessionRecord.Preference_3_Period__c;
            if(sessionRecord.hasOwnProperty("Preference_3_Time__c")) {
                selections3["timeOptions"] = ["Select time",sessionRecord.Preference_3_Time__c];
            } else {
                selections3["timeOptions"] = timeOptions[sessionRecord.Preference_3_Period__c];
            }
            sessionTimeDefinitions.push(selections3);
        }
        return sessionTimeDefinitions;  
        
    },
    
    resetDropboxesAndSelectedTimes : function(component, event, helper, sessionIndex) {
        var picklistCmps = component.find("available-times");
        
        if(Array.isArray(picklistCmps)) {
            for(var ind in picklistCmps) {
                picklistCmps[ind].set("v.value", "Select time");
                // Also disable rows that have not been checked
                if(ind != sessionIndex){
                    picklistCmps[ind].set("v.disabled", true);
                } else {
                    picklistCmps[ind].set("v.disabled", false);
                }
            }
        } else {
            picklistCmps.set("v.value", "Select time");
        }
        component.set("v.selectedInfoSessionStartTime", undefined);
        component.set("v.selectedInfoSessionEndTime", undefined);
        component.set("v.selectedInfoSessionDate", undefined);
        
    },
    
    pageTurn : function(component, direction) {
        var page = component.get("v.pageNumber") || 1;
        // get the select option (drop-down) values.   
        var recordsToDisplay = component.find("recordSize").get("v.value");
        page = (direction === "previous") ? (page - 1) : (page + 1);
        
        var controllerSearchMethod = component.get('c.doSearch');
        component.set("v.isLoading", true);
        component.set("v.pageNumber", page);
        $A.enqueueAction(controllerSearchMethod);  
    },
    
    deselectAllCheckboxes : function(component, event, helper, selectedRowInd) {
        var ind = 0;
        if(Array.isArray(component.find("sessionTimingConfirmationBox"))){
            component.find("sessionTimingConfirmationBox").reduce(function(validSoFar, inputCmp){
                if(ind != selectedRowInd) {
                    inputCmp.set("v.value", false);
                }
                ind++;
            },true);
        }
    },
    
    handleTimeSelectionHelper : function(component, event, helper, selectedStartTime) {
        
        selectedStartTime = event.getSource().get("v.value");
        
        var findTimeInAnHourArr = ["07:00","07:30","08:00","08:30","09:00","09:30",
                                   "10:00","10:30","11:00","11:30","12:00","12:30",
                                   "13:00","13:30","14:00","14:30","15:00","15:30",
                                   "16:00","16:30","17:00","17:30","18:00","18:30",
                                   "19:00","19:30","20:00","20:30","21:00","21:30",
                                   "22:00","22:30"];
        var nextHourInd = findTimeInAnHourArr.indexOf(selectedStartTime) + 2;
        
        var calculatedSessionEndTime = findTimeInAnHourArr[nextHourInd];
        component.set("v.selectedInfoSessionStartTime", selectedStartTime);
        component.set("v.selectedInfoSessionEndTime", calculatedSessionEndTime);
        
        var dfEventRecord = component.get("v.sessionDetail");
        dfEventRecord["Event_Date_Time__c"] = component.get("v.selectedInfoSessionDate") + "T" + selectedStartTime + ":00.000+0000";
        
        if(selectedStartTime == "Select time" || selectedStartTime == "" || $A.util.isUndefined(selectedStartTime)) {
            // Deselect the checkbox as selection is erroneous
            component.set("v.validForSubmission", false);
            component.set("v.selectedInfoSessionStartTime", undefined);
            component.set("v.selectedInfoSessionEndTime", undefined);
        } else {
            // Select the active checkbox
            component.set("v.validForSubmission", true);
        }
    },
    
    signupForSession : function(component) {
        
        var dfEvent = component.get("v.sessionDetail");
        var action = component.get("c.updateInfoSession");
        var savedDate = component.get("v.selectedInfoSessionDate");
        
        action.setParams({
            "dfEventId" : dfEvent["Id"],
            "eventDateStr" : savedDate.split("-")[2] + "-" + savedDate.split("-")[1] + "-" + savedDate.split("-")[0],
            "eventStartTime" :  component.get("v.selectedInfoSessionStartTime"),
            "eventEndTime" : component.get("v.selectedInfoSessionEndTime"),
            "championId" : (component.get("v.dfContactId")!="null") ? component.get("v.dfContactId") : 'a0311000006tgPwAAI'       
        })  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var popup = component.find("signup-model");
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                popup.signupMessage(true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log(JSON.stringify(errors));
                popup.signupMessage(false);
            }
        });
        $A.enqueueAction(action);
                
    },
    
    gotoManageMySessionsPage : function (component, event, helper) {
        
        window.location.href = "/WEBChampion?fdBackSubmitted=true";
    }
    
})