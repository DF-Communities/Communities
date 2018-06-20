public without sharing class DCE_newUserRegister_Queuable implements Queueable {
    
	private string userId;
	
	public DCE_newUserRegister_Queuable(string userId){
		this.userId = userId;
	}
	
	public void execute(QueueableContext qc) {
		
		if(userId==null){ return; }
		
		list<PermissionSet> DCESet = [select id, Name from PermissionSet where Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME limit 1];
	    		
		PermissionSetAssignment DCEPSA = new PermissionSetAssignment(AssigneeId=userId, PermissionSetId=DCESet[0].id);
		insert DCEPSA;
	}
    	
}