({
	validate : function(component, initial) 
    {
        var value = component.get('v.value');
        var group = component.get('v.group');
        var disregard = component.get('v.disregard');
        var message = component.get('v.message') || component.get('v.defaultMessage');
        
        var cmp = component.getConcreteComponent();
        var h = cmp.getDef().getHelper();
        if (!h.isValid) throw new Error('Component '+cmp.toString+' extends CsqValidationComponent but does not implement helper.isValid()');
        var valid = disregard || h.isValid(cmp, value);
     
        component.set('v.isValid', valid);
        component.set('v.errorText', valid ? '' : message);
        
        var data = { key:component.getGlobalId(), group:group, valid:valid, message:message };

        e = component.get('e.validationEvent');
        e.setParams(data);
        e.fire();
        
        /*
         * Replaced with the application event below to work around bug in the event system
         * whereby component events fired by dynamically created components (includng those
         * inside an iteration or if) fail to bubble and are lost.
         * 
        var e = component.get('e.CsqDispatch');
        e.setParam('action', 'CsqValidationEvent');
        e.setParam('data', data);
        e.fire();
		*/

        e = $A.get('e.c:CsqValidationBroadcastEvent');
        e.setParam('key', cmp.getGlobalId());
        e.setParam('group', group);
        e.setParam('valid', valid);
        e.setParam('initial', initial);
        e.setParam('source', cmp);
        e.fire();

		//Compatibility with old register community form//
        e = $A.get('e.c:DfcValidationEvent');
        e.setParam('key', component.getGlobalId());
        e.setParam('group', group);
        e.setParam('valid', valid);
        e.fire();
	}
})