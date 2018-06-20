({
	 // Use actionService to retrieve data ia Apex
	createInstance : function(cmp, Promise, _, actionService) 
    {
       'use strict'

        /* These are the read only properties this store exposes */
        var properties = {
            "snippet": getSnippet,
       
        };

        // Action dispatch table
        var dispatchTable = {
            "DfcUpdateSnippet" : onUpdateSnippet,
        };

       /* This var holds the current state of the data and can change as actions happen 
          When the data chnges, onStoreChanged gets fired
       */
       var state = {
           snippet:null,
       };
           
     

       function getSnippet()
       {
       	 return state.snippet;    
       },
           
       function onUpdateSnippet(data)
       {
            var action = actionService.get('updateSnippet');
            action.setParams(data);
            return actionService.run(action, function(snippet){
                state.snippet= snippet;
           }); 
        }
            
 
        return { dispatchTable:dispatchTable, properties:properties, init:init };
	}
})