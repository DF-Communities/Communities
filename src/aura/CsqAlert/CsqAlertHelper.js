({
    componentList: [],
    
	showAlert : function(message) 
    {
		this.cleanComponentList();
        if (this.showWithPriority('HIGH',message)) return;
        if (this.showWithPriority('MEDIUM',message)) return;
        this.showWithPriority('LOW',message);
	},
    
	clearAlert : function(message) 
    {
		this.cleanComponentList();
        this.componentList.forEach(function(cmp){
            cmp.set('v.message', null);
        });
	},
    
	showWithPriority : function(priority, message) 
    {
		var shown = false;
		this.cleanComponentList();
        this.componentList.forEach(function(cmp){
          if (cmp.get('v.active') && cmp.get('v.priority')===priority) {
            cmp.set('v.message', message);
            shown = true;
          }
        });
        return shown;
	},
    
	cleanComponentList : function() 
    {
		var list = [];
        this.componentList.forEach(function(cmp){
            if (cmp.isValid()) list.push(cmp);
        });
        return this.componentList = list;
	}
        
})