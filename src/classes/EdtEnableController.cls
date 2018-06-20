public class EdtEnableController 
{
    public final static String ENABLING_PERMISSION_SET = 'Cke_Administrators';
    
    public Boolean getEditEnabled()
    {
       PermissionSetAssignment[] ass = [ SELECT Id FROM PermissionSetAssignment where Assignee.Id = :UserInfo.getUserId() and PermissionSet.Name = :ENABLING_PERMISSION_SET ];
       return !ass.isEmpty();
    }
    
     
    
}