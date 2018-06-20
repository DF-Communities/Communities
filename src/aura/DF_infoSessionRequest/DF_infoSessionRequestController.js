({
    
    populateEventTimingPref : function(component, event, helper) {
        var dfEvent = component.get("v.dfEvent");
        var dfEventFieldName = event.getParam("fieldApiName");
        var dfEventFieldValueStr = event.getParam("fieldValueStr");
        var dfEventFieldValueDate = event.getParam("fieldValueDate");
        
        if($A.util.isUndefined(dfEventFieldValueStr)) {
            dfEvent[String(dfEventFieldName)] = dfEventFieldValueDate;
        } else {
            dfEvent[String(dfEventFieldName)] = dfEventFieldValueStr;
        }
        component.set("v.dfEvent", dfEvent);
    },
    
    showSpinner : function(component, event, helper) {
        component.set("v.isLoading", true);
    },
    
    hideSpinner : function(component, event, helper) {
        component.set("v.isLoading", false);
    },
    
    /*
     * This method runs on page load and performs a number of 
     * initialization operations as well as
     * chained asynchronous calls to Apex
     */ 
    doInit : function(component, event, helper) {
        
        // === PUBLISH SYLING FRAMEWORK TO APP
        component.set("v.isLoading", true);
        var eventId = component.get("v.eventId");
        component.set("v.eventId", eventId);
        helper.publishStylingFrameworkToApp(component);
        
        // === GET THE COMMUNITY LOGIN DOMAIN FOR LINKS
        var commInfoAction = helper.defineCommunityInfoAction(component);
        var commInfoPromise = helper.executeAction(component, commInfoAction);
        
        commInfoPromise.then(
            $A.getCallback(function(result){
                console.log('commInfoPromise succeeded');
                helper.parseCommInfoResponse(component, result);                
            })
        ).catch(
            $A.getCallback(function(error){
                // Something went wrong
                if (error) {
                    console.log("An error occurred while trying to retrieve the community info");
                }
            })
        );
        //helper.getCommunityLoginUrl(component);
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");        
        if($A.util.isUndefined(userId)) {
            // Show anonymous entry page
            component.set("v.isAnonymous", true);
            component.set("v.isLoading", false);
            component.set("v.userJourneyStep",1);
        } else {
            
            // === BEGIN ORDER-SPECIFIC, CHAINED ASYNC OPERATIONS
            
            // 1) Get the user info
            var userInfoAction = helper.defineUserInfoAction(component, userId);
            var userInfoPromise = helper.executeAction(component, userInfoAction);
            
            userInfoPromise.then(
                $A.getCallback(function(result){
                    helper.parseGetUserInfoResponse(component, result);
                    
                    // 2) Get any partner orgs for which the user is a PO Admin 
                    var partnerOrgAction = helper.defineOrgMembershipAction(component);
                    var partnerOrgPromise = helper.executeAction(component, partnerOrgAction);
                    
                    return partnerOrgPromise;
                })
            ).then(
                $A.getCallback(function(result){
                    // We have run the second method, handle its output here
                    helper.parsePartnerOrgResponse(component, result);
                    
                    /*var eventId = component.get("v.eventId");
                    
                    if(!$A.util.isUndefined(eventId) && eventId != ""){
                        helper.populateFormWithExistingEvent(component, eventId);
                    }*/
                    
                    // Set the landing page
                    component.set("v.userJourneyStep", 1);
                    component.set("v.isLoading", false);
                })
            ).catch(
                $A.getCallback(function(error){
                    // Something went wrong
                    if (error) {
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
    
    handleProceedToForm : function(component, event, helper) {
        
        component.set("v.useSlds", event.getParam("useSlds"));
        
        if(component.get("v.isAnonymous")) {
            component.set("v.userJourneyStep", 2); 
        } else {
            component.set("v.userJourneyStep", 3); 
        }
        
    },
    
    handleAddressChange : function(component, event, helper) {
        var params = component.get("v.addressValuesMapFromVf");
        
        // First update the fields on the event
        var dfEvent = component.get("v.dfEvent");
        dfEvent.Street__c = params["street1"] + ',' + params["street2"] + ',' + params["street3"];
        dfEvent.City__c = params["city"];
        dfEvent.County__c = params["county"];
        dfEvent.Postcode__c = params["postcode"];
        component.set("v.dfEvent", dfEvent);
        console.log('Saved these params to dfEvent' + JSON.stringify(params));
        
        var appEvent = $A.get("e.c:STD_addressChangeEvt");
        appEvent.setParam("payload", params);
        appEvent.fire();
        
    },
    
    /* handleCaptchaChange : function(component, event, helper) {
        console.log("In handleCaptchaChange  ");
    },*/
    
    handleMemberNonMember : function(component, event, helper) { // TRy to comment
        var value = event.getSource().get("v.value");
        if (value=="notRegistered") {
            component.set("v.hasCommunityAccount", false);
            component.set("v.userJourneyStep", 3);
        } else if (value=="alreadyFriend") {
            component.set("v.hasCommunityAccount", true);
        }
        if (value=="unselected") {
            component.set("v.isFormUntouched", true);
        } 
    },
    
    handleAnonEvt : function(component, event, helper) {
        if(!$A.util.isUndefined(event.getParam("hasCommunityAccount"))) {
            component.set("v.hasCommunityAccount", event.getParam("hasCommunityAccount"));
        } 
        if(!$A.util.isUndefined(event.getParam("userJourneyStep"))) {
            component.set("v.userJourneyStep", event.getParam("userJourneyStep"));
        } 
        if(!$A.util.isUndefined(event.getParam("isFormUntouched"))) {
            component.set("v.isFormUntouched", event.getParam("isFormUntouched"));
        } 
    },
    
    schedulingCardFocus : function(component, event, helper) {
        console.log("Changing currentCardInFocusId to schedulingCardFocus");
        component.set("v.currentCardInFocusId", "schedulingCard");
    },
    
    locationCardFocus : function(component, event, helper) {
        console.log("Changing currentCardInFocusId to: locationCard");
        component.set("v.currentCardInFocusId", "locationCard");
    },
    
    registrationCardFocus : function(component, event, helper) {
        console.log("Changing currentCardInFocusId to: registrationCard");
        component.set("v.currentCardInFocusId", "registrationCard");
    },
    
    contactCardFocus : function(component, event, helper) {
        console.log("Changing currentCardInFocusId to: contactDetailsCard");
        component.set("v.currentCardInFocusId", "contactDetailsCard");
    },
    
    handleCardFocusChange : function(component, event, helper) {
        
        var prevCardInFocus = event.getParam("oldValue"); 
        var curCardInFocus = event.getParam("value");
        component.set("v.currentCardInFocusId", curCardInFocus);
        
        if(prevCardInFocus != "null" && curCardInFocus != prevCardInFocus) {
            
            helper.validateCardFields(component, prevCardInFocus);
            console.log("handleCardFocusChange run complete");
        }
        
    },
    
    handlePasswordEntry : function(component, event, helper) {
        var password = event.getParam("passwordValue"); 
        component.set("v.userEnteredPassword", password);
        
    },
    
    
    handleContactDetailsValidity : function(component, event, helper) {
        
        var evtVar = event.getParam("areContactDetailsValid");
        component.set("v.areContactDetailsValid", evtVar);
        component.set("v.userEnteredPassword", event.getParam("password"));
        
    },
    
    handleAddressDetailsValidity : function(component, event, helper) {
        
        var evtVar = event.getParam("areAddressDetailsValid");
        component.set("v.areAddressDetailsValid", evtVar);
        
    },
    
    handleThirdPartySafetyMarshalInfo : function(component, event, helper) {
        var isComplete = event.getParam("isComplete");
        component.set("v.thirdPartySafetyMarshalDetailsComplete", isComplete);
    },
    
    handleSessionTimeValidity : function(component, event, helper) {
        
        var evtVar = event.getParam("isSessionDetailComplete");
        component.set("v.areSessionTimesValid", evtVar); 
        
    },
    
    handleSessionVisibility : function(component, event, helper) {
        var evtVar = event.getParam("isSessionPublic");
        component.set("v.isSessionPublic", evtVar);        
    },    
    
    handlePrepopulatedSession : function(component, event, helper) {
        component.set("v.isSuccessfulFormSubmission", false);
        helper.setFormVisibility(component, event, helper);
    },
    
    captureNoRows : function(component, event, helper) {
        console.log('Cptued row count event');
        console.log('event: ' + JSON.stringify(event.getParams()));
    	var newNoRows = event.getParam("newTotalNoRows");
        console.log('Setting rows to: ' + newNoRows);
        component.set("v.numRows", newNoRows);
    },
    
    validateAndSubmitForm : function(component, event, helper) {
        
        // Disable the button to prevent duplicate requests
        component.set("v.isFormSubmissionInProgress", true);
        component.set("v.formIsInvalid", false);
        component.set("v.isLoading", true);
        
        // Validate Scheduling
        var cardValidityArr = [];
        if(!$A.util.isUndefined(component.find('contactDetailsCard'))) {
            cardValidityArr.push(component.find('contactDetailsCard').validateRequiredFields());
            console.log('contactDetailsCard validity: ' + cardValidityArr[cardValidityArr.length-1]);
        }
        if(!$A.util.isUndefined(component.find('schedulingCard'))) {
            cardValidityArr.push(component.find('schedulingCard').validateRequiredFields());
            console.log('schedulingCard validity: ' + cardValidityArr[cardValidityArr.length-1]);
        }
        if(!$A.util.isUndefined(component.find('locationCard'))) {
            var isLocationCardValid = component.find('locationCard').validateRequiredFields();
            cardValidityArr.push(isLocationCardValid);
            console.log('locationCard validity: ' + isLocationCardValid);
            if (isLocationCardValid) {
                component.set("v.addrContainerHeight", "360px;");
            } else {
                component.set("v.addrContainerHeight", "650px;");
            }
            helper.fireValidationMessageFromLightningToVfAddr(component, isLocationCardValid);
        }
        if(!$A.util.isUndefined(component.find('registrationCard'))) {
            cardValidityArr.push(component.find('registrationCard').validateRequiredFields());
            console.log('registrationCard validity: ' + cardValidityArr[cardValidityArr.length-1]);
        }
        
        // Form field validity check
        var isMainFormValid;
        if(cardValidityArr.indexOf(false) == -1) {
            isMainFormValid = true;
        } else {
            isMainFormValid = false;
        }
        
        var eventFields = component.get("v.dfEvent");
        // Perform more specific validations
        var datePeriodValidationOutcome = helper.verifyDatePeriodPairs(component, event, helper, eventFields);
        if(datePeriodValidationOutcome!= 'valid') {
            component.set("v.erroneousFormSubmitMessage", "The date and period have not been entered correctly" + 
                          (datePeriodValidationOutcome === "0" ? "" : " on row " + datePeriodValidationOutcome) +
                          ". Please amend them as required.");
            isMainFormValid = helper.preventFormSubmit(component, helper);
            
        } else if(component.get("v.noInsurance")) {
            component.set("v.erroneousFormSubmitMessage", "Venues must be insured");
            isMainFormValid = helper.preventFormSubmit(component, helper);
            
        } else if(component.get("v.publicSessionSearchOnly")){
            component.set("v.erroneousFormSubmitMessage", "For group sizes of 10 or less, you must book onto an existing public Session");
            isMainFormValid = helper.preventFormSubmit(component, helper);
            
        } else if(!component.get("v.isHealthSafetyPersonKnown") 
                  && !component.get("v.thirdPartySafetyMarshalDetailsComplete")){
            
            component.set("v.erroneousFormSubmitMessage", "Please enter safety marshal info");
            isMainFormValid = helper.preventFormSubmit(component, helper);
            
        }  else if (component.get("v.isAnonymous") && !component.get("v.isHumanCaptchaResult")) {    
            component.set("v.erroneousFormSubmitMessage", "Please confirm you are a human");
            isMainFormValid = helper.preventFormSubmit(component, helper);
            
        }  else if (!isMainFormValid) {
            component.set("v.erroneousFormSubmitMessage", "Please correct the errors on this form");
            isMainFormValid = helper.preventFormSubmit(component, helper);
            
        } else { // FORM VALIDATION PASSED!
            // We will be creating a record against 3 related objects 
            var contactFields = component.get("v.dfContact");
            var demographicInfoFields = component.get("v.dfContactDemographic"); 
            var gpdrFields = component.get("v.gdprPreferences");
            
            // Populate the remaining DF Event Fields from fields that are not bound to the 
            // various JS object-implementations of a SFDC sObject
            console.log("Starting address get");
            //eventFields = helper.populateEventAddrFields(component, eventFields);
            
            console.log("Attempting form submission with Event: " + JSON.stringify(component.get("v.dfEvent")));
            helper.createRecords(component, helper, contactFields, demographicInfoFields, eventFields, gpdrFields);
        }
    },
    
    
    handleSectionVisibilityOnFormSubmit : function(component, event, helper) {
        
        // Toggle the visibility
        var isFormSubmitted = component.get("v.isSuccessfulFormSubmission");
        var submitConfirmCmp = component.find("confirm-submit");
        var mainFormCmp = component.find("main-form");
        
        if(isFormSubmitted) {
            // Hide the main form and show the confirmation component
            //$A.util.removeClass(submitConfirmCmp, "render-invisible");
            $A.util.addClass(mainFormCmp, "render-invisible");
        } else {
            $A.util.removeClass(mainFormCmp, "render-invisible");
            //$A.util.addClass(submitConfirmCmp, "render-invisible");
        }
        
    }
})