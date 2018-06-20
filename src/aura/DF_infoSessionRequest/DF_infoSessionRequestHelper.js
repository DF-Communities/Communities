({    
    publishStylingFrameworkToApp : function(component) {
        
        var useSldsAsSetInLightningOutApp = component.get("v.useSlds");
        component.set("v.useSlds", useSldsAsSetInLightningOutApp);
        var appEvent = $A.get("e.c:SldsVsCustomStylingEvt");
        appEvent.setParam("useSlds", useSldsAsSetInLightningOutApp);
        appEvent.fire();
        console.log("useSlds?: " + useSldsAsSetInLightningOutApp);
        
    },
    
    preventFormSubmit : function(component, helper) {
        component.set("v.formIsInvalid", true);
        helper.resetStateProgressIndicators(component);
        return false;
    },
    
    verifyDatePeriodPairs : function(component, event, helper, eventRec) {
        
        var noRows = component.get("v.numRows");

        // Check the first row
        if(($A.util.isUndefined(eventRec.Preference_1_Date__c) && !$A.util.isUndefined(eventRec.Preference_1_Period__c))
           || (!$A.util.isUndefined(eventRec.Preference_1_Date__c) && $A.util.isUndefined(eventRec.Preference_1_Period__c))
           || eventRec.Preference_1_Period__c == '') {
            return "1";
        } else if(noRows >= 2
        	&& (
                ($A.util.isUndefined(eventRec.Preference_2_Date__c) && !$A.util.isUndefined(eventRec.Preference_2_Period__c))
            	|| (!$A.util.isUndefined(eventRec.Preference_2_Date__c) && $A.util.isUndefined(eventRec.Preference_2_Period__c))
                || eventRec.Preference_2_Period__c == ''
               )) {
            return "2";
        } else if(noRows >= 3
            && (
                ($A.util.isUndefined(eventRec.Preference_3_Date__c) && !$A.util.isUndefined(eventRec.Preference_3_Period__c))
                || (!$A.util.isUndefined(eventRec.Preference_3_Date__c) && $A.util.isUndefined(eventRec.Preference_3_Period__c))
                || eventRec.Preference_3_Period__c == ''
               )) {
            return "3";
        } else if($A.util.isUndefined(eventRec.Preference_1_Date__c) && $A.util.isUndefined(eventRec.Preference_1_Period__c)) {
            return "0";
        } else {
            return 'valid';
        }
        
    },
    
    executeAction: function(component, action, callback) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retVal=response.getReturnValue();
                    resolve(retVal);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log(JSON.singify(errors));
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
    
    defineCommunityInfoAction : function(component) {
        var action = component.get("c.getEnvironmentDomains");
        return action;
    },
    
    /*getCommunityLoginUrl : function(component) {
        
        var action = component.get("c.getEnvironmentDomains");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state==="SUCCESS") {
                var valuesMap = response.getReturnValue();
                component.set("v.communityUrl", "https://" + valuesMap["communityDomain"]);
                console.log("Setting vfHost to: " + valuesMap["communityDomain"]);
                component.set("v.vfHost", valuesMap["communityDomain"]);
            } else {
                return null;
            }
            
        })
        $A.enqueueAction(action);
    },*/
    
    defineUserInfoAction : function(component, userId) {
        var action = component.get("c.getSiteUserInfo");
        action.setParams({"userId" : userId});
        return action;
    },
    
    parseCommInfoResponse : function(component, response) {
        
        // SET UP LISTENER FOR INCOMING EVENTS OUTSIDE OF LIGHTNING
        console.log(JSON.stringify(response));
        
        component.set("v.communityUrl", "https://" + response["communityDomain"]);
        component.set("v.vfHost", response["vfCmpOriginDomain"]);
        var vfOrigin = "https://" + component.get("v.vfHost");
        console.log('vfOrigin: ' + vfOrigin);
        window.addEventListener("message", function(payload) {
            console.log('In postmessage');
            if (payload.origin !== vfOrigin) {
                console.log('Not the expected origin (expected ' + payload.origin + ' but got ' + vfOrigin + '): Reject the message!')
                return;
            }
            
            if(payload.data.cmp=='pca') {
                
                // Set the height of the iframe accordingly
                if (payload.data.isValid) {
                    component.set("v.addrContainerHeight", "360px;");
                } else {
                    component.set("v.addrContainerHeight", "480px;");
                }
                component.set("v.addressValuesMapFromVf", payload.data.body); 
                
            } else if(payload.data.cmp=='captcha') {
                
                if(false) {
                    // Set the height dependent on whether the device is recognised or not
                    component.set("v.captchaContainerHeight", "100px;");
                } else {
                    // Set the height dependent on whether the device is recognised or not
                    component.set("v.captchaContainerHeight", "820px;");
                }
                component.set("v.isHumanCaptchaResult", payload.data.body);  
                console.log("Set catpcha result in lightning to: " + payload.data.body);
                
            }
            
        }, false);
    },
    
    parseGetUserInfoResponse : function(component, response) {
        
        // Set the various component attributes from the response
        var responseMap = response;
        component.set("v.userIdentifiersMap", responseMap);
        component.set("v.dfContactId", responseMap["dfContactId"]);
        component.set("v.isChampion", responseMap["isChampion"]);
        
        if(responseMap["portalContactId"] != null) {
            component.set("v.hasCommunityAccount", true);
            component.set("v.isAnonymous", false);
            component.set("v.isCommunityApp", true);
        }
        
        component.set("v.numRequestsMade", responseMap["numExistingRequests"]);
        component.set("v.blockRequests", responseMap["blockSessionRequests"]);
        component.set("v.tooManyOpenRequests", responseMap["tooManyOpenRequests"]);
        
        var dfContactObj = component.get("v.dfContact");
        dfContactObj["Id"] = responseMap["dfContactId"];
        component.set("v.dfContact", dfContactObj);
        
        var dfDemographicObj = component.get("v.dfContactDemographic");
        dfDemographicObj["Id"] = responseMap["portalContactId"];
        component.set("v.dfContactDemographic", dfDemographicObj);
        
        var dfEventObj = component.get("v.dfEvent");
        dfEventObj["Session_Requester__c"] = responseMap["dfContactId"];
        component.set("v.dfEvent", dfEventObj);
    },
    
    defineOrgMembershipAction : function(component) {
        
        var action = component.get("c.getPartnerOrgs");
        action.setParam("dfContactId", component.get("v.dfContactId"));
        return action;
        
    },
    
    parsePartnerOrgResponse : function(component, response) {
        var apexMapList = response;
        var isObjectEmpty = !Object.keys(apexMapList).length;
        if(isObjectEmpty) {
            component.set("v.contactIsPoAdmin", false);
        } else {
            component.set("v.contactIsPoAdmin", true);
        }
        component.set("v.memberOrgs", apexMapList);
    },
        
    populateEventAddrFields : function(component, dfEvent) {
        // Get the address fields from the generic address component
        var childComponent = component.find("locationCard");
        var cardParams = childComponent.getAllParams(); 
        
        dfEvent.Street__c = cardParams.params.addressLine1;
        dfEvent.City__c = cardParams.params.city;
        dfEvent.County__c = cardParams.params.county;
        dfEvent.Postcode__c = cardParams.params.postcode;
        
        return dfEvent;
    }, 
    
    populateEventTimePreferenceFields : function(component, dfEvent) {
        // Get the fields from the custom dynamicRow component that contains the preferences for  session times
        var childComponent = component.find("schedulingCard");
        var cardParams = childComponent.getAllParams(); 
        cardParams = cardParams[0];
        
        if(Array.isArray(cardParams)) {
            
            // Preferences have been entered
            for(var index in cardParams) {
                var prefNo = parseInt(index) + 1;
                var datefieldName = "Preference_" + prefNo + "_Date__c";
                var periodfieldName = "Preference_" + prefNo + "_Period__c";
                var timefieldName = "Preference_" + prefNo + "_Time__c";
                
                dfEvent[datefieldName] = cardParams[index].params.date;
                dfEvent[periodfieldName] = cardParams[index].params.period;
                dfEvent[timefieldName] = cardParams[index].params.time;
                
                console.log("date: " + cardParams[index].params.date);
                console.log("period: " + cardParams[index].params.period);
                console.log("time: " + cardParams[index].params.time);
                
                // Set the required Event_Date_... fields as the initial preference
                // until a champion selects the option they can make            
                if(parseInt(index)==0) {
                    
                    var selectedPeriod = cardParams[index].params.period;
                    var contrivedStartTime = null;
                    var contrivedEndTime = null;
                    if(selectedPeriod == "Morning (7am-12pm)") {
                        contrivedStartTime = "09:00";
                        contrivedEndTime = "10:00";
                    } else if(selectedPeriod == "Afternoon (12pm-5pm)") {
                        contrivedStartTime = "17:00";
                        contrivedEndTime = "18:00";
                    } else if(selectedPeriod == "Evening (5pm-10pm)") {
                        contrivedStartTime = "20:00";
                        contrivedEndTime = "21:00";
                    } else if(selectedPeriod == "Any time") {
                        contrivedStartTime = "19:00";
                        contrivedEndTime = "20:00";
                    } else if(selectedPeriod == "Specific time (hh:mm)") {
                        contrivedStartTime = cardParams[index].params.time;
                        contrivedEndTime = cardParams[index].params.time;
                    }
                } 
            }
        } else {
            //Set error to fill out preferences
            console.log('populateEventTimePreferenceFields is pointless: ');
        }
        
        return dfEvent;
    },
    
    validateCardFields : function(component, cardAuraId) {
        
        var childComponent = component.find(cardAuraId);
        
    },
        
    createRecords : function(component, helper, dfContact, dfDemographicInfo, dfEvent, gpdrFields) {
        
        component.set("v.submissionFailed", false);
        component.set("v.isSuccessfulFormSubmission", false);
        
        var action = component.get("c.createInfoSessionReqRecords");
        component.set("v.dfContactId", component.get("v.userIdentifiersMap").dfContactId);
        
        action.setParams({
            "formContactData" : dfContact,
            "formDemographicData" : dfDemographicInfo,
            "formEventData" : dfEvent,
            "formGdprPrefs" : gpdrFields,
            "dfContactId" : component.get("v.dfContactId"),
            "newUserPassword" : component.get("v.userEnteredPassword")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state==="SUCCESS") {
                console.log("createRecords is successful");
                component.set("v.isSuccessfulFormSubmission", true);
                var responseMap = response.getReturnValue();
                // Set the contact Id
                if(component.get("v.isAnonymous")) {
                    component.set("v.dfContactId", responseMap.dfContactId);
                    component.set("v.isAnonymous", false);
                }
                
                if(responseMap.hasOwnProperty('errors')) {
                    console.log("One or more dml operations failed. Record was not created. " + 
                                "This should only be due to a server failure if the form validation is sufficient");
                } else {
                    // Update the number of sessions on against the user
                    var prevNoRequests = component.get("v.numRequestsMade");
                    component.set("v.numRequestsMade", prevNoRequests + 1);   
                }
                
                // Hide the form and show the confirmation message
                helper.setFormVisibility(component, helper);
                
            } else if(state==="ERROR"){
                console.log("createRecords is unsuccessful");
                component.set("v.submissionFailed", true);
                
                var errors = response.getError();
                var errMsg = '';
                for (var e in errors) {
                    for (var statusCode in errors[e].pageErrors) {
                        if (errors[e].pageErrors[statusCode].statusCode == 'DUPLICATE_VALUE') {
                            component.set('v.hasError', true)
                            errMsg += "A user already exists with this email address. Please log in or reset your password";
                        } else {
                            errMsg += JSON.stringify(errors[e].pageErrors);
                        }
                    }
                }
                if(errMsg != '') {
                	component.set("v.erroneousSubmissionMessage",errMsg);
                }
                component.set("v.isSuccessfulFormSubmission", false);
            }
            
            helper.resetStateProgressIndicators(component);
            
        })
        $A.enqueueAction(action);
    },
    
    setFormVisibility : function(component, helper) {  
        
        var requestForm = component.find("request-form");
        var submitCmp = component.find("confirmation-section");
        
        $A.util.toggleClass(requestForm, "hide-section");        
        $A.util.toggleClass(submitCmp, "hide-section"); 
        
        document.body.scrollTop = 0; // For Safari
        document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
        
    },
    
    resetStateProgressIndicators : function(component) {
        // Clear loading icons and other indicators that show an action is in progress
        component.set("v.isLoading", false);
        component.set("v.isFormSubmissionInProgress", false);
    },
    
    fireValidationMessageFromLightningToVfAddr : function(component, isLocationCardValid) {
        console.log('In fireValidationMessageFromLightningToVfAddr');
        if(!isLocationCardValid) {
            var vfWindow = component.find("vfAddressForm").getElement().contentWindow;
            var message = isLocationCardValid;
            console.log(message);
            console.log(component.get("v.vfHost"));
            vfWindow.postMessage(message, "https://"+component.get("v.vfHost"));
            console.log('Completed fireValidationMessageFromLightningToVfAddr');
        }
    },
    
    fireValidationMessageFromLightningToVfCaptcha : function(component) {
        if(!isLocationCardValid) {
            //var vfOrigin = "https://uat-alzheimerscommunities.cs81.force.com";
            var vfWindow = component.find("vfCaptchaForm").getElement().contentWindow;
            var message = true;
            vfWindow.postMessage(message, component.get("v.vfHost"));
        }
    }
    
})