({

    createInstance: function(cmp)
    {
        var Promise = cmp.find('promiseService').get('v.instance');
        
        function CsqActionService()
        {
            var self = this;
            
            self.remoteCall = function(action, callback)
            {
                return new Promise(function(resolve, reject){
                    
                    var resolved = false;
                    
                    action.setCallback(this, function(response) {
                    //    console.log(response)
                        var ret = response.getReturnValue();
                        if (ret && ret.isErrorResponse) {
                            console.log(ret);
                            reject(ret);
                        }
                        else {
                            callback(ret);
                            if (!resolved) {
                                resolve(ret);
                                resolved = true;
                            }
                        }
                    }, 'SUCCESS');
                    
                    action.setCallback(this, function(response) {
                        var error = action.getError();
                        console.log('ERROR:'+JSON.stringify(error));
                        reject(error);
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
        
       return new CsqActionService();
    }
})