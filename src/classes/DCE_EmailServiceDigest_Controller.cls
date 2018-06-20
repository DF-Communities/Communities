/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : This class is used on a Visualforce email template which gets sent to DCE Users. It returns a table of services which need reviewing. The services are grouped by month of last reviewed date (hence the "amendMap")
 *            
 *  Author  : Andy Rouse
 *  Date    : 02-2016
 *  Version : 1.0
 *
 *  Description:
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public with sharing class DCE_EmailServiceDigest_Controller {
    public id recipientId{get; set;}
    
    private User u{
        get{
            if(u != null){ return u;}
            
            if(recipientId == null){return new User();}
            
            u = [select id, firstName, LastName, AccountId, ContactId, Contact.AccountId, Contact.Account.Name //Account.Name, 
                    from User
                    where id = :recipientId];
            
            return u;
        }
        set;
    }
    
    private list<DCE_ServiceAmend__c> allAmends{
        private get{
            if(allAmends != null){ return allAmends;}
            
            if(recipientId == null){return new list<DCE_ServiceAmend__c>();}
            
            allAmends = [select id, Name, ServiceOwner__c, DCEPartner__c, ServiceOwner__r.Name, LastReviewed__c, ServiceId__c,PortalServiceNumber__c 
                            from DCE_ServiceAmend__c 
                            where DCEPartner__c = :u.Contact.AccountId and service_status__c = 'Open' and (LastReviewed__c = null or (LastReviewed__c < LAST_N_MONTHS:9 and LastReviewed__c >= LAST_N_MONTHS:15))
                            order by LastReviewed__c asc nulls first];
            
            if(allAmends.size() == 0 ){allAmends = new list<DCE_ServiceAmend__c>();}
            
            return allAmends;
        } 
        
        private set;
        
    }
    
    /*Returns a map of services due review, keyed by the last reviewed month.*/
    public map<Date, list<amendWrapper>> amendMap{
        public get{
            if(amendMap != null){ return amendMap;}
            
            amendMap = new map<Date, list<amendWrapper>>();
            
            for(DCE_ServiceAmend__c amend : allAmends){
                
                date lastReviewed = date.newInstance(1900,1,1);
                
                if(amend.lastReviewed__c != null){
                    /*
                    DateTime lastReviewdt = datetime.newInstance(amend.lastReviewed__c.year(), amend.lastReviewed__c.month(),amend.lastReviewed__c.day());
                    lastReviewed = lastReviewdt.format('MMMMM yyyy');*/
                    lastReviewed = amend.lastReviewed__c.toStartOfMonth();
                }
                
                list<amendWrapper> monthAmends = new list<amendWrapper>();
                
                if(amendMap.containsKey(lastReviewed)){monthAmends = amendMap.get(lastReviewed);}
                
                monthAmends.add(new amendWrapper(amend));
                amendMap.put(lastReviewed, monthAmends);
                
            }
            
            return amendMap;
        }
        
        private set;
    }
    
    public list<Date> orderedDates{
        
        public get{
            if(orderedDates != null){ return orderedDates;}
            
            orderedDates = new list<Date>(amendMap.keySet());
            
            orderedDates.sort();
            
            return orderedDates;
        }
        
        private set;
    }
    
    public boolean getShowTable(){
        boolean showTable = false;
        
        if(amendMap.size() > 0){
            showTable = true;
        }
        
        return showTable;
    }
    
    public class amendWrapper{
        public DCE_ServiceAmend__c amend {get; set;}
        public string link {get; set;}
        
        public amendWrapper(DCE_ServiceAmend__c amend){
            this.amend = amend;
            
            this.link = Community_Settings__c.getInstance('DCE_Stub_Url').value__c+'ServiceView/'+amend.PortalServiceNumber__c;
        }
    }
}