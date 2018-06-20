({


    initHandler : function(component, event, helper) 
    {
        var _ = helper.getService(component, 'lodashService');
        
    },


      /* Called when Country 'Change' button is clicked */
     onChangeCountry : function(component, event, helper) 
    {
     //   var context = component.get('v.context');

        var current = component.get('v.context.community.Country__c');
        if (current) {
            component.set('v.context.community.Country__c', current=='England'?'Wales':'England');
        }
        
        component.set('v.context.community.Central__c', null);

        component.set('v.context.community.Region__c', null);
        component.set('v.context.community.Region__r', null);
  //      component.set('v.context.selectedRegion', null);

        component.set('v.context.community.DA_Alliance__c', null);
        component.set('v.context.community.DA_Alliance__r', null);
    },

      onChangeCentral : function(component, event, helper) 
    {

        var current = component.get('v.context.community.Central_Location__c');

        if (current) {
            component.set('v.context.community.Central_Location__c', current=='Yes'?'No':'Yes');
        }

        if (current =='No') {
              component.set('v.context.community.County__c', null);
              component.set('v.context.community.Location__c', null);
              component.set('v.context.community.Location_Type__c', null);
        }
        
        component.set('v.context.community.Region__c', null);
        component.set('v.context.community.Region__r', null);
        component.set('v.context.community.Regional_Lead__c', null);

     //   component.set('v.context.selectedRegion', null);

        component.set('v.context.community.DA_Alliance__c', null);
        component.set('v.context.community.DA_Alliance__r', null);
    },

     onCountrySelect : function(component, event, helper) 
    {
        var country = event.currentTarget.getAttribute('data-country');

        var context = component.get('v.context');
        component.set('v.context.central', null);
        component.set('v.context.community.Country__c', country);
        component.set('v.context.community.Region__c', null);
        component.set('v.context.community.Region__r', null);
        component.set('v.context.community.Regional_Lead__c', null);

        component.set('v.context.selectedRegion', null);
        component.set('v.context.community.DA_Alliance__c', null);
        component.set('v.context.community.DA_Alliance__r', null);
        window.scrollTo(0, 140);
    },

    onCentralSelect : function(component, event, helper) 
    {
        var option = event.currentTarget.getAttribute('data-option');
        component.set('v.context.community.Central_Location__c', option);
         component.set('v.context.community.Why_No_Central_Location__c', null);
    },



    /* Called when region 'Change' button is clicked */
  	 onChangeRegion : function(component, event, helper) 
    {
        component.set('v.context.community.Region__c', null);
        component.set('v.context.community.Region__r', null);
        component.set('v.context.community.Regional_Lead__c', null);

        // Relevant for English communities only
        component.set('v.context.selectedRegion', null);
        component.set('v.context.community.DA_Alliance__c', null);
        component.set('v.context.community.DA_Alliance__r', null);
	},

	 onRegionSelect : function(component, event, helper) 
    {
    //  var region = event.currentTarget.getAttribute('data-region');
        var id = event.currentTarget.getAttribute('data-id');

        var context = component.get('v.context');     
        var r= context.getRegion(id);

        component.set('v.context.community.Region__c', id);
        component.set('v.context.community.Region__r', r);
    
        // For English Regions so we can select DAA 
        component.set('v.context.selectedRegion', r);

        if (context.community.Country__c==='England') {
                component.set('v.selectedRegion.Image_Name__c', r.Name.replace(/\s/g, '_')+'.png' );
               
                // Filter the full list of Alliances on  "Region__c"
                var _ = component.find('lodashService').get('v.instance');
                var regionalAlliances = _.filter(context.alliances, {'Region__c':r.Name});

                component.set('v.context.selectedRegion.alliances', regionalAlliances);

        }

        window.scrollTo(0, 140);
	},
    
  	 onEditAlliance : function(component, event, helper) 
    {
        var context = component.get('v.context');
        component.set('v.context.community.DA_Alliance__c', null);
        component.set('v.context.community.DA_Alliance__r', {}); ///////
	},

    onAllianceSelect : function(component, event, helper) 
    {
        var id = event.currentTarget.getAttribute('data-id');
        var context = component.get('v.context');

        component.set('v.context.community.DA_Alliance__c', id);
        component.set('v.context.community.DA_Alliance__r', context.getAlliance(id));
        component.set('v.context.community.Duplicate_Confirmation__c', false);
        
        var daaId = context.community.DA_Alliance__c;
		component.set('v.communitiesForDaa', []);
        
        var _ = component.find('lodashService').get('v.instance');

        var communityService = component.find('communityService').get('v.instance');


        communityService.getCommunitiesForDaa(daaId)
        .then( $A.getCallback( function(data){
          if (data && data.length) {
            data = _.filter(data, function(c){return c.Name__c && c.Name__c.trim();});
            component.set('v.communitiesForDaa', data);
          }
          else {
            component.set('v.context.community.Duplicate_Confirmation__c', true);
          }
        }));
	},

    /* If the user changes the Alliance we need to get the communities for the new
        Alliance and confirm it's not a duplicate */
    onAllianceChange : function(component, event, helper) 
    {
		var params = event.getParams();
        if (params.oldValue) return;
        
        var context = component.get('v.context');
		var daaId = context.community.DA_Alliance__c;
        if (!daaId||context.community.Duplicate_Confirmation__c) return;
        
        var _ = component.find('lodashService').get('v.instance');
        var communityService = component.find('communityService').get('v.instance');
        communityService.getCommunitiesForDaa(daaId)
        .then( $A.getCallback( function(data){
          if (data && data.length) {
            data = _.filter(data, function(c){return c.Name__c && c.Name__c.trim();});
            component.set('v.communitiesForDaa', data);
          }
          else {
            component.set('v.context.community.Duplicate_Confirmation__c', true);
          }
        }));
	},

    
    onDupConfirm : function(component, event, helper) 
    {
        var context = component.get('v.context');
        component.set('v.context.community.Duplicate_Confirmation__c', true);
	},

    /* Called when the user selects a different country in the radio list */
    countryChangeHandler: function(component, event, helper)
    {
        var comm = component.get('v.context').community;
        comm.Country__c = event.source.get('v.label');
        component.set('v.context', component.get('v.context'))
    }

})