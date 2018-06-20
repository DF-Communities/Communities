/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBBadgeOrder.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class that looks after the WEBBadgeOrder VF Page.
 *               
 *  Modification History
 *  Date            Who         Description 
 *                    
*******************************************************************************************/
public without sharing class WEBBadgeOrder extends DF_WEBC_ControllerBase {

    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public final String STANDARD_ERROR_MSG = 'Please correct the mistakes highlighted below';

    public String lastName {get; set;}
    public String firstName {get; set;}
    public String addressStreet {get; set;}
    public String addressStreet2 {get; set;}
    public String addressCity {get; set;}
    public String addressCounty {get; set;}
    public String addressPostcode {get; set;}
    public String standardErrorMsg {get; set;}
    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}
    public DF_Contact__c loggedInContact {get; set;}
    public List<BadgeClaimWrapper> badgeClaims {get; set;}
    public Badge_Claim__c badgeClaim {get; set;}
    public boolean isChampion {get; set;}
    public boolean isConverted {get; set;}
    public boolean isChampionConverted {get; set;}
    public String bingoSheets {get; set;}
    public String brokenSentences {get; set;}
    public Boolean actionCards {get; set;}

    public Page_Snippet__c totalFriendsSnippet {
        get {
            if (totalFriendsSnippet == null){
                totalFriendsSnippet = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'DementiaFriendsTotalSnippet' LIMIT 1];
            }
            return totalFriendsSnippet;
        }
        set ;
    }
    
    //Constructor
    public WEBBadgeOrder(){
        if (WEBController.isLoggedIn){
            isChampion = WEBController.isChampion;
            isConverted = WEBController.isChampionConverted;            
            isChampionConverted = WEBController.isChampionConverted;  
            
            
            badgeClaims = new List<BadgeClaimWrapper>();
            badgeClaim = new Badge_Claim__c();
            //actionCards=false;
            User loggedInUser = [select u.Id, u.ContactId from User u where u.Id = :UserInfo.getUserId()];
            loggedInContact = [Select d.Street__c, d.Status__c, d.Postcode__c, d.Portal_Contact__c, d.Name__c, d.Name, d.Last_Name__c, d.First_Name__c, d.Email__c, d.County__c, d.Country__c, 
                                d.Contact_Number__c, d.City__c From DF_Contact__c d where d.Portal_Contact__c = :loggedInUser.ContactId LIMIT 1];
                                
            lastName = loggedInContact.Last_Name__c;
            firstName = loggedInContact.First_Name__c;
            addressStreet = loggedInContact.Street__c;
            addressCity = loggedInContact.City__c;
            addressCounty = loggedInContact.County__c;
            addressPostcode = loggedInContact.Postcode__c;
            
            for (Badge_Claim__c bc : [Select b.CreatedDate, b.Town_City__c, b.Street__c, b.Street_2__c, b.Postcode__c, b.Id, b.DF_Contact__c, b.County__c, b.Country__c, b.Contact_Ext_Id__c, b.Badge_Claimed__c, 
                                        b.BC_Ext_Id__c, b.DF_Contact__r.First_Name__c, b.DF_Contact__r.Last_Name__c,b.Bingo_sheets__c,b.Broken_sentences_handouts__c,b.Badges_Action_cards__c From Badge_Claim__c b where b.DF_Contact__c = :loggedInContact.Id]){
                                            
                                            badgeClaims.add(new BadgeClaimWrapper(bc));
                                                                                        
                                        }
            }
    }

    //Change-01312 05/2017
     public List<selectoption> getMaterialsAmounts()
    {           
        list<selectoption> options = new list<selectoption>();
        options.add(new selectoption('','--Select quantity--'));            
        try 
        {               
                  
        Schema.DescribeFieldResult fieldResult = Badge_Claim__c.Bingo_sheets__c.getDescribe();

        list<schema.picklistentry> values = fieldResult.getPickListValues();               
        for (Schema.PicklistEntry a : values) 
        {     
                 
        options.add(new SelectOption(a.value,a.label));
        }
       
       
                   
        }  
        catch (Exception e) 
        {             
        ApexPages.addMessages(e);           
        }
        system.debug('Badge_Claim__c.Bingo_sheets__c Options'+ options);          
        return options; 
    }

    
    //Submit Badge Claim
    public PageReference submitBadgeClaim(){
       
            boolean saveContact = false;
            badgeClaim.DF_Contact__c = loggedInContact.Id;
            if (loggedInContact.First_Name__c != firstName){
                loggedInContact.First_Name__c = firstName;
                saveContact = true;
            }
            if (loggedInContact.Last_Name__c != lastName){
                loggedInContact.Last_Name__c = lastName;
                saveContact = true;
            }
            //2014-08-06 : CSL : Client wants to concatenate Street & Street 2 into the Street field on the Badge Order
            badgeClaim.Street__c = addressStreet + ', ' + addressStreet2;
            //badgeClaim.Street_2__c = addressStreet2;
            badgeClaim.Town_City__c = addressCity;
            badgeClaim.County__c = addressCounty;
            badgeClaim.Postcode__c = addressPostcode;
            badgeClaim.Bingo_sheets__c = bingoSheets!=null?bingoSheets:null;
            badgeClaim.Broken_sentences_handouts__c = brokenSentences!=null?brokenSentences:null;
            badgeClaim.Badges_Action_cards__c = actionCards ;

            if (saveContact){
                update loggedInContact;
            }           
            
            insert badgeClaim;
            
            PageReference pr = Page.WEBBadgeOrderThankyou;
            pr.setRedirect(true);
            //google tracking QP-10
            pr.getParameters().put('badges_ordered','true');
            return pr;
            
            
        
    }
    
    //Wrapper class to help with Badge Claim processing
    public class BadgeClaimWrapper {
        public Badge_Claim__c theClaim {get; set;}
        public String claimName {get; set;}
        public String claimAddress {get; set;}
        public String claimDate {get; set;}
        public String monthLabel {get; set;}
        public String claimOrder {get; set;}

        public BadgeClaimWrapper(Badge_Claim__c bc){
            this.theClaim = bc;
            this.claimName = bc.DF_Contact__r.First_Name__c.substring(0,1) + ' ' + bc.DF_Contact__r.Last_Name__c;   
            this.claimAddress = bc.Street__c + ', ' + (bc.Street_2__c != null ? bc.Street_2__c + ', ' : ' ') + bc.Town_City__c + ', ' + bc.County__c + ', ' + bc.Postcode__c;
            this.claimOrder=((bc.Bingo_sheets__c ==null && bc.Broken_sentences_handouts__c==null && bc.Badges_Action_cards__c==false)? '50 Badges & Action cards':'')+ (bc.Bingo_sheets__c !=null?bc.Bingo_sheets__c+' Bingo sheet handout' +'\n':'')+(bc.Broken_sentences_handouts__c!=null?bc.Broken_sentences_handouts__c+' Broken sentences handouts'+'\n':'') +(bc.Badges_Action_cards__c==true? '50 Badges & Action cards':'');

            if (bc.CreatedDate.month() == 1) monthLabel = 'January';
            if (bc.CreatedDate.month() == 2) monthLabel = 'February';
            if (bc.CreatedDate.month() == 3) monthLabel = 'March';
            if (bc.CreatedDate.month() == 4) monthLabel = 'April';
            if (bc.CreatedDate.month() == 5) monthLabel = 'May';
            if (bc.CreatedDate.month() == 6) monthLabel = 'June';
            if (bc.CreatedDate.month() == 7) monthLabel = 'July';
            if (bc.CreatedDate.month() == 8) monthLabel = 'August';
            if (bc.CreatedDate.month() == 9) monthLabel = 'September';
            if (bc.CreatedDate.month() == 10) monthLabel = 'October';
            if (bc.CreatedDate.month() == 11) monthLabel = 'November';
            if (bc.CreatedDate.month() == 12) monthLabel = 'December';
            
            this.claimDate = monthLabel + ' ' + bc.CreatedDate.day() + ', ' + bc.CreatedDate.year();    
            
        }
    }

}