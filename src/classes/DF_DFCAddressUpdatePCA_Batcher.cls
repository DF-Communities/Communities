/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Batch APEX Class to update postcode information on services records after a postcode is changed.
 *  Author  : Lakshmi Rajendram
 *  Date    : 20-09-2016
 *  Version : 0.1 Unit Test
 *
 *  Description:    Batch APEX Class to update postcode information on services records after a postcode is changed.
 *  Code to be executed in an anonymouse block    
 *                        String CRON_EXP = '0 0 21 * * ?';
 *                        DF_DFCAddressUpdatePCA_Batcher   apca = new DF_DFCAddressUpdatePCA_Batcher  ();
 *                        system.schedule('Batch job Schedule to run at 9pm', CRON_EXP, apca);                    
 *                                    
 *                  
 *  Modification History
 *  Date            Who         Description 
 *  
 *                          
*******************************************************************************************/


global class DF_DFCAddressUpdatePCA_Batcher  implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts, Schedulable 
{
 public string query;
   global void execute(SchedulableContext SC) 
   {
      DF_DFCAddressUpdatePCA_Batcher dfpca = new DF_DFCAddressUpdatePCA_Batcher();
      Database.executeBatch(dfpca,20);
   }
  
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
   
   List<DF_Contact__c> DFCIdList= [select id from DF_Contact__c where Address_Updated__c = true];
     
    query = 'select postcode__c,';
    query  = query  + 'Westminister_Constituency__c,CCG_Area_Name__c,Clinical_Commissioning_Group__c,';
    query  = query  + 'District_Name__c,Government_Office_Name__c,LSOA_Name__c,Lea_Name__c,Primary_Care_Trust__c,Strategic_Health_Authority__c,';
    query  = query  + 'CCG_Region_Name__c,Postcode_Ward__c,Country_Name__c,County_Name__c, Location__c,Address_Updated__c from DF_Contact__c where Id';
    query = query+ ' IN :DFCIdList';  
    System.debug('################query##############' + query  );
    
    return Database.getQueryLocator(query );
   }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope)
   {
   system.debug('execute');
   List<DF_Contact__c> liscon = new List<DF_Contact__c> ();
     for(sobject svc : scope){
     DF_Contact__c df = (DF_Contact__c)svc;
     liscon.add(df);
     }
     
     for(DF_Contact__c df :liscon){
         servicesPostcodeanywhereWrapper pcaW = new servicesPostcodeanywhereWrapper(df.postcode__c);   
         df.CCG_Area_Name__c =  pcaW.CCG_Area_Name;
         df.Clinical_Commissioning_Group__c= pcaW.Clinical_Commissioning_Group;
         df.CCG_Region_Name__c= pcaW.CCG_Region_Name;          
         df.Country_Name__c= pcaW.Country_Name;
         df.County_Name__c= pcaW.County_Name;
         df.District_Name__c= pcaW.District_Name;
         df.Government_Office_Name__c= pcaW.Government_Office_Name;
         df.LSOA_Name__c= pcaW.LSOA_Name;
         df.Lea_Name__c= pcaW.Lea_Name;
         df.Primary_Care_Trust__c =pcaW.Primary_Care_Trust;
         df.Strategic_Health_Authority__c=pcaW.Strategic_Health_Authority;
         df.Postcode_Ward__c= pcaW.Ward;
         df.Westminister_Constituency__c = pcaW.Constituency ;         
         df.Location__latitude__s=pcaW.Latitude;
         df.Location__longitude__s=pcaW.Longitude;
         df.Address_Updated__c = False;                      
         df.MSOA_Name__c = pcaw.MSOA_Name ;
        }
       update scope;
   }
   
   global void finish(Database.BatchableContext BC)
   {
   }

  

}