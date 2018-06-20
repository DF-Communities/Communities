({
	onCommunityStoreChange : function(component, event, helper) 
    {
        var store = event.getSource().get('v.instance');
        store.copyProperty(component, 'communityData');
	},


    
    prevView: function(component, event, helper) 
    {
         var e = component.get('e.CsqDispatch');
    	e.setParam('action', 'CsqPrevView');
    	e.fire();
    },
})