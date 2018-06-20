({

  init: function(component, event, helper)
  {
       component.set('v.newRep', {});
  },

    onCommunityStoreChange : function(component, event, helper) 
    {
	  var communityStore = event.getSource().get('v.instance');
      communityStore.copyProperty(component, 'communityData')
      communityStore.copyProperty(component, 'currentContact');

      // Transform the activity data to a format we want (Like an Angular filter)
      var transform = function(data){ 
            return helper.formatRepresentatives(component, data)
      };

      communityStore.copyProperty(component, 'representatives', 'representatives', transform);

      var reps = component.get('v.representatives') ;
      console.log(reps);
    },
    
	onCommunityStoreActionComplete: function(component, event, helper)
    {
        var _ = component.find('lodashService').get('v.instance');

        var actionName = event.getParam('actionName');
        var actionData = event.getParam('actionData');

        if (actionName=='DfcAddRepresentative') {
			var store = event.getSource().get('v.instance');
            /*
             * If the email address we are adding is now among the representative data in the store then
             * the action succeeded. If not it failed because the email address is not present as a DF Contact. 
            */
            if (_.find(store.representatives, {Email:actionData.email})) {
                helper.clearNewRep(component);
            }
            else {
                component.set('v.newRepInviting',true);
                component.set('v.newRepText', "There is no registered user with this email address but you can add the user's name and invite them to register");
            }
        }
        
        if (actionName=='DfcInviteRepresentative') {
           helper.clearNewRep(component);
        }
        
    },
    
  	onRepresentativesChange : function(component, event, helper)
    {
        helper.formatRepresentatives(component);
    },


    onNewRepEmailChange: function(component, event, helper) 
    {
    var value = component.get('v.newRep.Email') ;
        var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        component.set('v.newRepDisabled', !re.test(value));
    },
    
    
	onAddRepresentative : function(component, event, helper)
    {
		  var rep = component.get('v.newRep')	;

      // Regular expression to test if email address is valid
      var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
      if (!re.test(rep.Email)) return;

      var communityData = component.get('v.communityData');
      var data = {communityId:communityData.Id, email:rep.Email};
    	var e = component.get('e.CsqDispatch');
    	e.setParam('action', 'DfcAddRepresentative');
    	e.setParam('data',data);
    	e.fire();
	  },
    
	onInviteRepresentative : function(component, event, helper) 
    {
		var rep = component.get('v.newRep');
        
        component.set('v.newRepShowErrors', true);
        if (!rep.Email||!rep.Email.trim()||!rep.Name||!rep.Name.trim()) return;

        var communityData = component.get('v.communityData');
        var data = {communityId:communityData.Id, email:rep.Email, name:rep.Name};
    	var e = component.get('e.CsqDispatch');
    	e.setParam('action', 'DfcInviteRepresentative');
    	e.setParam('data',data);
    	e.fire();
	},

	onRemoveRepresentative : function(component, event, helper) 
    {
  		var repId = event.srcElement.getAttribute('data-id');
        var communityData = component.get('v.communityData');
        var data = {communityId:communityData.Id, id:repId};
	    var e = component.get('e.CsqDispatch');
    	e.setParam('action', 'DfcRemoveRepresentative');
    	e.setParam('data',data);
    	e.fire();
	},
        
	onCancel : function(component, event, helper) 
    {
        helper.clearNewRep(component);
	},


})