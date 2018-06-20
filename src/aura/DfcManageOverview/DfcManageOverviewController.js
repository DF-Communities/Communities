({

  /*
    Implementing the change handler
    On a change, copy the data from the store to component attributes
    Lightning will see that the data has changed an update the rendering

    A component may not do anything to change the store data but if
    another component does change it then the handler runs again, the new
    data is copied and the rendering will update.
  */
  onCommunityStoreChange : function(component, event, helper) 
  {
    // event.getSource() givs us the DfcCommunityStore component that fired the change
	var communityStore = event.getSource().get('v.instance');
	
	// Copy the data out of the store into the attributes of this component
	communityStore.copyProperty(component, 'communityData');
	communityStore.copyProperty(component, 'county');
	communityStore.copyProperty(component, 'alliance');
  },

  nextView: function(component, event, helper) 
    {
      var e = component.get('e.CsqDispatch');
      e.setParam('action', 'CsqNextView');
      e.fire();
    },
    
    prevView: function(component, event, helper) 
    {
      var e = component.get('e.CsqDispatch');
      e.setParam('action', 'CsqPrevView');
      e.fire();
    }

})