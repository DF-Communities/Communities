public without sharing class DFC_RegisterCommunityController{

public static Dfc_CommunityContext context {get;set;}

public string ID_Param {get;set;}
public static string communitystatus {get;set;}


  public DFC_RegisterCommunityController(){
   ID_Param= ApexPages.currentPage().getParameters().get('dfcid');

 }

public  Object getdata() {

       if(communitystatus==null){return null;}
           
          return Dfc_Util.getResourcesForState(communitystatus);
       
 }

@RemoteAction
  public static Dfc_CommunityContext dfcDraftContext( string communityId){
   
   return Dfc_Util.getDraftContext(readCommunity(communityId));
  }

  public static DFC_Community__c readCommunity(string communityId){
    return Dfc_Util.readCommunity(communityId);
  }

  @RemoteAction
  public static DFC_Community__c[] getCommunitiesForDaa (String daaId){
    return Dfc_Util.getCommunitiesForDaa (daaId);
  }

   @RemoteAction
  public static object saveCommunity (Community comm,string communityId){
        return updateCommunity(comm,communityId);
  }
  @RemoteAction
  public static void validateCommunity (string communityId){
   Dfc_Util.validateCommunity(readCommunity(communityId));
  
  }
  private static object updateCommunity (Community comm,string communityId){
    DFC_Community__c com = readCommunity(communityId);
     
     system.debug('remote object@'+comm);
     com.country__c = comm.country;
     com.Central_Location__c=comm.centralLocation;
     com.Why_No_Central_Location__c=comm.noLocation;
     com.Region__c = comm.region ;
     com.DA_Alliance__c= comm.Daa;
     com.Duplicate_Confirmation__c= (comm.Daa==null?false:comm.Duplicate) ;
     com.Name__c = comm.name;
     com.County__c =comm.county;
     com.Location__c = comm.location;
     com.Population__c = comm.population;
     com.Location_Type__c = comm.ltype;
     com.Status__c = comm.status;
     //DateTime dt = DateTime.parse(comm.datesubmitted);
     com.Date_Submitted__c = comm.datesubmitted;
     if(comm.actionAreas!=null){
      updateActionAreas(comm.actionAreas);
     }
     update com;
     return new Community();

  }
  private static void updateActionAreas(List<DFC_Community_Action_Area__c> actionAreas){
    for(DFC_Community_Action_Area__c action:actionAreas){
      if(action.Selected__c == false && action.Description__c!=null){
        action.Description__c='';
        update actionAreas;
      }
     update actionAreas;
      }
    
  }
  
  public class Community{

   public string country {get;set;}
   public string centralLocation {get;set;}
   public string noLocation {get;set;}
   public string region {get;set;}
   public string Daa {get;set;}
   public Boolean Duplicate {get;set;}
   public string name {get;set;}
   public string county {get;set;}
   public string location{get;set;}
   public decimal population{get;set;}
   public string ltype {get;set;}
   public List<DFC_Community_Action_Area__c> actionAreas {get;set;}
   public DateTime datesubmitted {get;set;}
   public string status {get;set;}

  }
  //rep
  @RemoteAction
 public static List<Reps> existingReps(string communityId) {
 List<Reps> lisreps = new List<Reps>();

  for( DFC_Community_Representative__c  rp :[ SELECT Id,Invited_Name__c,Invited_Email__c,Role__c,DF_Contact__r.Id,DF_Contact__r.Portal_User__c,DF_Contact__r.Name,DF_Contact__r.Email__c FROM DFC_Community_Representative__c 
            
            WHERE  
            Community__r.Id = :communityId
            
            And
            (
            Role__c = 'Registered' OR Role__c = 'Invited'
            ) 
           ])  {
          Reps r = new Reps();
          r.Name = (rp.DF_Contact__r.Name!=null ?rp.DF_Contact__r.Name:rp.Invited_Name__c);
          r.Email = (rp.DF_Contact__r.Email__c!=null ?rp.DF_Contact__r.Email__c:rp.Invited_Email__c);
          r.Role =rp.Role__c;
          r.Id = rp.Id;
          r.Dfc =(rp.DF_Contact__r!=null? rp.DF_Contact__r.Id:null);
          lisreps.add(r);
      }
     return lisreps;
   }

public class Reps{
 public string Name;
 public string Email;
 public string Role;
 public string Id;
 public string Dfc;
}
@RemoteAction
  public static Holder handleinvites(String email,string communityId) {
  
    boolean isError;
    Holder holder = new Holder();
    holder.isInvite = false; 
    holder.emailError='' ;
    holder.existingRep =false;
   //validate email address     
    if(email==null || email.length() <=0){ 
    
    holder.emailError = 'Please enter email.';
    isError =true;
    }
            
    if( email.length()>0 && !validEmail(email)){
    
    holder.emailError = 'Enter valid email.';
    isError =true;
    }        
    
    if( email.length()>0 && Dfc_Util.existingRepresentative(communityId,email)){ 
    holder.existingRep =true;
    holder.emailError = 'The Email address '+email+' is already a confirmed or invited representative for this community';
    isError =true;
   }

    if(email!=null && email.length()>0 && validEmail(email)&& !Dfc_Util.existingRepresentative(communityId,email)){
    
    holder.emailError = '';
    isError =false;
    }        
    
   
   return holder;

  } 

  public class Holder  
  {    
  //data holder for remote action    
       public String emailError = '';
       public Boolean isInvite ;
       public Boolean existingRep;
  }
  
  
  public static Boolean validEmail(String email) {
    

  String InputString = email;
  String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
  Pattern MyPattern = Pattern.compile(emailRegex);

// Then instantiate a new Matcher object "emailMatcher"
   Matcher emailMatcher = MyPattern.matcher(InputString);

  if (!emailMatcher.matches()) {
     return FALSE;
   }
   else {
    return TRUE;
   }
  
}
@RemoteAction
  public static object handleReps(string communityId,String email) {
   
   
   List<User> lisUser = [select id from User where UserName = :email];
    
  if(validEmail(email)==false) {
    return 'Please enter valid email address';
  }
  else{

   if(lisUser.isEmpty() && Dfc_Util.existingRepresentative(communityId,email)==false){
     return 'invite';
   }
   else if(Dfc_Util.existingRepresentative(communityId,email)){

    return 'The Email address '+email+' is already a confirmed or invited representative for this community';

   }

   else{
    return addRepresentative(communityId,email);
    
   }
  }

 }

public static DFC_Community_Representative__c addRepresentative (String communityId, String email){
 DFC_Community_Representative__c  rep = Dfc_Util.addRepresentative(communityId, email);
return rep;
}

@RemoteAction
public static DFC_Community_Representative__c inviteRepresentative (String communityId, String email, String name){
 DFC_Community_Representative__c  rep = Dfc_Util.inviteRepresentative(communityId, email,name);
return rep;
}

@RemoteAction
public static void deleteRepresentative (String communityId, String id){
 Dfc_Util.deleteRepresentative(communityId, id);
}



}