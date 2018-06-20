({
	onAssessmentStoreChange : function(component, event, helper) 
    {
        var status = component.get('v.status');

        var store = event.getSource().get('v.instance');
		store.copyProperty(component, 'yearEnding');
		store.copyProperty(component, 'yearNumber');
		store.copyProperty(component, 'dueDate');
		store.copyProperty(component, 'lastModifiedDate');
		store.copyProperty(component, 'lastModifiedName');
		store.copyProperty(component, 'submittedDate');
		store.copyProperty(component, 'questionGroups');
        store.copyProperty(component, 'status');

        if (store.status=='Submitted' && (status=='Draft'||status=='New')) 
			component.set('v.showSubmitMessage', true);
    },

    onCommunityStoreChange : function(component, event, helper) 
    {
		var communityStore =  event.getSource().get('v.instance');
		communityStore.copyProperty(component, 'firstAssessmentDate');
	}
		
})