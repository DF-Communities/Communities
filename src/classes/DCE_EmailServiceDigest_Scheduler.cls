public with sharing class DCE_EmailServiceDigest_Scheduler implements Schedulable{
    public void execute(SchedulableContext sc){
    	Database.executeBatch(new DCE_EmailServiceDigest_Batcher(), DCE_EmailServiceDigest_Batcher.EMAIL_BATCH_SIZE);
    }
}