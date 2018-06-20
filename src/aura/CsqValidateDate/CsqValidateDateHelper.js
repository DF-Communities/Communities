({
	isValid : function(component, value) 
    {
		if (!value) return true;
        var format = component.get('v.format');
        return !!$A.localizationService.parseDateTime(value, format, 'Europe/London', true);
    }
})