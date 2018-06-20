({
	onClick : function(component, event, helper) 
    {
		component.get('e.onclick').fire();	
	},
    
	onActionBegin : function(component, event, helper) 
    {
		component.set('v.forceDisabled', true);	
	},
    
	onActionComplete : function(component, event, helper) 
    {
		component.set('v.forceDisabled', false);	
	}
    
})