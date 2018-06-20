({
	createInstance : function(cmp) 
    {
		'use strict'
        
        var _ = cmp.find('lodashService').get('v.instance');
        var repositoryService = cmp.find('repositoryService').get('v.instance');
		    var Promise = cmp.find('promiseService').get('v.instance');
        
        function SnippetService()
        {
			    var self = this;
            
          self.INJECT_COMPONENT = true;

    	    var snippetMap = {};
	        var promiseMap = {};
    
            self.loadSnippets = function(component, group)
            {
               var action = component.get('c.getSnippets');
               action.setParam('pageName', group);
               return promiseMap[group] = repositoryService.remoteCall(action)
               .then(function(data){
                   formatSnippets(data);
                   return snippetMap;
               })
              .catch(function(e){console.log(e)});
            };
            
            self.getSnippet = function(component, group, key)
            {   
                var promise = promiseMap[group] || self.loadSnippets(component, group);
                return promiseMap[group].then(function(map){ return map[key];});
            }
 
            function formatSnippets(data)
            {
                var list = _.pluck(data, 'Page_Snippet__r');
                _.each(list, function(s){
                    snippetMap[s.Unique_Name__c] = s;
                });
            } 
        }
        
        return new SnippetService();
    }
})