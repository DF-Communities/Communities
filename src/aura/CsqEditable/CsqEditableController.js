({
	onSnippetStoreChange : function(component, event, helper) 
    {
        var store = event.getSource().get('v.instance');
        store.copyProperty(component, 'snippet');

    
	}
})