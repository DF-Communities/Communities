({
    handleRatingSelection : function(component, event, helper) {
        
        var selectedRating = event.getSource.get("v.value");
        var fieldApiName = event.getSource.get("v.correspondingFieldApiName")
        
        var dynFieldName = "{!v.simpleRecord." + fieldApiName + "}";
        component.set("{!v.simpleRecord." + fieldApiName + "}", selectedRating);
        
    },
    
    handleDynAddInfoBoxes : function(component, event, helper) {
        console.log('OI OI!!!');
        var evtCmp = event.getSource();
        var nameOfSection = evtCmp.get("v.name"); // All components are named the same as the section they are in 
        var questionSet = evtCmp.getLocalId();
        
        //var auraIfVarName = '"v.' + evtCmp.get("v.name") + 'Explanation"';
        
        
        var hideMoreInfoBox = component.find(questionSet).reduce(function(hasAnsweredYes, inpCmp){
            var inpCmpIsYes = true;
            if(inpCmp.get("v.value") == "No") {
                console.log("+++++ 'No' was asnwered for " + inpCmp.get("v.name"));
                inpCmpIsYes = false;
            }
            return hasAnsweredYes && inpCmpIsYes;
        }, true);
        
        console.log('hideMoreInfoBox: ' + hideMoreInfoBox);
        
        if(evtCmp.get("v.name") == "friendOnChamp") {
            component.set("v.friendOnChampExplanation", !hideMoreInfoBox);
        } 
        if(evtCmp.get("v.name") == "champOnFriend") {
            component.set("v.champOnFriendExplanation", !hideMoreInfoBox);
        } 
        if(evtCmp.get("v.name") == "friendSessionContent") {
            component.set("v.friendSessionContentExplanation", !hideMoreInfoBox);
        } 
        if(evtCmp.get("v.name") == "groupResponse") {
            component.set("v.groupResponseExplanation", !hideMoreInfoBox);
        } 
        if(evtCmp.get("v.name") == "champSessionContent") {
            component.set("v.champSessionContentExplanation", !hideMoreInfoBox);
        }   
    },
    
    /*handleDynAddInfoBoxes : function(component, event, helper) {
        console.log('OI OI!!!');
        var evtCmp = event.getSource();
        var nameOfSection = evtCmp.get("v.name"); // All components are named the same as the section they are in 
        var questionSet = evtCmp.getLocalId();

        component.set("{!v." + evtCmp.get("v.name") + "}", false);

        var showMoreInfoBox = component.find(questionSet).reduce(function(validFields, inpCmp){
            if(inpCmp.get("v.value") == "No") {
                console.log("+++++ 'No' was asnwered for " + inpCmp.get("v.name"));
                console.log("{!v." + inpCmp.get("v.name") + "}");
                component.set("{!v." + inpCmp.get("v.name") + "}", true);
            }
        }, true);
                
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
        } 
        
        helper.updateSfdcRecord(component, dfEvent);
    }
})