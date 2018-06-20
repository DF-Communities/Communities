global class Dfc_FetchDAAData_Schedulable implements Schedulable, Database.AllowsCallouts{
    
    global void execute(SchedulableContext SC) {
 
       Dfc_FetchDAAData_Processor.fetchData();
    
    }
 
 }