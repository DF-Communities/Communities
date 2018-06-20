({
	getTotalFriendsCount : function(comp) {
		var action = comp.get("c.totalFriendCount");
        
        action.setCallback(this, function(response) {
          
           var data =  response.getReturnValue();
            comp.set("v.totalFriendCountList",data);
           console.log(comp.get("v.totalFriendCountList"));
        });
        $A.enqueueAction(action);
        
	},
    
    getLoggedInUser : function(comp) {
       var action = comp.get("c.getCurrentUser");
        action.setCallback(this, function(response) {
          
           var data =  response.getReturnValue();
            if(data!=null){
            comp.set("v.loggedin","true");
            }
        });
        
        $A.enqueueAction(action);
    },
      getStubUrl : function(comp) {
       var action = comp.get("c.Stub_Url");
        action.setCallback(this, function(response) {
          
           var data =  response.getReturnValue();
            
            comp.set("v.stub_url",data);
           console.log('stub_url'+data);
        });
        
        $A.enqueueAction(action);
    },
    
})