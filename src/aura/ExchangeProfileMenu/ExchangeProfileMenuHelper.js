({
	getCurrentUser : function(component) {
		 var action = component.get("c.getCurrentUser");
          
         action.setCallback(this, function(response) {
             var data =  response.getReturnValue();
             component.set("v.userId", data);
             
             console.log('is logged in'+data);
             
         });
      
        $A.enqueueAction(action);
	},
    getCurrentUserName : function(comp) {

        var action = comp.get("c.getCurrentUserName");
       
        action.setCallback(this, function(response) {
           
           var data =  response.getReturnValue();
           
            comp.set("v.username",data);
            
      
    });
        
        
         $A.enqueueAction(action);
    },
})