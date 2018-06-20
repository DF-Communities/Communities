({

/*
  	onRegionChange : function(component, event, helper) 
    {
    	
    	var selectedRegion = component.get('v.context.community.DA_Alliance__r.Region__c')	;
		
    	var communityService = component.find('communityService').get('v.instance');
        communityService.getCountiesForRegion(selectedRegion).
        then(function(data){  
      //      console.log(data);       
           component.set('v.counties', data);
        });
    },  */

    locationTypeChangeHandler: function(component, event, helper)
    {
     	  var comm = component.get('v.context').community;
        comm.Location_Type__c = event.source.get('v.label');
        component.set('v.context', component.get('v.context'))
    }
   
})