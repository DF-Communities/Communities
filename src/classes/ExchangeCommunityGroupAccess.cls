public class ExchangeCommunityGroupAccess implements Queueable {
	public Set<Id> updatedUserIds;
	public String groupId;

	public void execute(QueueableContext context) {
        //Do some action here
         List<CollaborationGroupMember> lisGroupMembers = new List<CollaborationGroupMember>();
        for(User u:[select id from user where Id in:updatedUserIds])
        {
            CollaborationGroupMember gm = new CollaborationGroupMember();
            gm.CollaborationGroupId = groupId;
            gm.MemberId = u.Id;
            lisGroupMembers.add(gm);
        }

        if(lisGroupMembers.size()>0){
            list<database.saveResult> insertResults = database.insert(lisGroupMembers, false);
        }
        
	}

	public ExchangeCommunityGroupAccess(Set<Id> records,String gId)
    {
        
    	this.updatedUserIds =records;
    	this.groupId = gId ;

       
    }
}