({
	captureProximity : function(component, event, helper) {
		console.log('Here we go');
        var isChecked = event.getSource().get("v.value");
        var item = event.getSource().get("v.name");
        console.log('Here we go1: ' + item + ' ' + isChecked);
        var currentProximitySelections = component.get("v.proximitySelectionArr");
        if(isChecked) {
            currentProximitySelections.push(item);
        } else {
            var removeInd = currentProximitySelections.indexOf(item);
            if(removeInd != -1) {
                currentProximitySelections.splice(removeInd, 1);
            }
        }
        console.log('Here we go3 ' + JSON.stringify(currentProximitySelections));
        component.set("v.proximitySelectionArr", currentProximitySelections);
        component.find("multiSelectProximityValueStore").set("v.value", currentProximitySelections);
        console.log('Here we go3');
    }
})