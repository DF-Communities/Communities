global class ExchangeGroupAccess_Batcher implements Database.Batchable<sObject>,Schedulable {
    
    String query;
    
    global ExchangeGroupAccess_Batcher() {
        
    }
     global void execute( SchedulableContext SC )
    {
          // batch run 
      ExchangeGroupAccess_Batcher batch = new ExchangeGroupAccess_Batcher();
       database.executebatch(batch,4);
      
     }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        string communityName = Community_Settings__c.getInstance('Exchange_Site').value__c;
        Id communityId = DF_Utils.getCommunityId(communityName);
           
          query = 
                'select id,'+
                'CollaborationGroupId,requesterid, ' +
                'status from  '+
                 'CollaborationGroupMemberRequest '+
                 'where status =\'pending\' '+
                 ' and CollaborationGroupId in '+
                 '('+
                 'select id from CollaborationGroup '+
                 'where networkid=: communityId' +

                 ')';
           system.debug('+++Query+++'+ query);

           return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        List<CollaborationGroupMemberRequest> memberReqlis =new List <CollaborationGroupMemberRequest>();
        
          for ( sObject s : scope ) {
            CollaborationGroupMemberRequest  cgm = (CollaborationGroupMemberRequest)s;       
            cgm.status = 'Accepted';    
            memberReqlis.add(cgm);          
          }
    
        if(memberReqlis.size()>0){
          update memberReqlis;
         }

    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}