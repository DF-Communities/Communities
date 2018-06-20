({
	 doInit : function(component, event, helper) {
       helper.getDFCon(component);
       helper.getUserDetails(component);  
       helper.getPicklistValues(component);
       helper.getCurrentUser(component);
     } ,
     save : function(component, event, helper) {
        console.log('save:1');
       var action2 = component.get("c.saveDFC");
       var dfcon= component.get("v.dfcon");
         
        action2.setParams({"dfcon": dfcon});
        action2.setCallback(this, function() {  console.log('SAVED.');  } );
        $A.enqueueAction(action2);
        console.log('save:end');
          var editFields = component.find("box");
          var viewFields = component.find("viewRecord");
          var cancelBtn = component.find('cancelBtn');
          var editButton = component.find('editBtn');
		  var saveButton = component.find('saveBtn');
         
        $A.util.toggleClass(editFields, "editfm");
        $A.util.toggleClass(viewFields, "viewfm");
        $A.util.addClass(cancelBtn,"slds-hide");
        $A.util.removeClass(editButton,"slds-hide");
        $A.util.addClass(saveButton,"slds-hide");
    },
    
    editpage : function(component, event, helper) {

        var editFields = component.find("box");
        var viewFields = component.find("viewRecord");
        var cancelBtn = component.find('cancelBtn');
        var editButton = component.find('editBtn');
        var saveButton = component.find('saveBtn');
        
        $A.util.toggleClass(editFields, "editfm");
        $A.util.toggleClass(viewFields, "viewfm");
   		$A.util.removeClass(cancelBtn,"slds-hide");
        $A.util.addClass(editButton,"slds-hide");
        $A.util.removeClass(saveButton,"slds-hide");
    },
    canceledit : function(component, event, helper) {
		
        var action3 = component.get("c.cancelSave");
        var dfcon = component.get("v.dfcon");
        action3.setParams({ "dfcon":dfcon });
        action3.setCallback(this,function(response) {
             var data = response.getReturnValue();
             component.set("v.dfcon",data);
        });
        $A.enqueueAction(action3);
        var editFields = component.find("box");
        var hiddenFields = component.find("viewRecord");
        var cancelBtn = component.find('cancelBtn');
        var editButton = component.find('editBtn');
        var saveButton = component.find('saveBtn');
        
        console.log(hiddenFields );
        $A.util.toggleClass(editFields, "editfm");
        $A.util.removeClass(hiddenFields,"viewfm");
        $A.util.addClass(cancelBtn,"slds-hide");
        $A.util.removeClass(editButton,"slds-hide");
        $A.util.addClass(saveButton,"slds-hide");
    },
    
   
    display : function(component, event, helper) {
    helper.toggleHelper(component, event);
    },

   displayOut : function(component, event, helper) {
   helper.toggleHelper(component, event);
  },

})