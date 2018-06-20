({
	validate : function(component) 
    {
        var value = component.get('v.value');
        var group = component.get('v.group');
        var disregard = component.get('v.disregard');
        var message = component.get('v.message') || component.get('v.defaultMessage');
       
        var cmp = component.getConcreteComponent();
        var h = cmp.getDef().getHelper();
        if (!h.isValid) throw new Error('Component '+component.getConcreteComponent().toString+' extends DfcValidationComponent but does not implement helper.isValid()');
        var valid = disregard || h.isValid(cmp, value);
     
        component.set('v.errorText', valid ? '' : message);
        
        var data = { key:component.getGlobalId(), group:group, valid:valid };
        
        var e = component.get('e.CsqDispatch');
        e.setParam('action', 'CsqValidationEvent');
        e.setParam('data', data);
        e.fire();

        var e = $A.get('e.c:DfcValidationEvent');
        e.setParam('key', data.key);
        e.setParam('group', data.group);
        e.setParam('valid', data.valid);
        e.fire();
	}
})