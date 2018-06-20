global without sharing class CkePackRequestLinkBatcher implements Database.Batchable<SObject> {
	
	  global String query;
    private String progress_code {get;set;}
    private String progress_payment_code {get;set;}
    private String progress_donate_code {get;set;}

    private String status {get;set;}

    private Map<String, Set<CKE_Pack_Request__c>> mapCheck;

    global CkePackRequestLinkBatcher(String pack_code, String payment_code, String donate_code) {

        progress_code = pack_code;      
        progress_payment_code = payment_code;      
        progress_donate_code = donate_code;      
        status = 'Completed';

        query='select id, Email__c, Master_Pack_Request__c, CreatedDate, Status__c from CKE_Pack_Request__c where Master_Pack_Request__c = null and Progress_Form_Id__c =: progress_code';

        mapCheck = new Map<String, Set<CKE_Pack_Request__c>>();
    
    }

    global CkePackRequestLinkBatcher() {

        progress_code = Community_Settings__c.getInstance('CKE_Pack_Progress_Id').value__c;      
        progress_payment_code = Community_Settings__c.getInstance('CKE_Payment_Progress_Id').value__c;      
        progress_donate_code = Community_Settings__c.getInstance('CKE_Donate_Progress_Id').value__c;      
        status = 'Completed';

        query='select id, Email__c, Master_Pack_Request__c, CreatedDate, Status__c from CKE_Pack_Request__c where Master_Pack_Request__c = null and Progress_Form_Id__c =: progress_code';

        mapCheck = new Map<String, Set<CKE_Pack_Request__c>>();
    
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    private List<Cke_Pack_Request__c> getDuplicates(Set<String> emails) {

       // All the Pack Requests that have one of the email addresses in this batch, that are not already linked 
       List<Cke_Pack_Request__c> lis = [select id, Email__c, Master_Pack_Request__c, CreatedDate, Status__c from Cke_Pack_Request__c where Email__c in: emails and Master_Pack_Request__c = null and Progress_Form_Id__c =:progress_code ];
       return lis;

    } 

    private void populateMapCheck(List<sObject> scope) {

       for (sObject o : scope) {      
          
          CKE_Pack_Request__c pr = (CKE_Pack_Request__c)o;  
          
          Set<Cke_Pack_Request__c> stItems = mapCheck.get(pr.Email__c); 
          if ( stItems == null ) {

            stItems = new Set<CKE_Pack_Request__c>();

          }

          // Put the item in keyed on ID
          stItems.add(pr);

          // Put the map in keyed on Email Address
          mapCheck.put(pr.Email__c, stItems);

        }

    }

    // The earliest pack will be the Master
    private Cke_Pack_Request__c getEarliestPack(Set<Cke_Pack_Request__c> items) {

         Cke_Pack_Request__c earliestPack = null;

         // Get the earliest completed pack request by date
         for ( Cke_Pack_Request__c pr : items ) {

            if ( earliestPack == null && pr.Status__c == 'Completed' ) {

                 earliestPack = pr; 
    
            } else {

                if ( pr.Status__c == 'Completed' && pr.id != earliestPack.id && pr.CreatedDate < earliestPack.CreatedDate ) {

                    earliestPack = pr;

                }  

            }            
          
          }

          // No completed records found
          if ( earliestPack == null ) { 

            for ( Cke_Pack_Request__c pr : items ) {

              if ( earliestPack == null )  { earliestPack = pr; }

              if ( pr.id != earliestPack.id && pr.CreatedDate < earliestPack.CreatedDate ) {

                  earliestPack = pr;

              }  
          
            }

          }

          return earliestPack;

    }

    private List<Cke_Pack_Request__c> getPacksToUpdate(Set<Cke_Pack_Request__c> items) {

        List<Cke_Pack_Request__c> lis = new List<Cke_Pack_Request__c>();

        Cke_Pack_Request__c earliestPack = getEarliestPack(items);
        for (Cke_Pack_Request__c pr : items) {

          if ( pr.id != earliestPack.Id ) {

              pr.Master_Pack_Request__c = earliestPack.Id;
              lis.add(pr);

          }


        }

        return lis;

    }

    private void computeTotals(List<sObject> scope) { 

      List<Cke_Pack_Request__c> lisToUpdate = new List<Cke_Pack_Request__c>();

      List<Cke_Pack_Request__c> lis = [select id, Status__c, (select id, Status__c from Child_Requests__r) from cke_pack_Request__c where id in: scope];

      for ( Cke_Pack_Request__c pr : lis ) {

        if ( pr.Child_Requests__r.size() > 0 ) {

            Integer c = 1;
            Integer i = 0;
            for ( CKE_Pack_Request__c child : pr.Child_Requests__r ) {

                if ( child.Status__c == 'Completed' )  { c++; } else { i++; } 

            }

            pr.Summary_Completed_Count__c = c;
            pr.Summary_Incompleted_Count__c = i;

            lisToUpdate.add(pr);

        }

      }


      if ( lisToUpdate.size() >0 ) { update lisToUpdate; }

    }

    private void computeRevenue(List<sObject> scope) { 

      List<Cke_Pack_Request__c> lisToUpdate = new List<Cke_Pack_Request__c>();

      List<String> emails = new List<String>();
      for ( sObject o : scope ) {
        Cke_Pack_Request__c pr = (Cke_Pack_Request__c)o;
        emails.add(pr.Email__c);
      }

      List<String> codes = new List<String>();
      codes.add(progress_donate_code);
      codes.add(progress_payment_code);

      List<Cke_Payment__c> lis = [select id, Email__c, Type__c, Amount__c, Status__c from 
                                  Cke_Payment__c where 
                                  Email__c in: emails 
                                  and Status__c = 'Completed'
                                  and Progress_Form_Id__c in: codes];

      for ( sObject o : scope ) {

          Cke_Pack_Request__c pr = (Cke_Pack_Request__c)o;

          //Only compute totals for Master Pack Requests
          if ( pr.Master_Pack_Request__c == null ) {

            Decimal p = 0;
            Decimal d = 0;

            for ( CKE_Payment__c payment : lis ) {

              if ( payment.Email__c == pr.Email__c ) { 

                  if ( payment.Type__c == 'Pay-in' ) { p = p + payment.Amount__c; }
                  if ( payment.Type__c == 'Donation' ) { d = d + payment.Amount__c; }

              }

            }

            pr.Summary_Amount_Paid__c = p;
            pr.Summary_Amount_Donated__c = d;
            lisToUpdate.add(pr);

          }

      }

      if ( lisToUpdate.size() >0 ) { update lisToUpdate; }


    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

    	List<Cke_Pack_Request__c> lisToUpdate = new List<CKE_Pack_Request__c>();    

      populateMapCheck(scope);
      
      List<Cke_Pack_Request__c> duplicates = getDuplicates(mapCheck.keySet());
      populateMapCheck(duplicates);

      // Go thru all the maps and put the codes in the first one in the map
      for ( Set<Cke_Pack_Request__c> stItems : mapCheck.values() ) {

          List<Cke_Pack_Request__c> lis = getPacksToUpdate(stItems);
          if ( lis.size() >0 ) { lisToUpdate.addAll(lis); }

       }

       if ( lisToUpdate.size() > 0 ) { update lisToUpdate; }

       computeTotals(scope);
       computeRevenue(scope);

    }
    
    global void finish(Database.BatchableContext BC) {

        
    }
    

}