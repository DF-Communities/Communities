({
	init : function(component, event, helper) 
    {
        var key = component.get('v.key');        
        var group = component.get('v.group');
		var snippetService = component.find('snippetService').get('v.instance');

        snippetService.getSnippet(group, key)
        .then(function(snippet){
            if (snippet) component.set('v.text', snippet.Body_Text__c);
        })
        .catch(function(e){console.log(e)});
       
	}
})