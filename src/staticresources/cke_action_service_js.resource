app.service('actionService', function ActionService($rootScope, $q, $log)
{
  'use strict';
    
  this.invokeAction = function()
  {
    var deferred = $q.defer();

    var n;
    var arglist = [];
	for (n=1; n<arguments.length; n++) arglist[n-1] = arguments[n];
	arglist[n-1] = function(result, event) {
        if (event.status && !result.isErrorResponse) {
            deferred.resolve(result);
        }
        else {
		    $log.error(event);
            deferred.reject(event.message)
        }
    }
	arglist[n] = { buffer: false, escape: false, timeout: 120000 };

    var method = arguments[0];
    method.apply(null, arglist);

    return deferred.promise;
  };

});

