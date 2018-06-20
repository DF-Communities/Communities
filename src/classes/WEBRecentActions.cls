public without sharing class WEBRecentActions {
    public List<Action__c> actions {
        get {
            if (actions == null)
                actions = new List<Action__c>();
            return actions;
        }
        private set;
    }

    public WEBRecentActions() {
    
       StaticResource stat = [Select body, name from StaticResource where Name = 'DF_Swear_Words_List' limit 1];
        String[] wordlist = stat.body.tostring().split('[\n\r]'); 
        Set<string> wordset = new Set<string>();
       
        for(String sr:wordlist){
            wordset.add(sr);           
       }
     
       for (Action__c a: [SELECT DF_Contact__r.Name, DF_Contact__r.Id, Id, Action__c, Public__c, Homepage__c FROM Action__c WHERE Public__c = TRUE   ORDER BY CreatedDate DESC LIMIT 10]){
       
        system.debug('Action split @'+a.Action__c.toLowerCase().split(' '));
        string[] words = a.Action__c.toLowerCase().split(' ');
        if(stringContainsItemFromSet(words,wordset)){
        continue;
        }
        
        system.debug('string contains@@'+stringContainsItemFromSet(words,wordset));
        actions.add(a);
        
        }       
    
  }
  
        
  
  public boolean stringContainsItemFromSet(String[] items,Set<String> badWordsSet)
  {
   system.debug('enter method stringContainsItemFromSet'+items);
    
    for(integer i=0; i < items.size(); i++)
    {
        if(badWordsSet.contains(items[i]))
        {
        system.debug('items@@'+items[i]);
        
       
         
         return true;
         i= items.size();
        }
        
    }
    return false;
  }

 }