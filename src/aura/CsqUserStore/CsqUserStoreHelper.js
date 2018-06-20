({
	createInstance : function(cmp, Promise, _, actionService) 
    {
       'use strict'

        var properties = {
            "currentUserInfo": getCurrentUserInfo,   
            "currentUserId": getCurrentUserId,   
            "currentSessionId": getCurrentSessionId   
        };

        var dispatchTable = {
            "CsqReload": onReloadAction
        };

        var state = {
           currentUserInfo: null,
           currentSessionId: null
        };
       
        function init()
        {
            return loadCurrentUserData();
        }

        function getCurrentUserId()
        {
            return state.currentUserInfo ? state.currentUserInfo.Id : null;
        }

        function getCurrentUserInfo()
        {
            return state.currentUserInfo;
        }

        function getCurrentSessionId()
        {
            return state.currentSessionId;
        }

        function onReloadAction()
        {
            return loadCurrentUserData();
        }

        function loadCurrentUserData()
        {
            var action = actionService.get('getCurentUserInfo');
      		return actionService.run(action, function(data){
               state.currentUserInfo = data.info;
               state.currentSessionId = data.sessionId;
            });        
        }
        
        return { dispatchTable:dispatchTable, properties:properties, init:init, state:state };
	}
})