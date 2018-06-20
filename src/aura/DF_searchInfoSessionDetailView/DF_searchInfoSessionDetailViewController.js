({
	/*
     *	This method only controls the visibility of the confirmation popup 
     */
    startSessionSignUpJourney : function(component, event, helper) {

        // A valid submission has a date, start time and end time
        var formIsValid = true;
        if($A.util.isUndefined(component.get("v.selectedInfoSessionStartTime"))){
            formIsValid = false;

        } else if($A.util.isUndefined(component.get("v.selectedInfoSessionEndTime"))){
            formIsValid = false;

        } if($A.util.isUndefined(component.get("v.selectedInfoSessionDate"))){
            formIsValid = false;

        }

        if(formIsValid){ 
            component.set("v.noErrorsOnSubmit", true);
        } else {
            helper.resetDropboxesAndSelectedTimes(component, event, helper);
            helper.deselectAllCheckboxes(component, event, helper);
            component.set("v.errorsOnSubmit", true);
        }
    }
})