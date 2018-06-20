({
	count: function(component, event, helper) 
    {
       'use strict'
       var value = component.get('v.value');
       var trimmed = value ? value.trim() : '';
       var rx = new RegExp("['\";:,.?¿\\-!¡]+", "g");
       var words = (trimmed.replace(rx,'').match(/\S+/g) || []).length;
        component.set('v.count', words>1?words+' words':(words>0?'1 word':''));
	}

})