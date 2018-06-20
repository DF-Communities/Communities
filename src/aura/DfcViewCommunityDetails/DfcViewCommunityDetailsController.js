({
	onCommunityStoreChange : function(component, event, helper) 
  {

	var communityStore = event.getSource().get('v.instance');
	communityStore.copyProperty(component, 'communityData');
	communityStore.copyProperty(component, 'county');

		
	},
	

})