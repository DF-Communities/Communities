/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX class for the WEBFriendConvertToChampion VF Page
 *            
 *  Author  : Lakshmi Vasudevan
 *  Date    : 22-04-2016
 *  Version : 1.0
 *
 *  Description:    WEBFriendConvertToChampion class holds methods and properties used in the
 *                  WEBFriendConvertToChampion VF Page   
 *               
 *  Modification History
 *  Date            Who         Description 
 *           
*/
public without sharing class WEBFriendConvertToChampion extends DF_WEBC_ControllerBase {
  
  public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
  public String standardErrorMsg {get;set;}  
  public String birthDateError {get; set;}
  public String birthDateString {get;set;}
  public String whychampion {get;set;}
  public String whychampionError {get;set;}
  public Boolean isError = FALSE;
  public DF_Contact__c dfContactRecord {get; set;}

    public User thisUser {
        get {
            return WEBController.thisUser;
        }
        set;
    }
    
  
  public WEBFriendConvertToChampion(){
  	
  	standardErrorMsg = '';
    birthDateError = '';
    whychampionError ='';

   dfContactRecord =  [Select d.Contact_Number__c, d.Code_Verefied__c, d.Email__c, d.Title__c, d.Newsletters__c, d.Street__c, d.Portal_Contact__c, d.Last_Name__c, d.First_Name__c, d.County__c, d.City__c, d.Postcode__c, d.Country__c, d.BirthDate__c, Gender__c, Ethnic_Group__c From DF_Contact__c d where d.Portal_Contact__c = :thisUser.ContactId LIMIT 1];
   currentDfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());
   
   if ( dfContactRecord.BirthDate__c != null ) {
            DateTime dt = dfContactRecord.birthDate__c;
            birthDateString = dt.format('dd/MM/yyyy');
    }         
    system.debug('birthdate string '+birthDateString);     
            
}

@TestVisible  private Date getDate(String sDateString) {
        
        
        try { 
            String[] parts = sDateString.split('/');
            Date dt = null;
            dt = Date.newInstance(Integer.valueOf(parts[2]),Integer.valueOf(parts[1]),Integer.valueOf(parts[0]));       
            return dt;
            
        } catch (Exception x) {
            
            return null; 
            
        }
    
    }
  
   public PageReference convertToChampion(){
   	
    standardErrorMsg = '';	
    isError = false;
    birthDateError='';
    if ( whychampion == null || whychampion.length() == 0 ) {
      whychampionError = EMPTY_FIELD_VALUE_MSG;
      isError=TRUE;
    }
    if ( birthDateString == null || birthDateString.length() == 0 ) {
        
            birthDateError = EMPTY_FIELD_VALUE_MSG;
            isError=TRUE;
        
        } else {

            Date dt = getDate(birthDateString);
            system.debug('Edit Champion Details : bdy ' + birthDateString);
            system.debug('Edit Champion Details : bdy ' + dt.format());

            if ( dt == null ) {
                
                birthDateError = 'Birth Date is invalid format (DD/MM/YYY)';
                isError = TRUE;
            
            } else { 
                    
                Date dtNow = Date.Today();      
                Integer m = dt.monthsBetween(dtNow);
                system.debug('Update Champion : Months ' + m);
                
                if ( m < 192 ) {
                    
                    birthDateError = DF_Utils.AGE_MSG;
                    isError=TRUE;
                }
                
                if ( m == 192 && dt.day() > dtNow.Day()) {
                    
                    birthDateError = DF_Utils.AGE_MSG;
                    isError=TRUE;
                    
                }
                
            }
            
        }  

        
        if (isError){
            return null;
        }
        
     
                
                dfContactRecord.BirthDate__c = getDate(birthDateString);
                Date dt = getDate(birthDateString);
                dfContactRecord.BirthDate__c = dt;
                dfContactRecord.Status__c = ( dfContactRecord.Code_Verefied__c ? DF_Utils.STATUS_CONVERTED : DF_Utils.STATUS_PROSPECTIVE );
                dfContactRecord.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
                dfContactRecord.Why_do_you_want_to_become_a_Champion__c = whychampion;
                update dfContactRecord;
       
       PageReference pr = Page.WEBChampion;
            pr.getParameters().put('nr','true');
            return pr;
            
       
    
    }
  

  
}