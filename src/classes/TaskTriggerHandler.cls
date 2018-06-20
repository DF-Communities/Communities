public with sharing class TaskTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the TaskTrigger.
 *  Author  : Lakshmi Rajendram
 *  Date    : 23-07-2015
 *  Version : 0.1 Unit Test
 *
 *  Modification History
 *  Date            Who         Description 
                      
*******************************************************************************************/

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
     
    public TaskTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(Task[] Tasks){
    
     for(Task newTask : Tasks){
     
     if (newTask.Description ==null){ break;}
     
     if(newTask.Description.contains('Email Id')==true){
      
       
        if(newTask.Description.substringAfterLast('Email Id:')!='TEREF16'){
            
          
            newTask.DFC_Email_Tracker__c =newTask.Description.substringAfterLast('Email Id:');
           
        }
        
        if( newTask.Description.contains('reaching 100 Dementia')==false && newTask.Description.substringBetween('creating ','Dementia Friends')!=null && newTask.Description.substringBetween('creating ','Dementia Friends')!=''){
        system.debug('++number of friends+++'+newTask.Description.substringBetween('creating','Dementia Friends'));
        integer i = integer.valueOf(newTask.Description.substringBetween('creating','Dementia Friends').replaceAll( '\\s+', ''));
           system.debug('++integer++'+i);    
        Decimal d = i/50;
        Long l = d.round();
        
              
         if(i > = 25 && i <= 49 ){
         newTask.DFC_Email_Tracker__c ='TEREF16'+'.'+'25';
         }
         if(i > = 50 && i <= 74 ){
         newTask.DFC_Email_Tracker__c ='TEREF16'+'.'+'50';
         }
         if(i > = 75 && i <= 99 ){
         newTask.DFC_Email_Tracker__c ='TEREF16'+'.'+'75';
         }
        /* if(i > = 100){
         newTask.DFC_Email_Tracker__c ='TEREF16'+'.'+'100';
         }*/
         if(i > = 150 ){
         newTask.DFC_Email_Tracker__c ='TEREF16'+'.'+l;
         }
        }
         
        if(newTask.Description.contains('reaching 100 Dementia')==true && newTask.Description.substringBetween('reaching','Dementia Friends')!=null){
        
           
        newTask.DFC_Email_Tracker__c ='TEREF16'+'.'+'100';
        
        }
        }
       }
      
      }
    }