public with sharing class DF_Mail_Utils {

public static final string DF_WELCOME_EMAIL='TEREF01';
public static final string DF_SUPERCHAMP_EMAIL='TEREF02';
public static final string DF_PROSNOTATTENDED_EMAIL='TEREF03';
public static final string DFC_ACTIVATE_CHAMP_ACCOUNT ='TEREF04';
public static final string DFC_ENTERED_CODE_NO_SESSION ='TEREF05';
public static final string DFC_ENTERED_CODE_NO_SESSIONS_TWO_MONTHS ='TEREF06';
public static final string DFC_NO_SESSIONS_IN_TWO_MONTHS ='TEREF07';
public static final string DFC_NO_OF_FRIENDS ='TEREF16';
public static final string DFC_CONGRATS_REACHING_X_DF ='TEREF16';
public static final string DFC_RUNNING_BIG_SESSION ='TEREF21';

public static final String VF_CHAMPION_WELCOME = 'DFCwelcomeemail';
public static final String VF_SUPER_CHAMPION = 'VFDFSuperChampionEmail';
public static final String VF_ACTIVATE_CHAMP = 'TEREF04activatechampacc';
public static final String VF_TRAINING_NOTATTENDED = 'DFCTrainingUpdate';
public static final String VF_WITHOUTSESSIONS1M = 'NeverRunSessions1M';
public static final String VF_WITHOUTSESSIONS2M = 'NeverRunSessions2M';
public static final String VF_WITHOUTSESSIONS3M = 'NeverRunSessions3M';
public static final String VF_WITHOUTSESSIONS4M ='NeverRunSessions4M';
public static final string VF_CHAMPS_NO_SESSIONS_IN_2_MONTHS = 'ChampsNoSessionsRunIn2M';
public static final string VF_CHAMPS_NO_SESSIONS_IN_4_MONTHS = 'ChampsNoSessionsRunIn4M';
public static final string VF_CHAMPS_NO_SESSIONS_IN_6_MONTHS = 'ChampsNoSessionsRunIn6M';
public static final string VF_CHAMPS_NO_SESSIONS_IN_8_MONTHS = 'ChampsNoSessionsRunIn8M';
public static final string VF_CHAMPS_NO_SESSIONS_IN_10_MONTHS = 'ChampsNoSessionsRunIn10M';
public static final string VF_CLOSE_SESSIONS_AFTER_14_DAYS = 'CloseSession14days';
public static final string VF_CLOSE_SESSIONS_AFTER_30_DAYS = 'CloseSession30days';
public static final string VF_CLOSE_SESSIONS_AFTER_45_DAYS = 'CloseSession45days';
public static final string VF_NO_OF_FRIENDS ='TEREF16Thankyouforreachingxnooffriends';
public static final string VF_NO_OF_FRIENDS_AND_CERT ='Thankyouforreachingxfriendsandcert';
public static final string VF_DF_SESSION_REMINDER='DFSessionReminder';
public static final string VF_DFC_COURSE_REMINDER='DFCTrainingCourseReminder';
public static final string VF_DFC_UNBOOK_TRAINING = 'DFCUnbookTrainingCourse';
public static final string VF_RUNNING_A_BIGSESSION = 'TEREF21_Thanks_For_Running_a_Big_Session';

public static boolean isDuplicateEmail(DF_Contact__c con, String emailid, List<Task> lisTasks ){
    
    integer i;
    Map<String, Task> dfTaskMap = new Map<String, Task>();
  
    for( Task ts: lisTasks ){
       String key= ts.whatid + '~' + ts.DFC_email_tracker__c ;       
       if ( ts.whatid == con.id ) { dfTaskMap.put (key,ts); }     
     }  
    
      return (searchTaskHistory( dfTaskMap, con.id, emailid) > 0);
        
 }


 public static Map<String, Task> getNextEmailCounterRequired(List<DF_Contact__c> con, String emailid ){
  
 List< String > s = new List< String >();
 Set<id> dfContactIdSet = new Set<id>();
 Map<String, Task> dfTaskMap = new Map<String, Task>();
  
 if (emailid==DFC_CONGRATS_REACHING_X_DF){
    system.debug('+emailid+'+emailid);
    
    for(DF_Contact__c c :con){
    
        dfContactIdSet.add(c.id);
    }
    
    List<Task> lisTask =[select whatid,id,DFC_email_tracker__c,Description from Task where DFC_email_tracker__c !=null and whatid in :dfContactIdSet];
    
  
    for ( Task ts: lisTask ){
        String key= ts.whatid + '~' + ts.DFC_email_tracker__c ;
       dfTaskMap.put (key,ts);
       }
     
      
   }
  
    
    return dfTaskMap;
    
 }


 public static Integer searchTaskHistory(Map <String,task> conTaskMap,Id conId,String emailid ){

    Integer i = 0;
   
  for (String key:conTaskMap.keyset()){
      
     
   
   //TEREF01   
    if(emailid == DF_WELCOME_EMAIL && key ==conid+'~'+ DF_WELCOME_EMAIL){
       
     system.debug('+enter emailid+'+DF_WELCOME_EMAIL);
     return i=1;
    
    }
    
    //TEREF02
    if(emailid == DF_SUPERCHAMP_EMAIL && key==conid+'~'+ DF_Mail_Utils.DF_SUPERCHAMP_EMAIL){    
    return i=2;
    
    }
    //TEREF03
    if(emailid == DF_PROSNOTATTENDED_EMAIL && key==conid+'~'+ DF_PROSNOTATTENDED_EMAIL){       
    return i=3;
    
    }
    //TEREF04
    if(emailid == DFC_ACTIVATE_CHAMP_ACCOUNT && key == conid+'~'+ DFC_ACTIVATE_CHAMP_ACCOUNT){
     
     system.debug('+enter emailid+'+DFC_ACTIVATE_CHAMP_ACCOUNT);
     return i=4;
    }
    
    //TEREF05
    if(emailid == DFC_ENTERED_CODE_NO_SESSION && key==conid+'~'+ DFC_ENTERED_CODE_NO_SESSION){    
     return i=5;
    
    }
   
   }
    
    return i;
    
 }
 
 public static void processEmail( String tempName, Id targetobid ,Id WId ,String OrgWE){
  
      system.debug('**********enter process email***');       

      String templateName= tempName;
      Id targetobjectid = targetobid;
      Id WhatId = WId ;  
      String OrgWideEmail =OrgWE;
      Mail_Utils.sendTemplatedEmail(templateName, targetobjectid,WhatId,OrgWideEmail,true,null);
                   
 }
 
  
 
 }