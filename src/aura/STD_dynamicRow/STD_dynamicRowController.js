({
    validateComponent : function(component, event, helper) {
        return _extJsFormValidation.validateComponentHelper(component, event, helper, component.get("v.auraIdsToValidate"));    
    },
   
    
	loadInitialRow : function(component, event, helper) {
		helper.createRowOnLoad(component, helper);
	},
    
    handleRowEvent : function(component, event, helper) {

        var eventRowEvt = event.getParam("cmpRowNo");
        var isCreateRowEvt = event.getParam("isCreateNewComponent");
        var evtCmp = event.getParam("entireRowCmp");
       
        helper.createOrDeleteRow(component, helper, isCreateRowEvt, eventRowEvt, evtCmp);
	}
})