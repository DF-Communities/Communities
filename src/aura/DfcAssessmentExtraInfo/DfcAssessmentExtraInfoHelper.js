({
	determineIfRequired: function(component) 
    {
       var required = this.isRequired(component);
       component.set('v.extraRequired', required);
       if (!required) component.set('v.question.Extra_Information__c', null);
	},
    
    isRequired: function(component) 
    {
        var question = component.get('v.question');
        if (!question.Capture_Extra__c) return false;
        var options = question.Capture_Extra_On_Option__c;
        return !options || options.indexOf(question.Entered_Answer__c) >= 0;
	}
})