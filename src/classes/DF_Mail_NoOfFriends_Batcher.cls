global class DF_Mail_NoOfFriends_Batcher implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Thank you email to active Champions for reaching 25, 50, 75, 100 and 
                then multiples of 50 number of Dementia Friends sent from RSO, approve first.  
                Separate email for 100 Friends that includes offering them a certificate if they want one.  
                Only send one email when Champion reaches a milestone, excluding 100 Friends email.  
***********************************************************************************************/
   public string query;
  
   public Id OW = Mail_Utils.getOrgWideEmail();
   public string templateName1{get;set;}
   public string templateName2{get;set;}
   
    global void execute( SchedulableContext SC )
    {
          // batch run 
      DF_Mail_NoOfFriends_Batcher o = new DF_Mail_NoOfFriends_Batcher();
      o.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
      o.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;
      database.executebatch(o,1);
      
     }

     global Database.QueryLocator start(Database.BatchableContext BC)
     {
          Id rt = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
          Date dt = Date.valueOf('2015-09-01') ;
           
            String query = 
                'Select Id, ' +
                'Portal_Contact__c,' +
                'Total_No_of_Friends_Created__c' +
                ' From ' +
                ' DF_Contact__c ' +
                ' Where RecordtypeId =: rt ' +
                ' and Status__c = \'' + DF_Utils.STATUS_CONVERTED +'\'' +             
                ' and Total_No_of_Friends_Created__c >= 25 ' +
                ' and  Id in ' +
                ' ( ' +
                ' select Session_Organiser__c  from DF_Event__c where Event_Status__c = \'' + DF_Utils.EVENT_STATUS_COMPLETED +'\'' +
                ' and Is_Last_Event__c = true '+
                ' and Event_Date__c >=: dt  '+
                ' )';
                
                
    
            system.debug('+++Query+++'+ query);

            return Database.getQueryLocator(query);
       }

    global void execute(Database.BatchableContext BC, List<SObject> scope){
       
       Map<String, EmailTemplate> mapTemp= Mail_Utils.getemailTemplateMap();
       templateName1= (mapTemp.get(templateName1 ).DeveloperName);  
       templateName2= (mapTemp.get(templateName2 ).DeveloperName);
       Map<string,Task> tskMap = new Map<string,Task>();
         
       List<DF_Contact__c> lisDFcon = new List <DF_Contact__c>();
       List<Messaging.SingleEmailMessage> lisEmails = new List<Messaging.SingleEmailMessage>();
                           
                  
       for ( sObject s : scope ){
       
           DF_Contact__c  c = (DF_Contact__c)s;
           lisDFcon.add(c);
       }
           
       if( lisDFcon.size()==0 ){ return; }
           
       tskMap=DF_Mail_Utils.getNextEmailCounterRequired(lisDFcon, Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF );
       system.debug('TASK MAP'+TSKMap);
           
       for ( DF_Contact__c con: lisDFcon) {
           
           
           Integer conTotal = integer.valueof(con.Total_No_of_Friends_Created__c);
           Decimal x = conTotal / 50;
           Long L = x.round();
           Integer i= integer.valueOf(x);
           
         if(! tskMap.isEmpty()) {
         
          
           if( conTotal >= 25 && conTotal <= 49  && tskMap.get(con.id+'~'+ Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF +'.'+ '25')==null){                 
                lisEmails.add(Mail_Utils.getTemplatedEmail(templateName1, con.Portal_Contact__c, con.id, OW, true, null));                                        
           }      
           
           if( conTotal >= 50 && conTotal <= 74 && tskMap.get(con.id+'~'+ Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF +'.'+ '50')==null){           
                lisEmails.add(Mail_Utils.getTemplatedEmail(templateName1, con.Portal_Contact__c, con.id, OW, true, null));     
           }

           if( conTotal >= 75 && conTotal <= 99 && tskMap.get(con.id+'~'+ Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF +'.'+ '75')==null){                  
                lisEmails.add(Mail_Utils.getTemplatedEmail(templateName1, con.Portal_Contact__c, con.id, OW, true, null));
           }

           if( conTotal >= 100 && tskMap.get(con.id+'~'+ Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF +'.'+ '100')==null){
                lisEmails.add(Mail_Utils.getTemplatedEmail(templateName2, con.Portal_Contact__c, con.id, OW, true, null));             
           } 
           
                     
           if(conTotal >= 150 && tskMap.get(con.id+'~'+ Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF +'.'+ i)==null && tskMap.get(con.id+'~'+ Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF +'.'+ '100')!=null) {
            
               Task tk = tskMap.get(con.id+'~'+ Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF +'.'+ '100');
               system.debug('task for 100 email'+tk);
                  
                   if( tk!=null ){ 
                   Integer friendsTotal= integer.valueOf(tk.Description.substringBetween('created','Dementia Friends').replaceAll( '\\s+', ''));
                   Decimal dNoOfFriends = friendsTotal/50;
                   Integer intNoOfFriends = integer.valueOf(DNoOfFriends);
                   
                      if (IntNoOfFriends != i ){ 
                
                        lisEmails.add(Mail_Utils.getTemplatedEmail(templateName1, con.Portal_Contact__c, con.id, OW, true, null)); 
                        
                        }

                    } 

            }
          
          } else {
        
             if( conTotal >= 25 && conTotal <= 49 ) {                 
                    lisEmails.add(Mail_Utils.getTemplatedEmail(templateName1, con.Portal_Contact__c, con.id, OW, true, null));                  
               }      
             
             if( conTotal >= 50 && conTotal <= 74 ){
                    lisEmails.add(Mail_Utils.getTemplatedEmail(templateName1, con.Portal_Contact__c, con.id, OW, true, null));     
               }
             
             if( conTotal >= 75 && conTotal <= 99 ) {                  
                    lisEmails.add(Mail_Utils.getTemplatedEmail(templateName1, con.Portal_Contact__c, con.id, OW, true, null));
               }
             
             if( conTotal >= 100 ) {             
               lisEmails.add(Mail_Utils.getTemplatedEmail(templateName2, con.Portal_Contact__c, con.id, OW, true, null));
               }
             
         }
          
       
       }
       
       if ( lisEmails.size() > 0 ) { Messaging.sendEmail(lisEmails); }
      
    
     }


      global void finish(Database.BatchableContext BC)
      {
          // do something interesting
      }
    }