({
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
    },
})