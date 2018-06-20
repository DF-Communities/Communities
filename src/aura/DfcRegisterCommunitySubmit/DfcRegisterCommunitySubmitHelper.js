({
    getCommunityService : function(component)
    {
      return component.find('communityService').get('v.instance');
    },
    
	requestCommunity : function(component, community) 
    {
		var communityService = this.getCommunityService(component);
        community.Status__c = 'Requested';
        community.Date_Submitted__c = new Date();
        return communityService.updateCommunity(community);
	}

})