({  doInit : function(component, event, helper) {
       helper.getCurrentUser(component);
      helper.getCurrentUserName(component);
      
        
    },
	gotoHome : function (component, event, helper) {
     
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/"
    });
    urlEvent.fire();
},
    gotoProfile : function (component, event, helper) {
    var urlEvent = $A.get("e.force:navigateToURL");
    var rec = component.get("v.userId");
    urlEvent.setParams({
        "url": "/profile/"+rec
    });
    urlEvent.fire();
},
      gotoSettings : function (component, event, helper) {
    var urlEvent = $A.get("e.force:navigateToURL");
    var rec = component.get("v.userId");
    urlEvent.setParams({
        "url": "/settings/"+rec
    });
    urlEvent.fire();
},
  
  gotoLogout : function(component, event, helper) {
    var stubUrl = component.get("v.stub_url");
    console.log('stubUrl'+stubUrl);
        window.location.replace(stubUrl+"exchange/secur/logout.jsp?retUrl="+stubUrl+"home");
    },
})