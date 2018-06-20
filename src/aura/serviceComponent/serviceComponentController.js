({
	initHandler : function(component, event, helper) 
    {
        'use strict'
        
        function curry(fn, i, cc)
        {
           return function() {
             return fn.apply(i, [cc].concat(Array.prototype.slice.call(arguments)));
           };
        }

        function proxy(i, cc)
        {
            var proxy = {};
            Object.getOwnPropertyNames(i).forEach(function(name){
               proxy[name] = curry(i[name], i, cc);
            });
            return proxy;
        }

        var cmp = component.getConcreteComponent();
		var i =  helper.getInstance(cmp);

		if (i.INJECT_COMPONENT) i = proxy(i, cmp);
        
		component.set('v.instance', i);
	}
})