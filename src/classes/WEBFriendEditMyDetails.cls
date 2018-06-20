/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBFriendEditMyDetails.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBFriendEditMyDetails page.
 *                  This controller will look after editing and viewing profile information 
 *                  from the DF_Contact__c record
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class WEBFriendEditMyDetails extends DF_WEBC_ControllerBase {
    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public final String EMAIL_FOUND_MSG = 'The email address you have entered already exists. If you own this email address please contact the Dementia Friends team on 0207 264 2662.';
    public static final String RT_CONTACT_CHAMPION = 'Dementia_Friend_Champion';
    public static final String RT_DFCONTACT_FRIEND = 'Dementia_Friend';
        
    public Boolean emailOptIn{get;set;}
    public Boolean telephoneOptIn{get;set;}
    public Boolean textMessageOptIn{get;set;}
    public Boolean socialMediaOptIn{get;set;}
    public Boolean postOptOut{get;set;}
    
    public String standardErrorMsg {get;set;}
    public String emailError {get; set;}
    public String firstNameError {get; set;}
    public String lastNameError {get; set;}
    public String phoneError {get; set;}
    public String title{get;set;}
    public String titleOther{get;set;}
    
    public String birthDateError {get; set;}
    public String birthDateString {get;set;}
    public String pOption1 =  'Family or Friend';
    public String pOption2 =  'Past Family or Friend';
    public String pOption3 =  'Past Carer';
    public String pOption4 =  'Person with dementia';
    public String pOption5 =  'Interested In Dementia';
    public String pOption6 =  'Carer';
    public String pOption7 =  'Dementia Professional';
    public String pValue1 =  'I am a family member or friend of someone with dementia';
    public String pValue2 =  'I was a family member or friend of someone who had dementia';
    public String pValue3 =  'I used to be a carer of someone with dementia';
    public String pValue4 =  'I have dementia';
    public String pValue5 =  'I am generally interested in dementia';
    public String pValue6 =  'I am a carer of someone with dementia';
    public String pValue7 =  'I am a dementia professional';
    public Map<String,String> opValueMap = new Map<String,String> 
    {pOption1 => pValue1, pOption2 => pValue2,pOption3 => pValue3,pOption4 => pValue4,pOption5 => pValue5,pOption6 => pValue6,pOption7 => pValue7};
    
    public list<string> proximity  {get;set;}
    public List<string> proximityOptions = new List<string>{pOption1,pOption2,pOption3,pOption4,pOption5,pOption6,pOption7};
    public String proximityString='' ;
    public Boolean isError = FALSE;
    public Boolean showChangeDetailsPrompt {get; set;}
    
    public List<SelectOption> titleList {
        get {
            if (titleList == null){
                titleList = new List<SelectOption>();
                titleList.add(new SelectOption('-None-','-None-'));
                titleList.add(new SelectOption('Mr.','Mr.'));
                titleList.add(new SelectOption('Mrs.','Mrs.'));
                titleList.add(new SelectOption('Miss.','Miss.'));
                titleList.add(new SelectOption('Ms.','Ms.'));
                titleList.add(new SelectOption('Other','Other'));           
            }
            return titleList;
        }
        set;
    }
    
    
    
    public List<SelectOption> genderOptionList {
        
        get { return DF_Utils.genderOptions; }
        set;        
    }


  public List<SelectOption> getProxmityOptions() {

      List<SelectOption> options = new List<SelectOption>();
          
      Schema.DescribeFieldResult fieldResult = Demographic_Information__c.Proximity_to_dementia__c.getDescribe();

      list<schema.picklistentry> values = fieldResult.getPickListValues();               
        
      for (Schema.PicklistEntry a : values) {     
        for(string s :opValueMap.keyset()){
       if(a.getValue() == s){             
        options.add(new SelectOption(a.getlabel(),opValueMap.get(s)));
        }
       
      }
    }
       
     return options;
       
    }
        

    

    public Page_Snippet__c totalFriendsSnippet {
        get {
            if (totalFriendsSnippet == null){
                totalFriendsSnippet = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'DementiaFriendsTotalSnippet' LIMIT 1];
            }
            return totalFriendsSnippet;
        }
        set ;
    }
    
    public List<DF_Contact_Inbound_Change__c> contactDetailsChanged {
        get {
            if (contactDetailsChanged == null){
                contactDetailsChanged = new List<DF_Contact_Inbound_Change__c>();
            }
            return contactDetailsChanged;
        }
        set;
    }

    public DF_Contact__c dfContactRecord {get; set;}

    public User thisUser {
        get {
            //if (thisUser == null)
            //  thisUser = WEBController.thisUser;
            //return thisUser;
            return WEBController.thisUser;
        }
        set;
    }

    public WEBFriendEditMyDetails() {
        if (test.isRunningTest()){
        
            Contact c = new Contact();
            c.firstname = 'Test';
            c.LastName = 'TestContact';
            c.Email = 'test.testcontact@myemail.com';
            c.Salutation='Mr';
            insert c;
            dfContactRecord = new DF_Contact__c();
            dfContactRecord.RecordTypeId = [select r.Id from RecordType r where r.DeveloperName = :RT_DFCONTACT_FRIEND and r.SObjectType = 'DF_Contact__c' LIMIT 1].Id;
            dfContactRecord.First_Name__c = 'Test';
            dfContactRecord.Last_Name__c = 'Contact';
            dfContactRecord.portal_contact__c=c.id;
            dfContactRecord.BirthDate__c = Date.valueOf('2013-05-05');
            dfContactRecord.Email__c = 'test.contact@myemail.com';
            dfContactRecord.Last_Name__c = 'Contact';
            dfContactRecord.Street__c = '4 SWtuart';
            dfContactRecord.City__c = 'London';
            dfContactRecord.County__c = 'London';
            dfContactRecord.Postcode__c = 'EC3 2AW';
            GDPR gdprSettings = new GDPR(false,false,false,false,false);
            GDPR.createDefaultIndivRecord(new List<Contact>{c});
            
        }else {
            dfContactRecord =  [Select d.Email__c, d.Title__c,d.BirthDate__c ,d.Newsletters__c, d.Street__c, d.Portal_Contact__c, d.Last_Name__c, d.First_Name__c, d.County__c, d.City__c, d.Postcode__c, d.Contact_Number__c, d.Country__c, d.Gender__c, d.Ethnic_Group__c  From DF_Contact__c d where d.Portal_Contact__c = :thisUser.ContactId LIMIT 1];
       		
            GDPR gdprSettings = GDPR.getExistingDfContactPrefs(currentDfc.Id);
            emailOptIn = gdprSettings.EmailOptIn;
            telephoneOptIn = gdprSettings.PhoneOptIn;
            textMessageOptIn = gdprSettings.SmsOptIn;
            socialMediaOptIn = gdprSettings.SocialOptIn;
            postOptOut = gdprSettings.PostOptOut;
        }
        
        standardErrorMsg = '';
        emailError = '';
        firstNameError = '';
        lastNameError = '';
        phoneError = '';
        birthDateError = '';
        
        contactDetailsChanged = [select id from DF_Contact_Inbound_Change__c where Related_DF_Contact__c=:currentdfc.id];
         if(contactDetailsChanged.size()>0 ){
            
            showChangeDetailsPrompt = true;
        }
        boolean bIsOtherTitleVaue = true;
        
         if ( dfContactRecord.BirthDate__c != null ) {
            DateTime dt = dfContactRecord.birthDate__c;
            birthDateString = dt.format('dd/MM/yyyy');
        }
    
        for ( SelectOption option : titleList ) {
            if ( dfContactRecord.Title__c == option.getValue()) {
                bIsOtherTitleVaue = false;
            }           
        }
        title = ( bIsOtherTitleVaue ? 'Other' : dfContactRecord.Title__c);
        titleOther = ( bIsOtherTitleVaue ? dfContactRecord.Title__c : '');
        proximity = new List<string>();
        
        for (string s :proximityOptions){
         
         if(clientDgData==null){return;}
          
         if( clientDgData.proximity_to_dementia__c!=null && clientDgData.proximity_to_dementia__c.contains(s)){
          proximity.add(s);
          }
        }
    }
    
    @Future
    //This needs to be a future call as you can't mix DML statements on setup objects & non setup objects
    public static void updateUserRecord(String userId, String emailAddress, String firstName, String lastName){
        try {
            User u = [select u.Email, u.UserName, u.CommunityNickname, u.Firstname, u.Lastname from User u where u.Id = :userId LIMIT 1];
            u.Firstname = firstName;
            u.Lastname = lastName;
            u.Email = emailAddress;
            u.CommunityNickname = emailAddress;
            u.UserName = emailAddress;
            
            update u;
        }catch (DMLException dmlEx){
            system.debug('*** -- Error saving user : ' + dmlEx + ' -- ***');
        }
    }
    
    public PageReference saveUserDetails(){
        standardErrorMsg = '';
        emailError = '';
        firstNameError = '';
        lastNameError = '';
        phoneError = '';
        birthDateError = '';
        isError = false;
        
        
        
        //if (this.dfContactRecord.Email__c.length() == 0){
        //  emailError = EMPTY_FIELD_VALUE_MSG;
        //  isError = TRUE;
        //}

        if (this.dfContactRecord.First_Name__c.length() == 0) {
            firstNameError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }

        if (this.dfContactRecord.Last_Name__c.length() == 0) {
            lastNameError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }
         if (this.dfContactRecord.Contact_Number__c == null || this.dfContactRecord.Contact_Number__c.length() == 0){
            phoneError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        } else {
        
        
         if(!WEBC_CommunityWrapper.isPhoneOK(this.dfContactRecord.Contact_Number__c)){
         
            phoneError = 'Please enter telephone number in correct format';
            isError = TRUE;
         }
        
        }
        
        if ( birthDateString == null || birthDateString.length() == 0 ) {
        
         //  birthDateError = EMPTY_FIELD_VALUE_MSG;
          // isError=False;
        
        } else {
         // if ( birthDateString != null || birthDateString.length() > 0 ) {
        

            Date dt = date.parse(birthDateString);
            system.debug('Edit Friend Details : bdy ' + birthDateString);
            system.debug('Edit Friend Details : bdy ' + dt.format());

            if ( dt == null ) {
                
                birthDateError = 'Birth Date is invalid format (DD/MM/YYY)';
                isError = TRUE;
            
            }
            if ( dt > date.today() ) {
                
                birthDateError = 'Birth Date cannot be in the future';
                isError = TRUE;
            
            }
            
            } 
        
        List<DF_Contact__c> dfContactCheckList = new List<DF_Contact__c>();
        dfContactCheckList = [select d.Id, d.Email__c from DF_Contact__c d where d.Email__c = :this.DFContactRecord.Email__c];
        
        for (DF_Contact__c dfc : dfContactCheckList){
            if (dfc.Id != this.dfContactRecord.Id){
                isError = TRUE;
                emailError = EMAIL_FOUND_MSG;
            }
        }
        
        if (isError){
            return null;
        }
        
          //**************DG data upsert************************//
         Demographic_Information__c dg = clientDgData;
         
         
        
         for(string s:proximity ){
             if(s != null){   
                 proximityString = proximityString +';'+ s;
             }
         }
        
         if(dg!=null ){ 
         
                     
           if(proximityString != null || proximityString != ''){
             
              dg.Proximity_to_dementia__c = proximityString;
                
           }
          upsert dg; 
         }
         
         
         
         system.debug('upsert dg  '+dg);
         
         //**************DG data upsert end************************//

         //**************Individual update start************************//
        
        GDPR gdprInst = new GDPR(emailOptIn, telephoneOptIn, textMessageOptIn, socialMediaOptIn, postOptOut);
        gdprInst.populateIndvData(dfContactRecord);
         //**************Individual update end************************//
        
         try {
            if (dfContactRecord != null) {
        
                dfContactRecord.Title__c = (title=='Other' ? titleOther : title);
                
               
                if ( birthDateString == null || birthDateString.length() == 0 ) {
                dfContactRecord.BirthDate__c = null;
               
                } else{
                
                Date dt1 = date.parse(birthDateString);
                dfContactRecord.BirthDate__c = date.parse(birthDateString);
                dfContactRecord.BirthDate__c = dt1;
                }
                
                if (test.isRunningTest()){
                    insert dfContactRecord;
                }else {
                    update dfContactRecord;
                }
                
                //Check to see if core data has been changed and if so, update the user record
                if (thisUser.Email != dfContactRecord.Email__c ||
                    thisUser.Firstname != dfContactRecord.First_Name__c ||
                    thisUser.Lastname != dfContactRecord.Last_Name__c){
                        system.debug('*** -- About to call the user save future method -- ***');
                        updateUserRecord(thisUser.Id, dfContactRecord.Email__c, dfContactRecord.First_Name__c, dfContactRecord.Last_Name__c);                       
                    }
                }
                
                
               

        } catch (Exception e) {
            standardErrorMsg = e.getMessage();
        }
        
        PageReference pageRef = Page.WEBFriend;
        pageRef.getParameters().put('ds','true');
        //return Page.WEBChampion;
        return pageRef;
    }
    
    /*March 2016*/
    
    
    
    public Demographic_Information__c clientDgData {

      get { return dgDataMap.get(dfContactRecord.portal_contact__c); }

      set;
    }
    
     public Map<String, Demographic_Information__c> dgDataMap {

    get{

      if (dgDataMap != null) { return dgDataMap; }

      
      initDgDataMap();      
      return dgDataMap;

    } 
    
    set;

  }

  private void initDgDataMap() {

      Map<String, Demographic_Information__c> dgMap = new Map<String, Demographic_Information__c>();
      List<Demographic_Information__c> lis = [  select id, Ethnic_Group__c,Ethnic_Group_Other__c,Contact__c,Proximity_to_dementia__c
                                                from Demographic_Information__c 
                                                where   Contact__c =: dfContactRecord.portal_contact__c                                               
                                                limit 1 ];
     
      System.debug(' Controller DGData SOQL: ' + lis);                                         

      for ( Demographic_Information__c dgData : lis ) {

       

        if ( dfContactRecord.portal_contact__c !=null && dfContactRecord.portal_contact__c == dgData.Contact__c ) {
             System.debug('getting Client dgData');                                                  
             dgMap.put(dfContactRecord.portal_contact__c, dgData);
        }

       

      }                                          
       if ( dgMap.get(dfContactRecord.portal_contact__c) == null ) {
           dgMap.put(dfContactRecord.portal_contact__c, getNewDgData(dfContactRecord.portal_contact__c));
      }
      
      this.dgDataMap = dgMap;

  }

  private Demographic_Information__c getNewDgData (id contact) {
  
    List <contact> c = [select ownerid from contact where id =:contact limit 1];
    if(contact == null) { return null; }
  
    System.debug(' Creating New DG Data');

    Demographic_Information__c dgData = new Demographic_Information__c();
    dgData.Contact__c = contact;
    dgData.OwnerId = c[0].ownerid;
             
   
    // Don't insert here. A subsequent update will fail. 
    return dgData;

  }
    
    
    
    
    
    
    
   /* //////////////////////////////////////*/
    
    /*
    public PageReference saveUserDetails () {
        standardErrorMsg = '';
        firstNameError = '';
        lastNameError = '';

        if (this.thisUser.firstName.length() == 0) {
            firstNameError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }

        if (this.thisUser.lastName.length() == 0) {
            lastNameError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }

        if (isError)
            return null;
        
        // Update the Contact Record
        List<Contact> contacts = [SELECT Id, firstName, lastName, Newsletters__c FROM Contact WHERE Id = :thisUser.ContactId LIMIT 1];

        Contact c = null;

        if (contacts.size() > 0)
            c = contacts[0];

        try {
            if (c!=null) {
                
                c.firstName=this.thisUser.firstName;
                c.lastName=this.thisUser.lastName;

                update c;
            }

            update thisUser;

        } catch (Exception e) {
            standardErrorMsg = e.getMessage();
        }
        
        return Page.WEBFriend;
    }
*/
    
}