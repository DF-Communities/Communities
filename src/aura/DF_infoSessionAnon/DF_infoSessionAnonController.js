({
	handleMemberNonMember : function(component, event, helper) {
        
        var hasCommunityAccount;
        var userJourneyStep;
        var isFormUntouched;
        
        var value = event.getSource().get("v.value");
        if (value=="notRegistered") {
            hasCommunityAccount = false;
            userJourneyStep = 3;
        } else if (value=="alreadyFriend") {
            hasCommunityAccount = true;
        }
        if (value=="unselected") {
            isFormUntouched = true;
        }
        
        // Publish the event
        var action = component.getEvent("DF_anonEvt");
        action.setParams({"hasCommunityAccount" : hasCommunityAccount,
                          "userJourneyStep" : userJourneyStep,
                          "isFormUntouched" : isFormUntouched});
        action.fire();
    }
})