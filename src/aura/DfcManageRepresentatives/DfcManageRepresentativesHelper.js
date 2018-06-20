({
	clearNewRep : function(component) 
    {
        component.set('v.newRep', {Email:'',Name:''});
        component.set('v.newRepText', '');
        component.set('v.newRepMessage', '');
        component.set('v.newRepInviting',false);
	},
    
    /*

    formatRepresentatives: function(component)
    {
        var _ = component.find('lodashService').get('v.instance');
        var context = component.get('v.context');
    	var reps = _.sortBy(component.get('v.context.community.Representatives__r'), function(r){
                       var n = r.DF_Contact__c==context.currentContact.Id?0:(r.Role__c=='Invited'?9:1);
                       return n+r.Name.toLowerCase();
                   });
    }, */
    
    /* Sort the list of Representatives, so that Invited Representativs come last */
    formatRepresentatives: function(component, representatives)
    {
        var _ = component.find('lodashService').get('v.instance');
        if (!representatives) return representatives;

        var currentContact = component.get("v.currentContact");
      
    	  var reps = _.sortBy(representatives, function(r){
      //                 var n = r.Role__c=='Invited'?9:1;
        var n = r.DF_Contact__c==currentContact?0:(r.Role__c=='Invited'?9:1);
                       return n+r.Name.toLowerCase();
                   });

        return reps;
    },
})