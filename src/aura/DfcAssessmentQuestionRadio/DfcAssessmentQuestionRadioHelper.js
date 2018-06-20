({
	setSelection: function(component) 
    {
		var question = component.get('v.question');
		var answer = question.Entered_Answer__c;

        var other = question.Other_Selected__c;
        component.set('v.otherText', other?answer:null);
        
        var items = component.getSuper().find({instancesOf:'ui:inputRadio'});
        items.forEach(function(item){
          var text = item.get('v.text');
          var v = other ? item.getLocalId()=='other' : answer==text;
          item.set('v.value', v);
        });
        
	},
    
  	storeSelection: function(component, text) 
    {
        var other = text=='-@other@-';
        component.set('v.question.Other_Selected__c', other);
        var otherText = component.get('v.otherText');
        component.set('v.question.Entered_Answer__c', other?otherText:text);
	}

})