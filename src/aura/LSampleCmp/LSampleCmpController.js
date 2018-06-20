({
	doInit : function(component, event, helper) {
		var action = component.get("c.getCurrentUser"); // method in the apex class
        action.setCallback(this, function(a) {
            component.set("v.currentUser", a.getReturnValue()); // variable in the component
        });
        $A.enqueueAction(action);	
	}
})