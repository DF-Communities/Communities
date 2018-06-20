({
	isValid : function(component, value) 
    {
        if (!value||value.trim().length==0) return true;
        var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        return re.test(value);
	}
})