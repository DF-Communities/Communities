global class DF_Pure360_WelcomeEmail_Batcher implements Database.Batchable<SObject>,Database.AllowsCallouts,  Database.Stateful, Schedulable{
 
 public Map<String,list<string>> mapliststrings ;
 public string pOption1 =  'Get in touch with someone with dementia';
 public string pOption2 =  'Volunteer for an org that helps PWD';
 public string pOption3 =  'Campaign for change';
 public string pOption4 =  'Wear my badge and tell five friends';
 public string pOption5 =  'Carry out own action';    
 public List<string> standardActions = new List<string> {pOption1,pOption2,pOption3,pOption4,pOption5 };
 public Map<string,string> mapActionNames = new Map<string,string> {pOption1=>'GetInTouch',pOption2=>'Volunteer',pOption3=>'Campaign',pOption4=>'WearBadge',pOption5=>'Personal' };
 
 // Batch class to update df contacts with portal user
   
    public String query;
 
        global void execute( SchedulableContext SC )
        {
          // batch run 
          DF_Pure360_WelcomeEmail_Batcher batch = new DF_Pure360_WelcomeEmail_Batcher();
          Database.executeBatch( batch, 4 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
      
            Date dt = System.today();
            //string dId ='a0311000006Migx';
            query = 
                'Select Id, ' +
                'Last_Name__c, '+
                'First_name__c, '+
                'Name__c, '+
                'Email__c, '+
                'Created_As_Type__c '+
                ' From ' +
                'DF_Contact__c ' +
                ' Where ' +
                'Newsletters__c = true '+
                'and createdDate =Today';
                //'Id=:dId' ;
                
    
            system.debug('+++Query+++'+ query);
            if(Test.isRunningTest())
                {
                    query += ' Limit 1';
                }

            return Database.getQueryLocator(query);
        }

       global void execute(Database.BatchableContext BC, List<SObject> scope)
       {
        
         List<DF_Contact__c > lisDfc = new List<DF_Contact__c>();
           for ( sObject s : scope ) {
              
              DF_Contact__c  c = (DF_Contact__c)s;
             
              lisDfc.add(c);
            }
          
       Set<Id> dfcIds = new Set<Id>();
       Set<Id> noActionsDfcIds = new Set<Id>();
       Map<String,String> mapActions = new Map<String,String>();
          for( DF_Contact__c dfc:lisDfc)
          {  
           dfcIds.add(dfc.Id);
          }
     
     
      List<Action__c> act = [select id,Standard_Actions__c,DF_Contact__c,Action__c  from Action__c where DF_Contact__c  in:dfcIds];
          for(Action__c a : act)
          {   
            mapActions.put(a.DF_Contact__c+'~'+a.Standard_Actions__c,a.Standard_Actions__c);
            noActionsDfcIds.add(a.DF_Contact__c);
          }
 
      for( DF_Contact__c dfc:lisDfc )
      {
       
      list<String> lisstring = new List<String>();
      mapliststrings = new Map<String,list<String>>();
       
      if( dfc.Created_As_Type__c =='Friend' || dfc.Created_As_Type__c =='Champion'|| dfc.Created_As_Type__c =='Digital Friend' )
      {
        lisstring.add('email='+dfc.Email__c);
        lisstring.add('firstName='+dfc.First_Name__c);
        lisstring.add('lastName='+dfc.Last_Name__c);
         lisstring.add('dfcId='+dfc.Id); 
        system.debug('MAPACTIONS@@'+mapActions);
       if(noActionsDfcIds.contains(dfc.Id)==false)
       { 
        lisstring.add('NoActions=NoActions');        
       }
       else
       {
     
        for(String s : standardActions)
        {

         if(mapActions.get(dfc.Id+'~'+s)!=null)
         { 
            lisstring.add(mapActionNames.get(s)+'='+mapActionNames.get(s));             
            
         }

       
        } 
       
      }             
      
     
     if(lisstring.size()>0 &&!Test.isRunningTest())
     {
     system.debug('map of user actions@@'+mapliststrings);
       mapliststrings.put(dfc.Id,lisstring);
       DF_Pure360_AutomatedListUpdate sendmail= new DF_Pure360_AutomatedListUpdate();
        sendmail.postRequest(mapliststrings); 
      }
     
     }
    
   }
   

 }
        
        global void finish(Database.BatchableContext BC)
        {
          // do something interesting
        }


}