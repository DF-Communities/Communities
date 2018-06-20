/***********************************************************************************************************
    *
    *   @author         :  gary.grant@conseq.co.uk  valerie.dunphy@conseq.co.uk
    *   @date           :  February 2016
    *   @description    :  A collection of generic static utility methods 
                           Cut down Version for DF Org  
        
    *  Modification History
    *  Date            Who                   Description 
    *  25-11-2014      Lakshmi Rajendram     included a new method to disable all triggers
       12-Jan-2015     Gary                  GetOptions, ListAsString           
    *  04/08/2015      Andy Rouse           Added GetRecordTypeIdsByDeveloperName(Schema.SObjectType token)
    ************************************************************************************************************/

public class CustomUtils {


    public CustomUtils() {
        
    }


 /*
      @description  Fetch an instance of an object where sField = sId,  with all available fields.
      @param        sId The id of the object to retrieve
      @param        sField The field that contains the related link id
      @param        oDescribe The DescribeSObjectResult for the relevant sObject Type (e.g. Schema.sObjectType.BDR__c)     
  */   
  public static sObject objectWithAllFields(String sField, String sId, Schema.DescribeSObjectResult oDescribe)
  {
        
     List<String> lisIds = new List<String>();
     lisIds.add(sId);
     List<sObject> lisReturn = objectListWithAllFields(sField, lisIds, oDescribe);
     return lisReturn.isEmpty() ? null : lisReturn[0];      
        
  } 
 
  public static Map<String, sObject> objectMapWithAllFields(String sField, List<String> sIds, Schema.DescribeSObjectResult oDescribe)
  {
    
     List<sObject> lisReturn = objectListWithAllFields(sField, sIds, oDescribe);
     system.debug ('Map of Object with all Fields - list count : ' + lisReturn.size());
     
     Map<String, sObject> mapReturn = new Map<String, sObject>();
     for (sObject o : lisReturn) {
        system.debug('Put Object with all fields in map with key : ' + (String)o.get(sField));
        mapReturn.put((String)o.get(sField), o);
     }
     
     return mapReturn;      
    
  }
  
  public static List<sObject> objectListWithAllFields(String sField, List<String> sIds, Schema.DescribeSObjectResult oDescribe)
  {
    
     //Put the field names into a List      
     Map<String, sObjectField> mapFields = oDescribe.fields.getMap();
     List<Schema.Sobjectfield> lisFields = mapFields.values();  
        
     // A string for the field names in the query   
     String sFields = '';   
 
     // Build the query string 
     String soql = 'select ';
     for(Schema.sObjectField f : lisFields ) {      
        if (sFields!='') { sFields = sFields + ','; }
        sFields = sFields + f.getDescribe().getName();      
     }

     soql = soql + sFields; 
     soql = soql + ' from ' + oDescribe.getName();
     soql = soql + ' where ' + sField + ' in: sIds';        
    
     system.debug('Object List with all Fields : ' + soql); 
    
     List<sObject> lis = new List<sObject>();       
     lis= Database.query(soql);      
     
     // Return the list of sObjects     
     return lis; 
        
  } 
  
  public static void saveWebError(String siteIdentifier, String errorMessage) {
      
      WEBError_Record__c errRec = new WEBError_Record__c(Site_Identifier__c = siteIdentifier,
                                                         Stacktrace__c = errorMessage);
      insert errRec;
      
  }


}