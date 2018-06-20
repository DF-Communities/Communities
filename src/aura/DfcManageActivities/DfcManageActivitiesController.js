({
	onCommunityStoreChange : function(component, event, helper) 
    {
	  var communityStore =  event.getSource().get('v.instance');
	  communityStore.copyProperty(component, 'communityData');
	  communityStore.copyProperty(component, 'actionAreas');
              
     // Check that there are some selected Action Areas (as in the case of imported pre-existing communities, these won't exist)
    var actionAreas = component.get('v.actionAreas');
    var _ = component.find('lodashService').get('v.instance');
        
 //   var firstSelectedArea = _.find(actionAreas, { Selected__c:true });   
   // component.set('v.noSelectedAreas', (!firstSelectedArea ? true : false));   
        
    // Transform the activity data to a format we want 
     var transform = function(data){ 
         return helper.formatActivities(component, data)
     };

     /*
      * Capture the activities. If we see a change, indicated by true returned, then dismiss any
      * open edit form. This will clean up after a successful edit form submission. 
      */
     if (communityStore.copyProperty(component, 'activities', 'v.activities', transform)) {
          component.set('v.editingId', '');
          component.set('v.removingId', '');
          component.set('v.addingActivity', false);
          component.set('v.addingAttachmentFor', '');
       }
	},
          
	onNewActivityClicked : function(component, event, helper) 
    {
        var adding = component.get('v.addingActivity');
        component.set('v.addingActivity', !adding);
        component.set('v.editingId', null);
        component.set('v.addingAttachmentFor', null);
	},
    
	onAddActivity : function(component, event, helper) 
    {
        var communityData = component.get('v.communityData');
        console.log('in onAddActivity. communityData ='+communityData);
        var data = event.getParam('data');

        data.communityId = communityData.Id;
        var e = component.get('e.CsqDispatch');
        e.setParam('action', 'DfcAddActivity');
        e.setParam('data', data);
        e.fire();
	},
    
	onCancelAddActivity : function(component, event, helper) 
    {
        component.set('v.addingActivity', false);
	},
    
	onEditActivityClicked : function(component, event, helper) 
    {
        var id =  event.target.getAttribute('data-id');
        var editing = component.get('v.editingId');
        if (id==editing) {
          component.set('v.editingId', null);
        }
        else {
       	  var _ = component.find('lodashService').get('v.instance');
          var activities = component.get('v.activities');
          var act = _.find(activities, {Id:id});
          component.set('v.editingData', _.clone(act));
          component.set('v.editingId', id);
          component.set('v.addingActivity', false);
          component.set('v.removingId', null);
          component.set('v.addingAttachmentFor', null);
        }
	},
    
	onCancelUpdateActivity : function(component, event, helper) 
    {
       component.set('v.editingId', null);
	},
    
	onUpdateActivity : function(component, event, helper) 
    {
        var communityData = component.get('v.communityData');
        var data = event.getParam('data');

        var e = component.get('e.CsqDispatch');
        e.setParam('action', 'DfcUpdateActivity');
        e.setParam('data', data);
        e.fire();
	},
    
	onAddAttachmentClicked : function(component, event, helper) 
    {
        var id =  event.target.getAttribute('data-id');
        var adding = component.get('v.addingAttachmentFor');
        component.set('v.addingAttachmentFor', id==adding?null:id);
        component.set('v.editingId', null);
        component.set('v.addingActivity', false);
	},
    
    
    onCancelAddAttachment: function(component, event, helper) 
    {
        component.set('v.addingAttachmentFor', null);
	},
    
	onRemoveActivityClicked: function(component, event, helper) 
    {
        var activityId =  event.target.getAttribute('data-id');
        component.set('v.removingId', activityId);
	},
    
	onConfirmRemoveActivity: function(component, event, helper) 
    {
        var activityId =  event.target.getAttribute('data-id');
        var e = component.get('e.CsqDispatch');
        e.setParam('action', 'DfcRemoveActivity');
        e.setParam('data', activityId);
        e.fire();
	},
    
	onCancelRemoveActivity: function(component, event, helper) 
    {
        component.set('v.removingId', '');
	},
    
	onRemoveAttachment: function(component, event, helper) 
    {
        var activityId =  event.target.getAttribute('data-act-id');
        var attachmentId =  event.target.getAttribute('data-id');
        var e = component.get('e.CsqDispatch');
        e.setParam('action', 'DfcRemoveActivityAttachment');
        e.setParam('data', { activityId: activityId, attachmentId: attachmentId });
        e.fire();
	},
    
})