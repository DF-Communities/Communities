/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Processor for computing region Stats from DF_Champion records
 *  Author  : Gary Grant
 *  Date    : June 2015
 *  Version : 0.1 Unit Test
 *
 *  Description:    Batch update for linking DFCs to Regions
                    Only Champions that are converted, or Friends who were previously 
                    Champions and completed at least one session will have a Region Id
 *               
 *  Modification History
 *  Date            Who       Description 
 *  
*******************************************************************************************/

public without sharing class DF_RegionStats_Processor {

    private String RT_CHAMPION;
    private List<DF_Region_Statistics__c> upsStats;

    public DF_RegionStats_Processor() {

        RT_CHAMPION = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);        
        upsStats = new List<DF_Region_Statistics__c> ();

    }

    public void run() {

        List<DF_Region__c> lis = [select id, name from DF_Region__c];
        for (DF_Region__c region : lis) {

            processStats(region);

        }

        system.debug('Region Stats : Upserting Now');
        upsert upsStats;

    }

    public void doUpdate() {

        upsert upsStats;

    }


    public void processStats(DF_Region__c region) {

        
        date currentdate = date.today();
        

        /*
        Select Id, Name, Postcode__c, RecordType_Name__c, Status__c, Type_of_Champion__c FROM DF_Contact__c 
        where 
        (RecordTypeId = '012200000002TpG' and Status__c != 'Prospective') 
        OR 
        (RecordTypeId != '012200000002TpG' and Total_No_of_Completed_Info_Sessions__c >0)
        */


        // Select all Champions, and Friends that have previously been Champions and ran sessions. 
        List<aggregateResult> RegionAgg= [SELECT DF_Region__c
                                            ,COUNT(id)
                                            ,SUM(Registered_Events_Count__c) RegEvents
                                            ,SUM(Total_No_of_Friends_Created__c) TotFriends
                                            ,SUM(Total_No_of_Completed_Info_Sessions__c ) TotCompletedSessions
                                            ,SUM(Total_No_of_Available_Info_Sessions__c) TotAvailSessions
                                            ,SUM(Total_No_of_Cancelled_Info_Sessions__c) TotCancSessions
                                            ,SUM(Number_of_Public_Sessions_Run__c) TotPublicSessions
                                            ,SUM(Number_of_Private_Sessions_Run__c) TotPrivateSessions

                                            FROM DF_Contact__c 
                                            where (
                                            
                                                       ( RecordTypeId =: RT_CHAMPION and Status__c != 'Prospective' ) 
                                                    OR ( RecordTypeId !=: RT_CHAMPION  and Total_No_of_Completed_Info_Sessions__c > 0 )
                                            
                                                   )
                                            
                                            AND  DF_Region__c =: region.id
                                            GROUP BY DF_Region__c];
         
         List<DF_Region_Statistics__c>  existingStats = [select id,Date_Created__c
                                                         ,Total_Friends_Created__c
                                                         ,Total_Registered_Events__c
                                                         ,Total_Champions_Created__c
                                                         ,Total_Completed_Sessions__c
                                                         ,Total_Available_Sessions__c
                                                         ,Total_Cancelled_Sessions__c
                                                         ,Total_Public_Sessions__c
                                                         ,Total_Private_Sessions__c
                                                         from DF_Region_Statistics__c 
                                                         where Date_Created__c =: currentdate 
                                                         and DF_Region__c =: region.id] ;                                 
         
         DF_Region_Statistics__c dfs = new DF_Region_Statistics__c();
         
         // If not stats available, set 0 and return  
         IF (RegionAgg.size()==0){

            system.debug('Region Stats : no RegionAgg');

            dfs.Total_Friends_Created__c =0;
            dfs.Total_Champions_Created__c= 0 ;
            dfs.Total_Registered_Events__c =0 ;
            dfs.Total_Completed_Sessions__c = 0 ;
            dfs.Total_Available_Sessions__c= 0;
            dfs.Total_Cancelled_Sessions__c= 0 ;
            dfs.Total_Public_Sessions__c= 0 ;
            dfs.Total_Private_Sessions__c=0 ;
            dfs.Date_Created__c= System.today()  ;
            dfs.DF_Region__c= region.id;
           // insert dfs;
            upsStats.add(dfs);
            return;

         }    
           
         AggregateResult argRec = RegionAgg[0];
         
         IF ( existingStats.size() > 0 ) {
  
            system.debug('Region Stats : Existing Stat Found');

            DF_Region_Statistics__c stat = existingStats[0];

            stat.Total_Friends_Created__c =(Double)argRec.get('TotFriends') ;
            stat.Total_Champions_Created__c= (Double)argRec.get('expr0') ;
            stat.Total_Registered_Events__c = (Double)argRec.get('RegEvents') ;
            stat.Total_Completed_Sessions__c = (Double)argRec.get('TotCompletedSessions') ;
            stat.Total_Available_Sessions__c= (Double)argRec.get('TotAvailSessions') ;
            stat.Total_Cancelled_Sessions__c= (Double)argRec.get('TotCancSessions') ;
            stat.Total_Public_Sessions__c= (Double)argRec.get('TotPublicSessions') ;
            stat.Total_Private_Sessions__c= (Double)argRec.get('TotPrivateSessions') ;
            stat.Date_Created__c= System.today()  ;
            stat.DF_Region__c= region.id;

             upsStats.add(stat);
             return;

          }

         system.debug('Region Stats : Populating New Region Stat');

         dfs.Total_Friends_Created__c =(Double)argRec.get('TotFriends') ;
         dfs.Total_Champions_Created__c= (Double)argRec.get('expr0') ;
         dfs.Total_Registered_Events__c = (Double)argRec.get('RegEvents') ;
         dfs.Total_Completed_Sessions__c = (Double)argRec.get('TotCompletedSessions') ;
         dfs.Total_Available_Sessions__c= (Double)argRec.get('TotAvailSessions') ;
         dfs.Total_Cancelled_Sessions__c= (Double)argRec.get('TotCancSessions') ;
         dfs.Total_Public_Sessions__c= (Double)argRec.get('TotPublicSessions') ;
         dfs.Total_Private_Sessions__c= (Double)argRec.get('TotPrivateSessions') ;
         dfs.Date_Created__c= System.today()  ;
         dfs.DF_Region__c= region.id;
    
        //return zero, not null
        if (dfs.Total_Friends_Created__c==null){
            dfs.Total_Friends_Created__c=0;
            }
        
        
        if  (dfs.Total_Champions_Created__c==null){
             dfs.Total_Champions_Created__c=0;
            }

        if ( dfs.Total_Registered_Events__c==null){ 
             dfs.Total_Registered_Events__c=0;
            }
        

        if  (dfs.Total_Completed_Sessions__c ==null){
             dfs.Total_Completed_Sessions__c =0;
            }


        if  (dfs.Total_Available_Sessions__c==null){
            dfs.Total_Available_Sessions__c=0;
            }
        

        if  (dfs.Total_Cancelled_Sessions__c==null){
            dfs.Total_Cancelled_Sessions__c=0;
            }

        if  (dfs.Total_Public_Sessions__c==null){
             dfs.Total_Public_Sessions__c=0;
            }

        if  (dfs.Total_Private_Sessions__c==null){ 
             dfs.Total_Private_Sessions__c=0;
            }
                        
        upsStats.add(dfs);

    }

}