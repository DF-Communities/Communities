({
    onValidationChange: function(component, event, helper) 
    {
        component.set('v.context', component.get('v.context'));
    },
    
	submitApplication : function(component, event, helper) 
    {
		var community = component.get('v.context').community;
 
       // var _ = helper.getCommunityService(component, 'lodashService');
       /// var dataClone = _.cloneDeep(community);
      //  console.log(dataClone);

        // Make the current user the owner of the application so that the user who submits
        // the application is the user who gets notified on approval, in case this is a differenty
        // user from the person who created the application
        var currentUser = component.get('v.context').currentUser;
        component.set('v.context.community.OwnerId', currentUser.Id);


        return helper.requestCommunity(component, community)
        .then(function(c){
			window.location.replace('dfc_application_submitted?dfcid='+community.Id);
        })
        .catch(function(error){ 
            component.set('v.message',error.message||'Submit failed')
        });
	}

})