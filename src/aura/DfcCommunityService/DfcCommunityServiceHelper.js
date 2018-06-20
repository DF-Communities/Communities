({

	createInstance : function(cmp) 
    {
		'use strict'

        var _ = cmp.find('lodashService').get('v.instance');
        var Promise = cmp.find('promiseService').get('v.instance');
        var repositoryService = cmp.find('repositoryService').get('v.instance');

        var sessionId = null;
		    
        function CommunityService()
        {
	         var self = this;
            
            self.INJECT_COMPONENT = true;
            

            // Get Draft Community for current user - creates a new community if current user doesn't have one

            
            self.getCurrentDraftWithContext = function(component)
            {
           
               var id = getPassedCommunityId();                  // If we are editing a community that exists we should have an id
              
               var action = component.get('c.getCommunityWithContext') 
               if (id) action.setParam('Id', id);
               return repositoryService.remoteCall(action)
               .then(function(data){
                   return formatContext(data);
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
            };

            
            
        
     
            function formatContext(context)
            {
                context.counties  = _.sortBy(context.counties,  'Name');
                context.alliances = _.sortBy(context.alliances, 'Name');

                var regions  = _.sortBy(context.regions, 'Sequence__c');

                // Needed for the getRegion function below
                var regionsWithImage = _.map(regions, function(r){
                     return { Id:r.Id, Name: r.Name, Image_Name__c:r.Name.replace(/\s/g, '_')+'.png' };
                });


                context.regionsWales = _.map(_.filter(regions, {Country__c:'Wales'}), function(r){
                     return { Id:r.Id, Name: r.Name};
                });

                context.regionsEngland = _.map(_.filter(regions, {Country__c:'England'}), function(r) {
                     return { Id:r.Id, Name: r.Name, Image_Name__c:r.Name.replace(/\s/g, '_')+'.png' };
                });

                context.countiesWales   =_.filter(context.counties, function(c) { return (c.Country__c === 'Wales') });
                context.countiesEngland =_.filter(context.counties, function(c) { return (c.Country__c === 'England') });


                context.getAlliance = function(id){return _.find(context.alliances, 'Id', id); };
                context.getRegion   = function(id){return _.find(regionsWithImage, {Id: id }); };

                var community = context.community;

                var region = _.find(regionsWithImage, {'Id': community.Region__c});

              //  region.selected = true;
                context.selectedRegion = region; 

                if (region != null && community.Country__c=='England') {

                    context.selectedRegion.alliances = _.filter(context.alliances, {'Region__c':region.Name});

                    var allianceId = community.DA_Alliance__c;
                    if (allianceId) {
                        var alliance = _.find(context.alliances, 'Id', allianceId);
                        alliance.selected = true;
                    }
                

                }
                formatCommunity(context.community);
                
                return context;
            };

            // Get Active Community for current user, including Representatives and Plans
            self.getCurrentActiveWithContext = function(component)
            {
               var action = component.get('c.getActiveForUserWithContext');  // Dfc_CommunityServiceController
               return repositoryService.remoteCall(action)
               .then(function(data){
                   console.log(_.merge({}, data));
                   return data;
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
            };
            
            /*
            self.getDraft = function(component)
            {
               var action = component.get('c.getCurrentDraftForUser');
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return data;
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
            };


            self.getActive = function(component)
            {
               var action = component.get('c.getCurrentActiveForUser');
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return data;
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
            };

             */
            
            self.updateCommunity = function(component, community)
            {
               var action = component.get('c.updateCommunity');
                
              community = _.merge({},community);
              delete community.DA_Alliance__r;
          //    console.log(community)
               action.setParam("community", community);
               action.setParam("actionAreas", community.Action_Areas__r);
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return data;
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
           };
            
            self.createCommunity = function(component, community)
            {
               var action = component.get('c.createCommunity');
               action.setParam("community", community);
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return data;
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
           };
            
            self.setSessionId = function(component, id)
            {
                sessionId = id;
            };
    
            self.addRepresentative = function(component, community, email)
            {
               var action = component.get('c.addRepresentative');
               action.setParam("communityId", community.Id);
               action.setParam("email", email);
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return formatRepresentative(data);
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
           };
            
            self.inviteRepresentative = function(component, community, email, name)
            {
               var action = component.get('c.inviteRepresentative');
               action.setParam("communityId", community.Id);
               action.setParam("email", email);
               action.setParam("name", name);
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return formatRepresentative(data);
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
           };
            
            self.deleteRepresentative = function(component, community, repid)
            {
               var action = component.get('c.deleteRepresentative');
               action.setParam("communityId", community.Id);
               action.setParam("id", repid);
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return data;
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
           };
            
            self.getCommunitiesForDaa = function(component, id)
            {
               var action = component.get('c.getCommunitiesForDaa');
               action.setParam('daaId', id);
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return data;
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
            };
            
           
            self.getAlliancesForRegion = function(component, region)
            {
               var action = component.get('c.getAlliancesForRegion');
               action.setParam('region', region);
           
               return repositoryService.remoteCall(action)
                 .then(function(data){
                   return data;
                 })
                .catch(function(e){ console.log(e); return Promise.reject(e); });
            };


            function formatCommunity(comm)
            {
                comm.Representatives__r = _.each(comm.Representatives__r, function(rep){
                    formatRepresentative(rep);
                });
                return comm;
            }

            function formatRepresentative(rep)
            {
                if (!rep) return rep;
                rep.Name = rep.Role__c == 'Invited' ? rep.Invited_Name__c : rep.DF_Contact__r.Name;
                rep.Email = rep.Role__c == 'Invited' ? rep.Invited_Email__c : rep.DF_Contact__r.Email__c;
                return rep;
            }

            function getPassedCommunityId()
            {
              var a = /[?&]dfcid=([^&#]*)/g.exec(location.search);
              return a ? decodeURIComponent(a[1].replace(/\+/g, " ")) : null;
             }
    

        }
        
        return new CommunityService();
    },


})