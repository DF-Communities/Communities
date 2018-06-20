({

  onCommunityStoreChange : function(component, event, helper) 
  {
      helper.copyFromStore(component);
  },

  communityStoreActionComplete: function(component, event, helper) 
  {
   component.set('v.editMode', false);        
  },

  onEditClicked : function(component, event, helper) 
  {
    component.set('v.editMode', true);
  },

  onCancelClicked : function(component, event, helper) 
  {
    helper.copyFromStore(component);
    component.set('v.editMode', false);
  },

 onSaveClicked : function(component, event, helper) 
 {
    var ret = {};
    component.find('validationTracker').validate(ret);
	if (!ret.valid) return;

   var communityData  = component.get('v.communityData');

   var data = {};
   var areas = component.get('v.actionAreas');

   data.actionAreas = areas;
    
   data.communityId = communityData.Id;

   var e = component.get('e.CsqDispatch');
   e.setParam('action', 'DfcUpdateActionAreas');
   e.setParam('data', data);
   e.fire();
 },

})