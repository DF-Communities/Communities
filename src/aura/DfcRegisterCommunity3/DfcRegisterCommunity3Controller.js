({
  	init : function(component, event, helper) 
    {
     
        component.set('v.newRep', {});
        helper.formatRepresentatives(component);
    },
    
  	onRepresentativesChange : function(component, event, helper)
    {
     
        helper.formatRepresentatives(component);
    },
    
    onNewRepEmailChange: function(component, event, helper) 
    {
		var value = component.get('v.newRep.Email')	;
        var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        component.set('v.newRepDisabled', !re.test(value));
    },
    
	onAddRepresentative : function(component, event, helper)
    {
		var rep = component.get('v.newRep')	;
		var context = component.get('v.context');
        var communityService = component.find('communityService').get('v.instance');
        communityService.addRepresentative(context.community, rep.Email).
        then(function(data){
            if (data==null){
                component.set('v.newRepInviting',true);
                component.set('v.newRepText', "There is no registered user with this email address but you can add the user's name and invite them to register");
            }   
            else{
                context.community.Representatives__r.push(data);
                helper.clearNewRep(component);
           		component.set('v.context', context);
            }
        })
        .catch(function(err){component.set('v.newRepText', err.message)});
	},
    
	onInviteRepresentative : function(component, event, helper) 
    {
        component.set('v.newRepShowErrors', true);
		var rep = component.get('v.newRep');
        if (!rep.Email||!rep.Email.trim()||!rep.Name||!rep.Name.trim()) return;
        
		var context = component.get('v.context')	;
        var communityService = component.find('communityService').get('v.instance');
        communityService.inviteRepresentative(context.community, rep.Email, rep.Name).
        then(function(data){
           context.community.Representatives__r.push(data);
           helper.clearNewRep(component);
           component.set('v.context', context);
        });
	},
        
	onDeleteRepresentative : function(component, event, helper) 
    {
		var context = component.get('v.context');
		var repid = event.srcElement.getAttribute('data-id');

        var _ = component.find('lodashService').get('v.instance');
        var communityService = component.find('communityService').get('v.instance');

        communityService.deleteRepresentative(context.community, repid).
        then(function(){
           context.community.Representatives__r = _.filter(context.community.Representatives__r, function(r){return r.Id != repid});
           component.set('v.context', context);
        });
	},
        
	onCancel : function(component, event, helper) 
    {
        helper.clearNewRep(component);
	}
})