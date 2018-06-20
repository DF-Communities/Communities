({
onCommunityStoreChange : function(component, event, helper) 
  {

  // event.getSource() givs us the DfcCommunityStore component that fired the change
	var communityStore = event.getSource().get('v.instance');

  // Copy the data out of the store into the attributes of this component

  communityStore.copyProperty(component, 'communityData');

  communityStore.copyProperty(component, 'region');
  communityStore.copyProperty(component, 'alliance');


  var country = component.get('v.communityData.Country__c');      
  var regionName  = component.get('v.region.Name');


  if (country==='England' && regionName) {
	       // Convert the region name to the image name
       
         component.set('v.regionImage', regionName.replace(/\s/g, '_')+'.png' );
     };
  },

    nextView: function(component, event, helper) 
  {
        var e = component.get('e.CsqDispatch');
      e.setParam('action', 'CsqNextView');
      e.fire();
   }


})