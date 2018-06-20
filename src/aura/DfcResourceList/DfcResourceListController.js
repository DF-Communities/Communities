({
	onCommunityStoreChange : function(component, event, helper) 
    {
		var store = event.getSource().get('v.instance');
        if (store.copyProperty(component, 'communityData', 'v.communityState', helper.transformCommunityData)) {
             var e = component.get('e.CsqDispatch');
   			 e.setParam('action', 'DfcLoadResourceSet');
   			 e.setParam('data', component.get('v.communityState'));
   			 e.fire();
        }
	},
    
    onResourceStoreChange : function(component, event, helper) 
    {
		var store = event.getSource().get('v.instance');
    	store.copyProperty(component, 'resources', 'v.resources', helper.transformResourceData);    
	  }
})