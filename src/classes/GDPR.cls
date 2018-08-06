public class GDPR {
	
    public class GdprException extends Exception{}
    
    public Boolean EmailOptIn;
    public Boolean PhoneOptIn;
    public Boolean SmsOptIn;
    public Boolean SocialOptIn;
    public Boolean PostOptOut;

    public GDPR(Boolean EmailOptIn, Boolean PhoneOptIn, Boolean SmsOptIn, Boolean SocialOptIn, Boolean PostOptOut) {
        
        this.EmailOptIn = (EmailOptIn==null) ? false : EmailOptIn;
        this.PhoneOptIn = (PhoneOptIn==null) ? false : PhoneOptIn;
        this.SmsOptIn = (SmsOptIn==null) ? false : SmsOptIn;
        this.SocialOptIn = (SocialOptIn==null) ? false : SocialOptIn;
        this.PostOptOut = (PostOptOut==null) ? false : PostOptOut;
        
    }
	
    /* This method is called on creation of a new contact in the before trigger */
    public static void createDefaultIndivRecord(List<Contact> contacts) {
    
        List<Individual> indivs = new List<Individual>();
        List<Contact> contsToAssignIndv = new List<Contact>();
        for(Contact thisCon : contacts) {
            if(thisCon.IndividualId == null) {
                Individual indv = new Individual(
                    FirstName = thisCon.FirstName,
                    LastName = thisCon.LastName,
                    DF_Contact__c = thisCon.DF_Contact__c,
                    DF_ContactExternalId__c = thisCon.DF_Contact__c
                );    
                indivs.add(indv);
                contsToAssignIndv.add(thisCon);
            } 
        }
        
        Database.SaveResult[] dsr = Database.insert(indivs, true);
        System.debug('Created default individual record: ' + indivs);
        // Now update the contact
        for(Integer i=0; i<contsToAssignIndv.size(); i++) {
            contsToAssignIndv[i].IndividualId = dsr[i].getId();
            System.debug('Set individual field on contact');
        }
    }
    
    public static GDPR getExistingDfContactPrefs(Id dfContactId) {
        
        Id indvId = [SELECT IndividualId FROM Contact WHERE DF_Contact__c = :dfContactId].IndividualId; // Could not get IndividualId from Virtual class
        
        Individual[] indv = [SELECT Id, Email_Optin__c, Phone_Optin__c, Sms_Optin__c, Social_Media_Optin__c, Post_Optout__c
                             FROM Individual
                             WHERE Id = :indvId];
        
        if(indv.size() != 1) {
            throw new GdprException('0 or multiple Indiviudal records were found for dfContact (' + dfContactId + '). ' + 
                                    'A contact should only have one Individual record in the current architecture. ' + 
                                    'Remove the superfluous record for this contact');
        }

        return new GDPR(indv[0].Email_Optin__c, indv[0].Phone_Optin__c, indv[0].Sms_Optin__c, indv[0].Social_Media_Optin__c, indv[0].Post_Optout__c);
        
    }
    
    public void populateIndvData(Contact contact) {
    
        Contact singleCont = [SELECT IndividualId, Firstname, Lastname FROM Contact WHERE Id = :contact.Id]; // Could not get IndividualId from Virtual class
        
        System.debug('Will be populating indv record with: ' + this);
        if(singleCont.IndividualId == null) {
            System.debug('No individual against singleCont ' + singleCont.Id + ' class');
            createFromForm(singleCont);
        } else {
            System.debug('Updating form in GDPR class');
            updateFromForm(singleCont.IndividualId);
        }  
    }
    
    public void populateIndvData(DF_Contact__c dfContact) {
    	System.debug('Updating GDPR prefs');
        Contact singleCont = [SELECT IndividualId FROM Contact WHERE DF_Contact__r.Id = :dfContact.Id]; // Could not get IndividualId from Virtual class
        
        System.debug('Will be populating indv record with: ' + this);
        if(singleCont.IndividualId == null) {
            createFromForm(singleCont);
        } else {
            updateFromForm(singleCont.IndividualId);
        }  
    }
    
    public void createFromForm(Contact contact) {
        System.debug('Creating GDPR prefs');
        Individual i = new Individual(
            Firstname = contact.Firstname,
            Lastname = contact.Lastname,
            Email_Optin__c = this.EmailOptIn,
            Phone_Optin__c = this.PhoneOptIn,
            Sms_Optin__c = this.SmsOptIn,
            Social_Media_Optin__c = this.SocialOptIn,
            Post_Optout__c = this.PostOptOut
        );
        
        Database.SaveResult dsr = Database.insert(i, true);
        if(dsr.isSuccess()) {
            Contact.IndividualId = dsr.getId();
            update Contact;
        }
    }
    
    /*
     Method used to update an existing Individual record
     Unless the preference has been updated from a page that allows it (e.g. ChampionEditMyDetails)
     only register true ('checked') items as a valid update. Any false values are considered as a nochange (null) value
    */
    public void updateFromForm(Id indvId) {
        
        Individual indv = [SELECT Id, Email_Optin__c, Phone_Optin__c, Sms_Optin__c, Social_Media_Optin__c, Post_Optout__c
                           FROM Individual
                           WHERE Id = :indvId];

        indv.Email_Optin__c = this.emailOptIn;
        indv.Phone_Optin__c = this.phoneOptIn;
        indv.Sms_Optin__c = this.smsOptIn;
        indv.Social_Media_Optin__c = this.socialOptIn;
        indv.Post_Optout__c = this.postOptOut;  
        update indv;
        
    }

}