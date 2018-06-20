({
	getService : function(component, name) 
    {
		return component.find(name).get('v.instance');
	}
})