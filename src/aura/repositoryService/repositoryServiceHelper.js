({
    
    createInstance: function(cmp)
    {
        var Promise = cmp.find('promiseService').get('v.instance');
        
        function RepositoryService()
        {
            var self = this;
            
            self.remoteCall = function(action)
            {
                return new Promise(function(resolve, reject){
                    
                    action.setCallback(this, function(response) {
                        var ret = response.getReturnValue();
                        if (ret && ret.isErrorResponse) {
                            console.log(ret);
                            reject(ret);
                        }
                        else {
                            resolve(ret);
                        }
                    }, 'SUCCESS');
                    
                    action.setCallback(this, function(response) {
                        var errors = action.getError();
                        reject(errors)
                    }, 'ERROR');
                    
                    action.setCallback(this, function(response) {
                        console.log('INCOMPLETE>>>>>>>>>>>');
                        reject('Failed to complete')
                    }, 'INCOMPLETE');
                    
                    action.setCallback(this, function(response) {
                        reject('aborted')
                    }, 'ABORTED');
                    
                    $A.enqueueAction(action);
                    
                });
       
    		}

       }
        
       return new RepositoryService();
    }
    
    
})