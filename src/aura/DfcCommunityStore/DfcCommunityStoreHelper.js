({
  // Use actionService to retrieve data via Apex  See Dfc_CommunityStoreController.cls
	createInstance : function(cmp, Promise, _, actionService) 
    {
       'use strict'
        /* These are the read only properties this store exposes */
        var properties = {
            "communityData": getCommunityData,
            "representatives": getRepresentatives,
            "actionAreas": getActionAreas,
            "activities": getActivities,
            "country": getCountry,
            "region": getRegion,
            "county": getCounty,
            "alliance": getAlliance,
            "currentContact": getCurrentContact,
            "firstAssessmentDate": getFirstAssessmentDate,
        };

        /* These are the actions you can invoke through CsqDispatch 
           These actions may take arguements
        */
        var dispatchTable = {
            "DfcUpdateCommunity": onUpdateCommunity,   
            "DfcUpdateActionAreas": onUpdateActionAreas,
            "DfcAddRepresentative": onAddRepresentative,   
            "DfcInviteRepresentative": onInviteRepresentative,   
            "DfcRemoveRepresentative": onRemoveRepresentative,   
            "DfcAddActivity": onAddActivity,   
            "DfcUpdateActivity": onUpdateActivity,   
            "DfcRemoveActivity": onRemoveActivity,   
            "DfcUpdateAttachments": onUpdateAttachments,
            "DfcRemoveActivityAttachment": onRemoveActivityAttachment,
        };

       /* This var holds the current state of the data and can change as actions happen 
          When the data chnges, onStoreChanged gets fired
       */
       var state = {
           communityData: {},
           representatives: [],
           actionAreas: [],
           activities: [],
           country: null,
           region: null,
           county: null,
           alliance: null,
           currentContact: null,
       };
       
       var attachmentSignedIds = {};
        
       function init()
       {
            var loadCommunity = loadCommunityData(); // Includes representtives, county and alliance data
            // These need separate queries due to SOQL only being able to go down one level
            var loadActivities = loadActivityData();
            var loadActionAreas = loadActionAreaData();
            var loadCurrentContact = loadCurrentContactData();
            return Promise.all(loadCommunity, loadActivities, loadActionAreas, loadCurrentContact);
       }

       function loadCommunityData()
       {
          var id = getPassedCommunityId();
          
          var action = id ? actionService.get('getCommunity') : actionService.get('createNewCommunityForCurrentUser');

          var action =  actionService.get('getCommunity');
          if (id) action.setParam('Id', id);
          
          return actionService.run(action, function(data){
            formatCommunityData(data);
          });
       }

	     function getPassedCommunityId()
       {
          var a = /[?&]dfcid=([^&#]*)/g.exec(location.search);
          return a ? decodeURIComponent(a[1].replace(/\+/g, " ")) : null;
       }

       function loadActivityData()
       {
          var id = getPassedCommunityId();
	      var action = actionService.get('getCommunityActivities');
          if (id) action.setParam('Id', id);
          return actionService.run(action, function(data){
            formatActivityData(data);
          });
       } 

       function loadActionAreaData()
       {
        var id = getPassedCommunityId();
  		var action = actionService.get('getCommunityActionAreas');
        if (id) action.setParam('Id', id);
        return actionService.run(action, function(data){
            formatActionAreaData(data);
          });
       }

       function loadCurrentContactData()
        {
           var action = actionService.get('getCurrentContactId');
           return actionService.run(action, function(data){
             formatCurrentContactData(data);   // Copy data to state 
           });
        }

        function getCommunityData()
        {
            return state.communityData;
        }
        function getRepresentatives()
        {
            return state.representatives;
        }
        function getActionAreas()
        {
            return state.actionAreas;
        }
        function getActivities()
        {
            return state.activities;
        }
        function getCountry()
        {
            return state.country;
        }

        function getRegion()
        {
            return state.region;
        }

        function getCounty()
        {
            return state.county;
        }
        function getAlliance()
        {
            return state.alliance;
        }
        function getCurrentContact()
        {
            return state.currentContact;
        }
        function getFirstAssessmentDate()
        {
            var ad = state.communityData.Date_Approved__c;
            if (!ad) return null;
            var year = ad.getFullYear();
            var month = ad.getMonth();
            var day = ad.getDate();
            if (month==1&&day==29) day = 28;
            return new Date(year+1, month, day, 12);
        }
        
        function onUpdateCommunity(data)
        {

            
        }

        function onUpdateActionAreas(data)
        {
            var action = actionService.get('updateActionAreas');
            action.setParams(data);
            return actionService.run(action, function(data){
                formatActionAreaData(data)
           });
            
        }
        
        function onAddRepresentative(data)
        {
            var action = actionService.get('addRepresentative');
            action.setParams(data);
            return actionService.run(action, function(rep){
                if (rep) mergeRepresentative(rep);
           });
        }
        
        function onInviteRepresentative(data)
        {
            var action = actionService.get('inviteRepresentative');
            action.setParams(data);
            return actionService.run(action, function(rep){
				mergeRepresentative(rep);
            });
        }
        
        function onRemoveRepresentative(data)
        {
            var action = actionService.get('removeRepresentative');
            action.setParams(data);
            return actionService.run(action, function(){
               state.representatives = _.reject(state.representatives, {Id:data.id});
            });
        }
        
        function onAddActivity(data)
        {
            var action = actionService.get('addActivity');
            data = _.cloneDeep(data);
            //Workaround for bug that arises when a string array is sent to an apex method
            data.actionAreaIds = data.actionAreaIds && JSON.stringify(data.actionAreaIds);
            action.setParams(data);
            return actionService.run(action, function(resp){
                mergeActivity(resp.activity);
               // formatActionAreaData(resp.actionAreaData);
            });
        }
        
        function onUpdateActivity(data)
        {
		    var action = actionService.get('updateActivity');
            data = _.cloneDeep(data);
            if (!data.activity.Id||!data.activity.Community__c) 
                throw new Error('Invalid data:'+JSON.stringify(data));
            delete data.Attachments;
            data.actionAreaIds = data.actionAreaIds && JSON.stringify(data.actionAreaIds);
            action.setParams(data);
            return actionService.run(action, function(resp){
                mergeActivity(resp.activity);
                //formatActionAreaData(resp.actionAreaData);
            });
        }
        
        function onRemoveActivity(data)
        {
			var action = actionService.get('removeActivity');
            action.setParam('activityId', data);
            return actionService.run(action, function(resp){
                state.activities = _.reject(state.activities, {Id:data});
                //formatActionAreaData(resp);
            });
        }
        
        function onRemoveActivityAttachment(data)
        {
			var action = actionService.get('removeActivityAttachment');
            action.setParams(data);
            return actionService.run(action, function(resp){
                var act = _.find(state.activities, {Id:data.activityId});
                act.Attachments = _.reject(act.Attachments, {Id:data.attachmentId});
            });
        }
        
        function onUpdateAttachments(data)
        {
            var act = _.find(state.activities, {Id:data.recordId});
            if (!act) throw new Error('Invalid activty id '+data.recordId);
            act.Attachments = data.attachments;
        }

        //will need to catch dispatch of the step switch , keep track of the current state here and perform save 
        //on switch if an attribute says to
        function save()
        {
        //TODO clone the community, fix up non-numeric population and anything else that might prevent save

        
       communityService.updateCommunity(context.community)
       .then(function(){
           if (!context.updateError) return;
           component.set('v.alert', '');
           context.updateError = null;
           $A.get('e.c:DfcValidationChange').fire();
       })
       .catch(function(error){
           var msg = error.message||'Save failed ';
           component.set('v.alert', msg);
           context.updateError = msg;
           $A.get('e.c:DfcValidationChange').fire();   
       }); 
            
        }
        
        /*
         * The activities or action areas will change when no other details change
         * We don't want this to cause components that have no interest in activites to rerender 
         * data is the data from Apex
         */
        function formatCommunityData(data)
        {
           // Move the related data into separate state variables
           state.representatives = data.Representatives__r;
           state.alliance = data.DA_Alliance__r;
           state.country = data.Country__r;
           state.region = data.Region__r;          
           state.county = data.County__r;

           // Delete the related data 
           delete data.Representatives__r;
           delete data.DA_Alliance__r;
           delete data.County__r;
           delete data.Region__r;
           
           data.Date_Approved__c = new Date(data.Date_Approved__c);
           state.communityData = data;
            
            _.each(state.representatives, formatRepresentative);
            state.representatives = formatRepresentatives(state.representatives);
        }

        function formatActivityData(data)
        {
           state.activities = data.activities;
           attachmentSignedIds = data.sdata;
           _.each(state.activities, formatActivity);
        }   

        function formatCurrentContactData(data)            
        {
            state.currentContact = data;
        }
        
        function formatActivity(act)
        {
            if (!act) return;
            _.each(act.Attachments, function(att){
               att.signedId = attachmentSignedIds[att.Id];
            });
        }               
        
        function formatActionAreaData(data)
        {
            console.log(data)
           state.actionAreas = data;
        }               
        
        function mergeActivity(act)
        {
            formatActivity(act);
            state.activities = _.reject(state.activities, {Id:act.Id});
            state.activities.push(act);
        }    

        function mergeRepresentative(rep)
        {
            formatRepresentative(rep);
            state.representatives = _.reject(state.representatives, {Id:rep.Id});
            state.representatives.push(rep);
        }
        
        /*
         *  Use the name and email address from the user's DF_Contact record if they are a registered user
         */
        function formatRepresentative(rep)
        {
            if (!rep) return;
            rep.Name = rep.Role__c == 'Invited' ? rep.Invited_Name__c : rep.DF_Contact__r.Name;
            rep.Email = rep.Role__c == 'Invited' ? rep.Invited_Email__c : rep.DF_Contact__r.Email__c;
        }  

        /* Sort the list of Representatives, so that Invited Representativs come last */
        function formatRepresentatives(representatives)
        {
          if (!representatives) return representatives;

          var representatives= _.sortBy(representatives, function(r){
                var n = r.DF_Contact__c==state.currentContact?0:(r.Role__c=='Invited'?9:1);
                return n+r.Name.toLowerCase();
              });

          return representatives;
        }             
        
        return { dispatchTable:dispatchTable, properties:properties, init:init, state:state };
	}
})