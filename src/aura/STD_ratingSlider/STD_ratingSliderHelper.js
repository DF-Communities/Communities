({
	handleSelectedRating : function(component, helper, event, sliderValue) {
        console.log("In rating handler with " + sliderValue);
        var ratingOptions = ["Terrible", "Poor", "OK", "Good", "Excellent"];
		var ratingAsPicklistValue = ratingOptions[sliderValue-1];
        console.log("Setting rating as: " + ratingAsPicklistValue);
		component.set("v.value", ratingAsPicklistValue); // Set the component value against the required field 
    }
})