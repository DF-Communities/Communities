({
	 // Use actionService to retrieve data ia Apex
	createInstance : function(cmp, Promise, _, actionService) 
    {
       'use strict'

        /* These are the read only properties this store exposes */
        var properties = {
            "resources": getResources,
        };

        // Action dispatch table
        var dispatchTable = {
            "DfcLoadResourceSet" : onLoadResourceSet,
        };

       /* This var holds the current state of the data and can change as actions happen 
          When the data chnges, onStoreChanged gets fired
       */
       var state = {
           resources:[]
       };
           
	   function init()
       {
         return Promise.resolve();   
       }
        
       function getResources()
       {
       	 return state.resources;    
       }
           
       function onLoadResourceSet(data)
       {
            var action = actionService.get('getResourcesForState');
            action.setParam('state', data);
            return actionService.run(action, function(data){
                formatResources(data);
           }); 
        }
        
        function formatResources(data)
        {   
            var resData = data.resources;
            var attData = data.attachments;
            _.each(resData, function(res){
                res.file = _.find(attData, {ParentId:res.Id}); 
            });
            state.resources = resData;
        }
 
        return { dispatchTable:dispatchTable, properties:properties, init:init };
	}
})