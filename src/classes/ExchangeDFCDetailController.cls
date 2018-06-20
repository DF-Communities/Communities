public without sharing class ExchangeDFCDetailController{

    
    @AuraEnabled
    public static DF_Contact__c getDFCDetails(string uId) {
        User u = new User();
        u = [select contactId from User where Id =: uId];
         system.debug('returned dfc'+ [Select Id,name from DF_Contact__c WHERE Portal_Contact__c=:u.contactId][0]);
        
        DF_Contact__c dfc = new DF_Contact__c();
        dfc = [Select About_me__c,Champion_exchange_access__c,Date_of_Champion_Training__c,Title__c,city__c,Why_do_you_want_to_become_a_Champion__c,First_Name__c,name__c,name,recordtype_name__c,County__c,Total_No_of_Friends_Created__c,Total_No_of_Completed_Info_Sessions__c,interests__c,Other_interests__c from DF_Contact__c WHERE Portal_Contact__c=:u.contactId][0];
        return dfc;
  
    }
     @AuraEnabled
    public static List<String> getpickval() {
        List<String> options = new List<String>();

        Schema.DescribeFieldResult fieldResult = DF_Contact__c.Interests__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
    
     @AuraEnabled 
     public static DF_Contact__c saveDFC(DF_Contact__c dfcon){
        update dfcon;
        return dfcon;
    }  
    
     @AuraEnabled
    public static String getCurrentUser() {
      string toReturn;  
        if(UserInfo.getUserType()!='Guest'){
      toReturn =UserInfo.getUserId();
        system.debug('returned user'+toReturn);
        }
      return toReturn.substring(0, 15);
   }
    
      @AuraEnabled
    public static String getCurrentUserName() {
      string toReturn;  
        if(UserInfo.getUserType()!='Guest'){
      toReturn =UserInfo.getFirstName();
        system.debug('returned user'+toReturn);
        }
      return toReturn;
   }
    
     @AuraEnabled
    public static User getUserProfile(String uid) {
      User toReturn = new User();  
       
      toReturn =[SELECT Id,email,name FROM User WHERE Id = :uid  LIMIT 1][0];
        system.debug('returned user'+toReturn);
        
      return toReturn;
   }
    
    
    
   
    @AuraEnabled 
     public static DF_Contact__c cancelSave(DF_Contact__c dfcon){
      DF_Contact__c dfc = new DF_Contact__c();
      dfc = [Select Date_of_Champion_Training__c,Title__c,city__c,Why_do_you_want_to_become_a_Champion__c,First_Name__c,name__c,name,recordtype_name__c,County__c,Total_No_of_Friends_Created__c,Total_No_of_Completed_Info_Sessions__c,interests__c,Other_interests__c from DF_Contact__c WHERE Id=:dfcon.Id ];
      return dfc; 
     }

}