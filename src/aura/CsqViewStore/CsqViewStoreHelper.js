({
	createInstance : function(cmp, Promise, _) 
    {
       'use strict'

        var properties = {
            "viewDefs": getViewDefs,   
            "selectedViewName": getSelectedViewName,
            "selectedViewOrdinal": getSelectedViewOrdinal   
        };

        var dispatchTable = {
            "CsqSelectView": onSelectView,   
            "CsqNextView": onNextView,   
            "CsqPrevView": onPrevView,
            "CsqSelectViewOrdinal": onSelectViewOrdinal, 
            "CsqUpdateViewErrorStatus": onUpdateViewErrorStatus, 
        };

        var state = {
           viewDefs: [],
           selectedViewName: null
       };
       
        function init()
        {
          var views = [];
          var defs = cmp.get('v.defs');
          defs.forEach(function(c){
              var view = {
                  id:c.getGlobalId(),
                  name:c.get('v.name'), 
                  label:c.get('v.label'), 
                  title:c.get('v.title'), 
                  showErrors:c.get('v.showErrors'), 
                  errors:[],
                  active:false, 
                  pristine:true
              };
			  views.push(view);
            });
            state.viewDefs = views;
            state.selectedViewName = views.length ? views[0].name : null;
            
			return Promise.resolve();
        }

        function getViewDefs()
        {
            return state.viewDefs;
        }

        function getSelectedViewName()
        {
            return state.selectedViewName;
        }

        function getSelectedViewOrdinal()
        {
            for (var i=0; i<state.viewDefs.length; i++) {
              if (state.viewDefs[i].name===state.selectedViewName) return i;
            }
            return -1;
        }

        function onSelectView(data)
        {
            var def = _.find(state.viewDefs, {name:data});
            if (def) selectView(data);                
            else $A.warning('Invalid view name '+data+' provided to select view action');
        }
        
        function onSelectViewOrdinal(ordinal)
        {
            var def = state.viewDefs[ordinal];
            if (def) selectView(def.name);                
            else $A.warning('Invalid view ordinal '+ordinal+' provided to select view ordinal action');
        }
        
        function selectView(name)
        {
            state.selectedViewName = name;                

            state.viewDefs.forEach(function(def){
              if (def.name===state.selectedViewName) {
                def.active = true;
              }
              else {
                if (def.active) def.pristine = false;
                def.active = false;
              }
            });
        }
        
        function onNextView()
        {
            var i = getSelectedViewOrdinal();
            onSelectViewOrdinal(i+1);
        }
        
        function onPrevView()
        {
            var i = getSelectedViewOrdinal();
            onSelectViewOrdinal(i-1);
        }
        
        function onUpdateViewErrorStatus(data)
        {        
            var key = data.key;
        	var valid = data.valid;
        	var ordinal = data.ordinal;
  
        	var def = state.viewDefs[ordinal];
            
        	var i = def.errors.indexOf(key);
        	if ((i>=0 && !valid) || (i<0 && valid)) return;
          
        	if (i>=0) def.errors.splice(i, 1);
        	else def.errors.push(key);          
        }   
        
        return { dispatchTable:dispatchTable, properties:properties, init:init, state:state };
	}
})