({
	/*handleCustomError : function(component, event, helper) {
		console.log('DF_yesNoError handling event');
        // Apply a red border around the component
        console.log('???x: ' + component);
        $A.util.addClass(component, 'field-err-border');

	}*/
    
    handleSelectionChange : function(component, event, helper) {
    	console.log('hanling change');
        $A.util.addClass(component, 'field-err-border');
	}
})