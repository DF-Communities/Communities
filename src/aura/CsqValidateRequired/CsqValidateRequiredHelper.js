({
	isValid : function(component, v) 
    {
		if (v==null) return false;
		if (typeof(v)=='string' && v.trim().length==0) return false;
		return !!v;
	}
})