public without sharing class CkeFAQsController extends EdtPageController {

    public List<FAQ_Category__c> faqCategories {
        get {
            if (faqCategories == null) {
                faqCategories = new List<FAQ_Category__c>();
            }

            return faqCategories;
        }
        private set;
    }

    public List<FAQ__c> faqs {
        get {
            if (faqs == null) {
                faqs = new List<FAQ__c>();
            }

            return faqs;
        }
        private set;
    }

    public Map<Id,List<FAQ__c>> mapFaqs {
        get {
            if (mapFaqs == null) {
                mapFaqs = new Map<Id,List<FAQ__c>>();
            }

            return mapFaqs;
        }
        private set;
    }

    public CkeFAQsController() {


       
        faqs = [SELECT Answer__c,Category__c,Id,Name,Question__c,Rank__c FROM FAQ__c ORDER BY Category__c, Rank__c];

        Set<Id> usedCats = new Set<Id>();

        for (FAQ__c faq : faqs)
            usedCats.add(faq.Category__c);

        faqCategories = [SELECT Id,Name,Name__c,Rank__c FROM FAQ_Category__c WHERE Id IN :usedCats and website__c ='Cupcake' ORDER BY Rank__c];

        Id currentCatId = null;
        Id newCatId = null;
        List <FAQ__c> newFaqs = new List<FAQ__c>();

        for (FAQ__c faq : faqs) {
            newCatId = faq.Category__c;
            System.debug('*** CkeFAQsController  - newCatId : ' + newCatId);
            if (currentCatId == null)
                currentCatId = newCatId;

            if (newCatId != currentCatId) {
                mapFaqs.put(currentCatId, newFaqs);
                System.debug('*** CkeFAQsController  Added ' + newFaqs.size() + ' to ' + currentCatId);
                currentCatId = newCatId;
                newFaqs = new List<FAQ__c>();
            }
            newFaqs.add(faq);
        }
        // Don't forget the add the last one
        System.debug('*** CkeFAQsController  Added ' + newFaqs.size() + ' to ' + newCatId);
        
        mapFaqs.put(newCatId, newFaqs);
    }
}