({
	init : function(component, event, helper) 
    {
		console.log(component.get('v.body'));
        var stores = component.find({instancesOf:'c:CsqStoreComponent'});
		console.log(stores);
	}
})