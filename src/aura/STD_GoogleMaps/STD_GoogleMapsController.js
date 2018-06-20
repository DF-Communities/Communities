({
	doInit : function(component, event, helper) {
	    //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
        console.log("In maps doInit");
        console.log("+++++ ++++ window.location.hostname: " + window.location.hostname);
        component.set('v.lcHost', window.location.hostname);
                      
  		//Add message listener for events from VF to LC
        window.addEventListener("message", function(event) {
            console.log("LTNG: Received message from VF");
            //Can enable origin control for more security
            //if (event.origin != vfOrigin) {
                //console.log('Wrong Origin');
                // Not the expected origin: Reject the message!
                //return;
            //}
            
            // Handle the message
            if(event.data.state == 'LOADED'){
                //Set vfHost which will be used later to send message
                console.log("Map detected as loaded");
                component.set('v.vfHost', event.data.vfHost);
                
                //Send data to VF page to draw map
                helper.sendToVF(component, helper);
            }
        }, false);
	}
})