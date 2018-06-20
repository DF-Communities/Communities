({
	doInit : function(comp, event, helper) {
       
       var action = comp.get("c.Stub_Url");
        action.setCallback(this, function(response) {
          
           var data =  response.getReturnValue();
            
            comp.set("v.stub_url",data);
           console.log('stub_url'+data);
        });
        
        $A.enqueueAction(action);
    },
})