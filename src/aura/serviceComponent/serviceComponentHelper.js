({
    instanceMap : {},
    
    getInstance: function(cmp)
    {
		'use strict'
		var h = cmp.getDef().toString();
		if (!this.instanceMap[h]) this.instanceMap[h] = this.createInstance(cmp);
        return this.instanceMap[h];
	},
    
    createInstance: function(cmp)
    {
		'use strict'
        var componentDef = cmp.getDef();
        if (!componentDef.getHelper().createInstance) 
            throw new Error('Component '+this.getComponentName(componentDef)+' extending helperDecorator does not implement createInstance() helper method');
        return componentDef.getHelper().createInstance(cmp);
	},
    
    getComponentName: function(componentDef)
    {
		'use strict'
		var s = componentDef.toString();
        s = s.replace('markup://', '');
        return s;
    },
    
    
})