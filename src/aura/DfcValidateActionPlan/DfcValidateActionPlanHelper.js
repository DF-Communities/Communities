({
	isValid : function(component, value) 
    {
		if (!value) return false;
        var n = 0;
        for (var i=0; i<value.length; i++) {
          if (value[i].Selected__c) n++
        }
        return n >= 1;
	}
})