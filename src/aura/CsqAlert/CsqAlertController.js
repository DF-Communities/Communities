({
	init : function(component, event, helper) 
    {
        helper.cleanComponentList().push(component.getConcreteComponent());
	},
    
	onShowAlert : function(component, event, helper) 
    {
		if (event.getParam('handled')) return;	
        event.setParam('handled', true);
        helper.showAlert(event.getParam('message'));
	},
    
   	onActionBegin : function(component, event, helper) 
    {
        helper.clearAlert();
	}

})