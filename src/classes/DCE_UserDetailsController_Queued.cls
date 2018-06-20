public without sharing class DCE_UserDetailsController_Queued implements queueable{
    Contact c;
    
    public DCE_UserDetailsController_Queued(Contact c){
    	this.c = c;
    }
    
    public void execute(QueueableContext context) {
		update c;
	}
    
}