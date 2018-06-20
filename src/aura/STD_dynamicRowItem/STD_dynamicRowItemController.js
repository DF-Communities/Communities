({
    validateComponent : function(component, event, helper) {
        console.log("Validating STD_dynamicRowItem card");
        return helper.validateComponentHelper(component, event, helper);  
    },
    
    handleRowItemDetailUpdate : function(component, event, helper) {
        // This method is used to clear the row item error ui:message on any rowitem update
      var rowValidity = event.getParam("isValid");
        if(rowValidity) {
            component.set("v.isValid", true);
        }
    },
    
    AddNewRow : function(component, event, helper){

        var maxNoRowsAllowed = (component.get("v.maxNoRowsAllowed") != undefined) ? component.get("v.maxNoRowsAllowed") : 10000;
        
        if(component.get("v.rowIndex") < maxNoRowsAllowed - 1) { // Limit no rows
       	        
            var rowItemParams = helper.getAllParams(component, event);
            var isTimeDefValid = rowItemParams[0]["isValid"];
    
            if(rowItemParams == undefined){
                isTimeDefValid = false;
            } 
            
            if(isTimeDefValid) {
                component.set("v.outputParams", rowItemParams["params"]); 
                component.set("v.isValid", true);
                component.getEvent("STD_dynamicRowItemAddEvt").fire();     
            } else {
                component.set("v.isValid", false); // TODO : Error setting
            }
        } else {
            alert("You can only choose up to 3 time slots");
        }
    },
    
    RemoveRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("STD_dynamicRowItemDeleteEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
   
    
    validateAndGetParams : function(component, event, helper) {
        return helper.getAllParams(component); 
    }
    
})