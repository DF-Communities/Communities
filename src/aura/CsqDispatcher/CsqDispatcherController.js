({
	init : function(component, event, helper) 
    {
        var _ = component.find('lodashService').get('v.instance');
        var Promise = component.find('promiseService').get('v.instance');
        
        function fireChange()
        {
           $A.get('e.c:CsqStoreChanged').fire();
        }
        
        if (!helper.fireChangeEvent) {
            helper.fireChangeEvent = _.debounce($A.getCallback(fireChange), 250, {leading:false, maxWait:400, trailing:true});//////????????
        }

        var dispatcher = helper.createInstance();
        component.set('v.instance', dispatcher);
        var inits = [];
        var stores = component.get('v.body')
//        var stores = component.find({ instancesOf : "c:CsqStoreComponent" });
        stores.forEach(function(scmp){
            var store = scmp.get('v.instance');
            inits.push(store.init());
        	dispatcher.register(store);
    	});
        
        if (!inits.length) return;
        
        Promise.all(inits).then($A.getCallback(function(){
 		   helper.fireChangeEvent();
        })
        .catch(function(err){
            ///////////
            throw new Error('One or more stores failed to initialize');
        }));
	},

    register: function(component, event, helper)
    {
        var params = event.getParam('arguments');
		var store = params.store;

        var stores = component.get('v.stores');
        if (stores.indexOf(store)>=0) return;
        stores.push(store);
        
        var dispatcher = component.get('v.instance');
        dispatcher.register(store);
        
        return store.waitForInitialization.then($A.getCallback(function(){ ///////NEED getCallback()
           var e = $A.get('e.c:CsqStoreChanged');
           e.setParam('storeId', store.storeId);
           e.fire();
        }));
    },
    
    dispatch: function(component, event, helper)
    {
        var _ = component.find('lodashService').get('v.instance');
        var Promise = component.find('promiseService').get('v.instance');

        var params = event.getParam('arguments');
        var payload = params.action;
        var source = params.source;

        if (!source) throw new Error('no source')

            var e = $A.get('e.c:CsqActionBegin');
           e.setParam('actionName', payload.action);
           e.setParam('actionData', payload.data);
           e.setParam('actionSource', source);
//           e.setParam('actionStoreIds', storeIds);
           e.fire();

        
        var dispatcher = component.get('v.instance');
        var retvals = dispatcher.dispatch(payload);

        var storeIds = _.keys(retvals);
        var completionPromises = _.filter(_.values(retvals), function(v){return !!v.then;});
        
        if (!completionPromises.length) completionPromises = [Promise.resolve()];

        Promise.all(completionPromises)
        .then($A.getCallback(function(){ 
           var e = $A.get('e.c:CsqActionComplete');
           e.setParam('actionError', false);
           e.setParam('actionName', payload.action);
           e.setParam('actionData', payload.data);
           e.setParam('actionSource', source);
           e.setParam('actionStoreIds', storeIds);
           e.fire();
        }))
       .catch( $A.getCallback(function(reason){
           console.log(reason)
           var e = $A.get('e.c:CsqActionComplete');
           e.setParam('actionError', true);
           e.setParam('actionName', payload.action);
           e.setParam('actionData', reason);
           e.setParam('actionSource', source);
           e.setParam('actionStoreIds', storeIds);
           e.fire();
        }));

    }
})