({
    init: function(component, event, helper) 
    {
    },

	onValidationEvent : function(component, event, helper) 
    {
        console.log(event)
        
       var key = event.getParam('key');
       var valid = event.getParam('valid');
       var errors = component.get('v.errors');

       console.log('--onValidationEvent key = ' + key);
       console.log('--onValidationEvent valid = ' + valid);
       console.log('--onValidationEvent errors = ' + errors);

       var i = errors.indexOf(key);
       if ((i>=0 && !valid) || (i<0 && valid)) return;
      
       if (i>=0) errors.splice(i, 1);
       else errors.push(key);       
       
	   component.set('v.errors', errors);        
	   component.set('v.errorCount', errors.length);        
	},
    
	validate : function(component, event, helper) 
    {
    	var arguments = event.getParam('arguments');
        var ret = arguments.ret;
        if (!ret) throw new Exception('Must supply an object to CsqValidationTracker validate() method receive the return value');
        ret.valid = !helper.containsValidationError(component);
	}
})