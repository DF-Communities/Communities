({
    onSelectionChange: function(component, event, helper) 
    {
        var e = $A.get('e.c:DfcValidate');
        e.setParam('group', component.get('v.step'));
        e.fire();
	}
})