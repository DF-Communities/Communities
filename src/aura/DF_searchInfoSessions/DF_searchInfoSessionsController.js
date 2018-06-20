({
    doInit : function(component, event, helper) {
        
        component.set("v.useSlds", false);
        helper.publishStylingFrameworkToApp(component);
        component.set("v.isLoading", true);
        
        // Set the default times on a session to 09:00 by default.
        // This is what the picklists will show on load. 
        component.set("v.selectedInfoSessionStartTime", "09:00");
        component.set("v.selectedInfoSessionEndTime", "10:00");
        component.set("v.radius",50);
        
        var unformattedStartDate = new Date();
        var defaultStartDate = helper.getFormattedDate(unformattedStartDate);
        component.set("v.startDate", defaultStartDate);

        var unformattedEndDate = new Date(unformattedStartDate.getFullYear(), unformattedStartDate.getMonth() + 2, unformattedStartDate.getDate());
        var defaultEndDate = helper.getFormattedDate(unformattedEndDate);

        component.set("v.endDate", defaultEndDate);
        console.log("## End Date set on it saerch ....." + component.get("v.endDate"));
        component.set("v.isResultsView", "true");
        
        // Chaining asynchronous server calls
        var userInfoAction = component.get("c.getSiteUserInfo"); // We need to get the user identifying information first
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var params={"userId":userId};
        userInfoAction.setParams(params);
        
        var userInfoPromise = helper.executeAction(component, userInfoAction);
        
        userInfoPromise.then(
            $A.getCallback(function(result){
                helper.parseGetSiteUserInfoResponse(component, result);
                
                var getEventsAction = helper.defineApexGetEventsAction(component, true);
                var eventsPromise=helper.executeAction(component, getEventsAction);
                return eventsPromise;
            })
        )
        .then(
            $A.getCallback(function(result){
                // We have run the second method, handle its output here
                helper.parseGetEventsResponse(component, result);
                
                // Send out the number of returned events to the parent VF page
                var vfDestinedEvent = $A.get("e.c:DF_PublishNoEventsInChampRadius");
                vfDestinedEvent.setParam("noSessionsInChampRadius", component.get("v.total"));
                vfDestinedEvent.fire();
                component.set("v.isLoading", false);
            })
        )
        .catch(
            $A.getCallback(function(error){
                // Something went wrong
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
    
    handleStylingFramework: function(component, event, helper) {
        var isSlds = event.getparam("useSlds");
        component.set("v.useSlds", isSlds);
    },
    
    handleDatePickSelection : function(component, event, helper) {
        var datePickerName = event.getSource().get("v.name");
        console.log("### handleDatePickSelection " + event.getSource().get("v.value"));
        if (!$A.util.isEmpty(event.getSource().get("v.value"))) {
            if(datePickerName == "startDate" ) {
                component.set("v.startDate", event.getSource().get("v.value"));
            } else if(datePickerName == "endDate") {
                component.set("v.endDate", event.getSource().get("v.value"));
            }
        }
    },
    
    unfilteredSearch : function(component, event, helper) {
        
        var startDateCmp = component.find("startDate");
        startDateCmp.reset();
        var endDateCmp = component.find("endDate");
        endDateCmp.reset();
                
        component.set("v.dateError", false);
        var startDate = new Date();
        component.set("v.startDate", startDate.getFullYear() + "-" + (startDate.getMonth()+1) + "-" + startDate.getDate());
        component.set("v.endDate", "3000-01-01");
        component.set("v.radius", 100000);
        var sessionType = component.find("sessionTypePicklist").set("v.value","");
        var action = component.get("c.doSearch");
        $A.enqueueAction(action);
    },
    
    doSearch : function(component, event, helper) {
		component.set("v.noErrorsOnSubmit", false); 
        component.set("v.errorsOnSubmit", false);
        component.set("v.isLoading", true);
        component.set("v.dateError", false);
        component.set("v.isDetailView", false);
        component.set("v.selectedInfoSessionStartTime", "");
        component.set("v.selectedInfoSessionEndTime", "");
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");
        
        if(startDate > endDate || startDate == null || endDate == null) {
            component.set("v.dateError", true);
            component.set("v.isLoading", false);
        } else {
            component.set("v.dateError", false);
            component.set("v.isResultsView", "true");
            var eventsAction = helper.defineApexGetEventsAction(component, false);
            var eventsPromise=helper.executeAction(component, eventsAction);
            
            eventsPromise.then(
                $A.getCallback(function(result){
                    // We have run the second method, handle its output here
                    helper.parseGetEventsResponse(component, result);
                    component.set("v.isLoading", false);
                })
            )
            .catch(
                $A.getCallback(function(error){
                    // Something went wrong
                    if (error) {
                        console.log("Error is: " + JSON.stringify(error));
                        if (error[0] && error[0].message) {
                            console.log("Error message: " + 
                                        error[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                })
            );            
        }		
        
    },
    
    setSearchRadius : function(component, event, helper) {
        var selectedRadius = parseInt(event.getSource().get("v.value"));
        componet.set("v.radius", selectedRadius);  
    },
    
    showSessionDetails : function(component,event,helper) {
        
        var sessionIndex = event.getParam("index");
        var sessionRecord = component.get("v.searchResults")[sessionIndex];
        
        component.set("v.isResultsView", "false");
        component.set("v.isDetailView", "true");
        component.set("v.sessionDetail", sessionRecord);
        
        // Set Google Map Parameters
        var mapData = [];
        var locationEntry = {};
        locationEntry.lat = sessionRecord.Location_Geographic_Details__c.latitude;
        locationEntry.lng = sessionRecord.Location_Geographic_Details__c.longitude;
        locationEntry.markerText = "Test";
        mapData.push(locationEntry);
        component.set("v.mapData", mapData);
        
        var mapOptionsCenter = {"lat" : locationEntry.lat, "lng" : locationEntry.lng};
        component.set("v.mapOptionsCenter", mapOptionsCenter);
        
        var sessionTimeDefinitions = helper.createSessionTimeStructure(component, sessionRecord);
        component.set("v.sessionTimeDefinitions", sessionTimeDefinitions);        
        component.set("v.sessionTimeDefinitions", sessionTimeDefinitions);
    },
    
    previousPage: function(component, event, helper) {
       helper.pageTurn(component, "previous");  
    },
    
    nextPage: function(component, event, helper) {
        helper.pageTurn(component, "next");
    },
    
    searchWithNewRecordsOfDisplay : function(component, event, helper) {
        // this function call on the select opetion change,	 
        var recordToDisply = component.find("recordSize").get("v.value");
        component.set("v.recordsToDisplay", recordToDisply);
        component.set("v.pageNumber", 1);
        var a = component.get('c.doSearch');
        $A.enqueueAction(a);
    },
    
   
    /*
     * Method run on checkbox selections
    */
    handleConfirmSessionTimings : function(component, event, helper) {
        
        var sessionIndex = event.getSource().get("v.name");
        component.set("v.sessionIndex", sessionIndex);
        component.set("v.errorsOnSubmit", false);
        helper.resetDropboxesAndSelectedTimes(component, event, helper, sessionIndex);
        helper.deselectAllCheckboxes(component, event, helper, sessionIndex);
       
        var selectedSessionScheduleObj = component.get("v.sessionTimeDefinitions")[sessionIndex];
        
        var selectedStartTime;
        var date = selectedSessionScheduleObj.date;
        // Because the lightning replace function does not work for forward slash (str.replace(/\//g, "-") replace by using indices
        var slashDayMonthInd = date.indexOf('/');
        var slashMonthYearInd = date.lastIndexOf('/');
        var dateSfdcFormat = date.substring(0,slashDayMonthInd) + '-' + date.substring(slashDayMonthInd+1,slashMonthYearInd) + '-' + date.substring(slashMonthYearInd+1);
        
        var dfEventRecord = component.get("v.sessionDetail");

        component.set("v.selectedInfoSessionDate", dateSfdcFormat);
        dfEventRecord["Event_Date__c"] = dateSfdcFormat;        
        dfEventRecord["Event_End_Date__c"] = dateSfdcFormat;    
        
    },
    
    handleTimeSelection : function(component, event, helper) {
        component.set("v.errorsOnSubmit", false);
        helper.handleTimeSelectionHelper(component, event, helper);
    },
    
    toggleOrganiserDetailsVisibility : function(component, event, helper) {
        
        var currentState = component.get("v.showSessionOrganiserDetails");
        var newState;
        if(currentState) {
            newState = false;
        } else {
            newState = true;
        }
        component.set("v.showSessionOrganiserDetails", newState);
    },
    
    /*
     *	This method only controls the visibility of the confirmation popup 
     */
    startSessionSignUpJourney : function(component, event, helper) {
        event.preventDefault();
        // A valid submission has a date, start time and end time
        var formIsValid = true;
        if($A.util.isEmpty(component.get("v.selectedInfoSessionStartTime"))){
            formIsValid = false;
        } else if($A.util.isEmpty(component.get("v.selectedInfoSessionEndTime"))){
            formIsValid = false;
        } if($A.util.isEmpty(component.get("v.selectedInfoSessionDate"))){
            formIsValid = false;
        }
	    
        if(formIsValid){ 
            component.set("v.noErrorsOnSubmit", true);
        } else {
            helper.resetDropboxesAndSelectedTimes(component, event, helper);
            helper.deselectAllCheckboxes(component, event, helper);
            component.set("v.errorsOnSubmit", true);
        }
    },
    
    handleCancelSignup : function(component, event, helper) {
        component.set("v.isDetailView", false);
        component.set("v.noErrorsOnSubmit", false);
        component.set("v.errorsOnSubmit", false);
        doSearch(component, event, helper);
    },
    
    handleConfirmedSignup : function(component, event, helper) {
        // Update the event record
        component.set("v.signupConfirmation", true);
        helper.signupForSession(component);
        
    },
    
    exit : function(component, event, helper) {
        component.set('v.isDetailView', false);
    }
})