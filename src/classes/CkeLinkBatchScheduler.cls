global with sharing class CkeLinkBatchScheduler implements Schedulable{
   
   global void execute(SchedulableContext SC) {

      //CkePaymentLinkBatcher a = new CkePaymentLinkBatcher();       
      //database.executebatch(a, 50);
      
      CkePackRequestLinkBatcher b = new CkePackRequestLinkBatcher();       
      database.executebatch(b, 50);

	  //CkePaymentRequestLinkBatcher c = new CkePaymentRequestLinkBatcher();       
      //database.executebatch(c, 50);

	}

}