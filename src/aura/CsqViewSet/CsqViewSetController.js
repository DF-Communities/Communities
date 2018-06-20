({
	init : function(component, event, helper) 
    {
		helper.handleInit(component);
	},
    
    onStoreChanged : function(component, event, helper) 
    {
        var store = component.get('v.store')[0].get('v.instance');
        if (!store.copyProperty(component, 'selectedViewName')) return;
        
		var defs = store.viewDefs;
        var body = component.get('v.body');
        for (var i=0; i<body.length; i++) {
            if (defs[i].name===store.selectedViewName) {
              $A.util.addClass(body[i], "csq-show");
            }
            else {
              $A.util.removeClass(body[i], "csq-show");
            }
        }
        
        //perhaps fire view changed event here carrying the new active def
        
        if (window.scrollY>150) window.scrollTo(0, 120);
	},
    
    onValidationEvent : function(component, event, helper) 
    {
        helper.handleValidationEvent(component, event);
	},
    
})