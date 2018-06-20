({
	init : function(component, event, helper) 
    {
        helper.setSelection(component);
	},
    
    onChange : function(component, event, helper) 
    {
        var selection = helper.getSelection(component);
        component.set('v.question.Entered_Answer__c', selection);
	}

})