({
    onStoreChange : function(component, event, helper) 
    {
        var store = component.get('v.viewStore')[0].get('v.instance');
        store.copyProperty(component, 'viewDefs');
        store.copyProperty(component, 'selectedViewOrdinal');
    },
    
    clickHandler : function(component, event, helper) 
    {
        var item = 	event.currentTarget;
        var index = +item.getAttribute('data-index');
        var e = component.get('e.CsqDispatch');
        e.setParam('action','CsqSelectViewOrdinal'); 
        e.setParam('data',index); 
        e.fire();
  	}
})