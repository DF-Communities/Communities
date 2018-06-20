({
	isValid : function(component, value) 
    {
		if (!value) return true;

        var isAfter = component.get('v.isAfter');
		if (!isAfter) return true;

        var format = component.get('v.format');
        var date = $A.localizationService.parseDateTime(value, format, 'Europe/London', true);
        if (!date) return true;
        var after = $A.localizationService.parseDateTime(isAfter, format, 'Europe/London', true);
        if (!after) return true;

        var strict = component.get('v.strict');
        if (!strict && $A.localizationService.isSame(date, after, 'day')) return true;

        return $A.localizationService.isAfter(date, after, 'day');
    }
})