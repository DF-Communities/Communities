({
	isValid : function(component, v) 
    {
		if (typeof(v)=='number') return true;	
        if (v==null || v.trim().length == 0) return true 
      	if (!v.trim().match(/^[0-9]*(\.[0-9]+)?$/)) return false;
        var pos = component.get('v.positive');
        return !pos || parseInt(v, 10) > 0;
   	}
})