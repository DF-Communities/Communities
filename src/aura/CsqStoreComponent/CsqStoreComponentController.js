({
	initHandler : function(component, event, helper) 
    {
        'use strict'     
		helper.lodashService = helper.lodashService || component.find('lodashService').get('v.instance');
		helper.promiseService = helper.promiseService || component.find('promiseService').get('v.instance');
       
		var i =  helper.getInstance(component);
		component.set('v.instance', i);
        component.get('e.registerStore').fire();
	},
    
    onFluxComponentInit: function(component, event, helper) 
    {
        'use strict'     
        component.get('e.registerStore').fire();
	},

    onStoreChange: function(component, event, helper) 
    {
        'use strict'     
        var id = event.getParam('storeId');
        if (id && id!==helper.getStoreId(component)) return;
        component.get('e.change').fire();
	},

    onActionComplete: function(component, event, helper) 
    {
        'use strict'     
        var store = component.get('v.instance');
        var storeIds = event.getParam('actionStoreIds');
        if (storeIds.indexOf(store.storeId)<0) return;

        var source = event.getParam('actionSource');
        if (!source.isValid()) return;
        
        var ncids = component.get('v.nonContainerIds') || [];
        if (ncids.indexOf(source.getGlobalId())>=0) return;

        var cid = component.get('v.containerId');
        if (cid && cid!=source.getGlobalId()) return;
        
        if (!helper.isContainedBy(component, source)) {
            ncids.push(source.getGlobalId());
            return;
        }

		component.set('v.containerId', source.getGlobalId());
        
        var error = event.getParam('actionError');
        var e =  component.get(error?'e.actionError':'e.actionComplete');
        e.setParam('actionName', event.getParam('actionName'));
        e.setParam(error?'errorData':'actionData', event.getParam('actionData'));
        e.fire();
	}

})