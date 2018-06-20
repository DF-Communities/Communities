({
	onStoreChanged : function(component, event, helper) 
    {
		var viewStore = component.get('v.viewStore');
        if (!viewStore.copyProperty(component, 'viewDefs')) return;

        var viewId = component.get('v.viewId');
        viewStore.viewDefs.forEach(function(def){
           if (def.id===viewId) component.set('v.viewState', def);                        
        });
	}
})