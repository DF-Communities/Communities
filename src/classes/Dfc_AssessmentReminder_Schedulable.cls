global class Dfc_AssessmentReminder_Schedulable implements Schedulable, Database.AllowsCallouts{
    
    global void execute(SchedulableContext SC) {
       Dfc_AssessmentReminder_Batcher ass = new Dfc_AssessmentReminder_Batcher ();
       ass.execute();
    
    }
 
 }