({
    init : function(component, event, helper) 
    {
       //var disp = component.find({instancesOf:'c:CsqDispatcher'});
       //if (disp.length==0) throw new Error('CsqFluxComponent does not contain a dispatcher');
       //if (disp.length>1) throw new Error('CsqFluxComponent contains multiple dispatchers');
   	   //component.set('v.dispatcher', disp[0]);    
      
        setTimeout($A.getCallback(function(){
        $A.get('e.c:CsqFluxComponentInit').fire();    
        }), 200)
	},

    dispatch : function(component, event, helper) 
    {
//		var dispatcher = component.get('v.dispatcher');
        var dispatcher = component.find('dispatcher');
        dispatcher.dispatch(event.getParams(), event.getSource());
	},
    
    registerStore: function(component, event, helper) 
    {
        var store = event.getSource();
        var dispatcher = component.find('dispatcher');
        dispatcher.register(store.get('v.instance'));
    }

})