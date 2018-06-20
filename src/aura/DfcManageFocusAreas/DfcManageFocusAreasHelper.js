({
    copyFromStore: function(component,event)
    {
        var helper = this;
        var communityStore = component.find('communityStore').get('v.instance');
		communityStore.copyProperty(component, 'communityData');
		communityStore.copyProperty(component, 'actionAreas', 'v.actionAreas', helper.formatActionAreas);
      
    	var _ = component.find('lodashService').get('v.instance');
    	var actionAreas = component.get('v.actionAreas');  
        
    	var firstSelectedArea = _.find(actionAreas, { Selected__c:true });  
    	component.set('v.noSelectedAreas', !firstSelectedArea ? true : false);
    },
    
	formatActionAreas : function(areas) 
    {
        areas.forEach(function(area){
           Object.defineProperty(area, 'activityCount', {
               get: function(){return this.Activities__r ? this.Activities__r.length : 0;}
		  }); 
       });
        return areas;
	}
})