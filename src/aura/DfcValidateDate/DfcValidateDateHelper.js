({
	isValid : function(component, value) 
    {
		if (!value) return true;
        var format = component.get('v.format');
        var moment = component.find('momentService').get('v.instance');
		return moment(value, format, true).isValid();
    }
})