({
	getDFCon : function(comp) {
	// Get a reference to the ExchangeDFCDetailController() function defined in the Apex controller
        var rec = comp.get("v.recordId");
        var action = comp.get("c.getDFCDetails");
        var eFields = comp.find("box");
         
        $A.util.toggleClass(eFields, "editfm");
         
        console.log("test recordid"+rec);
        action.setParams({
          
            "uId":rec 

        });
         
        action.setCallback(this, function(response) {
           
         var status = response.getState();
           
           if(status === "SUCCESS"){   
           var data =  response.getReturnValue();
           var datat = JSON.stringify(data);
           var dateData = data.Date_of_Champion_Training__c;
           var interests = data.Interests__c;
           var access = data.Champion_exchange_access__c;
           
               
            if(data!= null){
                comp.set("v.dfcon",data);
                comp.set("v.hasDFCon", "true");
              if(access === false)  {
                 comp.set("v.optIn", "false");  
              }
                else{
                   comp.set("v.optIn", "true"); 
                }
              if(interests !=null)  {
                interests= interests.replace(/;/g, ",");
                comp.set("v.interests", interests);
              }
            
              if(dateData != null ){
                            
                 var dt = new Date(comp.get("v.dfcon.Date_of_Champion_Training__c"));
                 var month = new Array();
                month[0] = "January";
                month[1] = "February";
                month[2] = "March";
                month[3] = "April";
                month[4] = "May";
                month[5] = "June";
                month[6] = "July";
                month[7] = "August";
                month[8] = "September";
                month[9] = "October";
                month[10] = "November";
                month[11] = "December";
                //var n = month[d.getMonth()];
                  
                comp.set("v.champsince",month[dt.getMonth()]+" "+dt.getFullYear());
                
              }
               else{
               
                comp.set("v.champsince","");
               }
            }
               else{
                   comp.set("v.hasDFCon", "false");
               }
            
           }
               
                  
    });
        
        
         $A.enqueueAction(action);
    },
    getPicklistValues : function(comp) {
         //test
        
         var action2 = comp.get("c.getpickval");
        
         var inputsel = comp.find("InputSelectDynamic");
         
         var opts=[];
         var options=[];
         action2.setCallback(this, function(response) {
           
             //test
            if (response.getState() === "SUCCESS") {
             for(var i=0;i< response.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                options.push(response.getReturnValue()[i]);
                 
             }
              inputsel.set("v.options", opts);
              comp.set("v.selectoptions",options);
             console.log('select list@@'+inputsel);
              console.log('selectoptins list@@'+options);
                 
            //test
            }
             else if (response.getState() === "ERROR"){
                console.log(response.getError());
                var errors = response.getError();
                if(errors[0] && errors[0].pageErrors)
                    component.set("v.message", errors[0].pageErrors[0].message);    
            }
         });
       
        $A.enqueueAction(action2);
    },
     getCurrentUser : function(comp) {
         //test
          var action3 = comp.get("c.getCurrentUser");
          var rec = comp.get("v.recordId");
         
         action3.setCallback(this, function(response) {
             var data =  response.getReturnValue();
             comp.set("v.runningUser", data);
             console.log("current record user"+ rec);
             console.log("running user"+ data);
             if(rec==data){
               comp.set("v.edit", "true");  
                 console.log('can user edit',comp.get("v.recordId"));
             }
         
         });
      
        $A.enqueueAction(action3);
    },
    
    getUserDetails : function(comp) {
      var rec = comp.get("v.recordId");
      var action = comp.get("c.getUserProfile");
      action.setParams({
          
            "uid":rec 

        });
      action.setCallback(this, function(response) {
          var data =  response.getReturnValue();          
          
          comp.set("v.user",data);          
          console.log(data);
      });
        $A.enqueueAction(action);
    },
     toggleHelper : function(component,event) {
    var toggleText = component.find("tooltip");
    $A.util.toggleClass(toggleText, "toggle");
   },
    
})