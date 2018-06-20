({
    isValid: function(component, value) 
    {
       'use strict'
       var trimmed = value ? value.trim() : '';
       var rx = new RegExp("['\";:,.?¿\\-!¡]+", "g");
       var words = (trimmed.replace(rx,'').match(/\S+/g) || []).length;
       var max = component.get('v.max');
       return words <= max;
	}
})