({
	init : function(component, event, helper) 
    {
        var group = component.get('v.loadGroup');
        if (group) {
  		  component.get('v.instance').loadSnippets(group);             
        }
	}
})