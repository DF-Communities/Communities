({
    clickHandler : function(component, event, helper) 
    {
        var item = 	event.currentTarget;
        var stepno = +item.getAttribute('data-index');
        var e = $A.get('e.c:DfcSetStep');
        e.setParam('step',stepno);
        e.fire();
  	},
   
    onValidationChange : function(component, event, helper) 
    {
        var steps = component.get('v.steps');
        var _steps = component.get('v._steps');
        component.set('v._steps', steps);
    }
})