/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX Handler for JSON data Friend Registration
 *  Author  : Gary Grant
 *  Date    : 17/11/2015
 *  Version : 1.0
 *
 *  Description:    Handler for DF Friend Registration.
                    registration process
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
global without sharing class DF_WEBC_RegisterFriend_Handler extends DF_WEBC_RegisterBase_Handler {


  public DF_WEBC_RegisterFriend_Handler(String sJson) {
    
    init(sJson);

  }

  protected override boolean isExtendedRegistrationDataOK() {

    return true;

  }


  /* Extend these Methods for different classes of Friend */

  @TestVisible
  protected override String getPureEmailTemplateName() {

   if(dfc.Created_As_Type__c== 'Friend'){
      return DF_Pure360_Email_Handler.MESSAGE_VERIFY_STANDARD;
    }
    else{
      return DF_Pure360_Email_Handler.MESSAGE_VERIFY_DIGITAL;       
    }

  }

  // Don't include the Community Prefix in the name  
  protected override String getEmailTemplateName() {

    return 'Verification_Request';

  }


  protected override  String getRecordTypeName() { 

    return DF_Utils.RT_FRIEND;

  }

  protected override String getCreatedAsValue() {

    return 'Friend';

  }

  protected override String getStartUrl() {
    
    //google tracking QP-1
    string var ='';
    if(dfc.Created_As_Type__c== 'Friend'){
       var ='?df_nondigital_verified=true';
       return WEBC_CommunityWrapper.COMMUNITY_USER_HOME + var;

       }

      else{
        //google tracking QP-0
       var ='?df_digital_verified=true';
       return WEBC_CommunityWrapper.CREATE_ACTIONS + var ;
       
      }
      

  }


  protected override void populateExtendedData() {

     dfc.BirthDate__c = getDate(data.birthDate); 
     if ( data.footballTeam == 'NULL' || data.footballTeam == null) {
         dfc.Football_Team__c = null;} 
       else {
         dfc.Football_Team__c = data.footballTeam;
     }

  }

  protected override void doPostRegistration() {

        system.debug('WEBC_RegisterFriend_Loggin : Handle Pack Request ' + data.packRequest);

        if ( data.packRequest!=null && data.packRequest ) {
             String packStatus = handlePackRequest(dfc);
        }

   }

   /* Create a new pack request if one does not already exist */
   private static String handlePackRequest(DF_Contact__c dfc) {
        
      /* TODO !!! Only two packs can be sent to each address - need some firm rules for that */
      
      system.debug('WEBC_RegisterFriend_Loggin : Handle Pack Request');
      DF_Pack_Request__c dfpr = null;
              
      List<DF_Pack_Request__c> lis = [select id, DF_Contact__c, Status__c,City__c,Street__c,PostCode__c,County__c,Country__c from DF_Pack_Request__c where DF_Contact__c = :dfc.id LIMIT 1];
      
      if ( lis.isEmpty() ) {
        
          system.debug('WEBC_RegisterFriend_Loggin : creating pack request');

          dfpr = new DF_Pack_Request__c();
          dfpr.Status__c= 'New';
          dfpr.DF_Contact__c = dfc.id;
          dfpr.City__c = dfc.City__c;
          dfpr.Street__c = dfc.Street__c;
          dfpr.PostCode__c = dfc.PostCode__c;
          dfpr.County__c = dfc.County__c;
          dfpr.Country__c = dfc.Country__c;
          
          insert dfpr;        
      
      }  else {        
      
          dfpr = lis[0]; 

      }          

      return dfpr.Status__c;
        
    }


}