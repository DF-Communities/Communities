global without sharing class DF_WEBC_ManagePartnerAdmins_Ctr extends DF_WEBC_ControllerBase {
  
  public final String ID_PARAM = 'Id';
  public boolean hasActions {get; set;} 
  public static Id partnerId{get; set;} 
  public List<AdminWrapper> AdminsWrappersList {get;set;} 
  public string email { get;set;}
  public string name { get;set;} 
  public string nameError { get;set;}  
  
     
  @RemoteAction
  global static Holder handleinvites(String email,string orgId) {
  
  	boolean isError;
    Holder holder = new Holder();
    holder.isInvite = false; 
    holder.isUser = false; 
    holder.emailError='' ;
   //validate email address     
    if(email==null || email.length() <=0){ 
    
    holder.emailError = 'Please enter email.';
    isError =true;
    }
            
    if( email.length()>0 && !DFP_Utils.validEmail(email)){
    
    holder.emailError = 'Enter valid email.';
    isError =true;
    }        
    
    if( email.length()>0 && DFP_Utils.isExistingAdmin(email,orgId)){ 
    holder.emailError = 'Existing admin.';
    isError =true;
   }
   if(email.length()>0 && DFP_Utils.validEmail(email) &&! DFP_Utils.isExistingAdmin(email,orgId)){
   	holder.emailError='';
  List<User> lisUser = [select id from User where UserName = :email];
      
   if(lisUser.isEmpty()){
   	
   	 holder.isInvite = true;  
   }else {
   	
   	 holder.isUser = true;   
   
   }
   }
   return holder;

  } 
  
  global class Holder  
  {    
  //data holder for remote action	   
       public String emailError = '';
       public Boolean isInvite ;
       public Boolean isUser ;
  }
  
 

 public List<AdminWrapper> getAdminList() {
 //wrapper list to display existing admins on org 
  if (AdminsWrappersList == null){
       AdminsWrappersList  = new List<AdminWrapper>();

  for (PO_Administrator__c admin : [select Status__c,Invited_Email__c, Invited_Name__c,DF_Contact__r.Name__c,DF_Contact__r.First_Name__c,DF_Contact__r.Last_Name__c,DF_Contact__r.Email__c,Partner_Organisation__c from PO_Administrator__c
      
      where Partner_Organisation__c=:ApexPages.currentPage().getParameters().get(ID_PARAM) and Status__c in('Registered','Invited') order by createddate desc]){

            AdminsWrappersList.add(new AdminWrapper(admin));
       }
   } 
   return  AdminsWrappersList ;
}


    
public Pagereference SaveAdmin() {
//remove admins
  List<PO_Administrator__c> adminsSelected = new List<PO_Administrator__c>();
  List<PO_Administrator__c> adminsToUpdate = new List<PO_Administrator__c>();        
  List<PO_Administrator__c> adminsToInsert = new List<PO_Administrator__c>(); 
        
  for (AdminWrapper a: getAdminList() )  {

          if (a.updatedAdmin == True){

              if (a.admin.id != null){
              adminsSelected.add(a.admin);}
             }
      }
                
    for(PO_Administrator__c ad : adminsSelected){
              ad.Status__c = 'Inactive';
              adminsToUpdate.add(ad);
     }
        system.debug ('adminsSelected.size()@@@ '+ adminsSelected.size());
      // disable removing all admins linked with the org  
      if((getAdminList().size()-adminsSelected.size())<1){  
      
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot remove all administrators.');
       ApexPages.addMessage(myMsg );return null;
      }
      else{
       update adminsToUpdate;
       AdminsWrappersList=null; 
      }
       

       
       
       return null;
   }


  public DF_WEBC_ManagePartnerAdmins_Ctr(){
  //constructor
   partnerId = ApexPages.currentPage().getParameters().get(ID_PARAM);
   hasActions = DFP_Utils.hasActions(partnerId);
 
  }
  
 
 
 
 public pageReference  addAdmin(){
 //get the user that the email address linked with   
 List<User> lisUsers =[select id from User where UserName = :email]; 
    
 if(lisUsers.size()>0 && email.length()>0 )   {
     system.debug('lisUser@@@@@@@@@@ ' + lisUsers);
    //add admin to wrapper list
     AdminsWrappersList.add(new AdminWrapper(DFP_Utils.addAdministrator(partnerid,df_utils.getDFContactForUser(lisUsers[0].Id).Id)));
 }
     //refresh wrapperlist/existing admins list 
     getAdminList();
     return new PageReference('/manage-partner-admins?Id='+partnerId);
     
 }
 
 public pageReference invite(){
 
   if(name.length()>0 && email.length()>0){ 
   	 //add invite to wrapper list
 	AdminsWrappersList.add(new AdminWrapper(DFP_Utils.inviteAdministrator(partnerid,email,name)));
   }
   //refresh wrapperlist/existing admins list
   getAdminList();
   
   return new PageReference('/manage-partner-admins?Id='+partnerId);
 }
 
 public pageReference cancel(){
    
    return new PageReference('/manage-partner-admins?Id='+partnerId);
 }
 
 
 public class AdminWrapper

  {
     public PO_Administrator__c admin {get; private set;}
     public Boolean UpdatedAdmin {get; set;}
    
     public AdminWrapper(PO_Administrator__c a){
     UpdatedAdmin = false;
     admin = a;
     }

  }
  
}