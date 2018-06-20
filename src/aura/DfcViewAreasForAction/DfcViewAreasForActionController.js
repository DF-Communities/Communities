({
onCommunityStoreChange : function(component, event, helper) 
  {
  // event.getSource() givs us the DfcCommunityStore component that fired the change
	var communityStore = event.getSource().get('v.instance');
	
	communityStore.copyProperty(component, 'actionAreas');
  },




})