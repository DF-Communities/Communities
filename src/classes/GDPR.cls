/*
Updates
June 2018 - Gary, Addition of Date and Source against each preference
*/


public class GDPR {
	
    public class GdprException extends Exception{}
    
    public Boolean emailOptIn;
    public Boolean phoneOptIn;
    public Boolean smsOptIn;
    public Boolean socialOptIn;
    public Boolean postOptOut;

    public String optInDataSource { get;set; } // the source of the set of updates.. Progress, MemoryWalk etc
    public boolean bAllFieldsConfirmed { get;set; }
    private Map<String, Boolean> mapValues;

    private void init(Boolean emailOptIn, Boolean phoneOptIn,
                     Boolean smsOptIn, Boolean socialOptIn,
                     Boolean postOptOut,
                     String source, Boolean bAllFieldsConfirmed) {

        this.emailOptIn = (emailOptIn==null) ? false : emailOptIn;
        this.phoneOptIn = (phoneOptIn==null) ? false : phoneOptIn;
        this.smsOptIn = (smsOptIn==null) ? false : smsOptIn;
        this.socialOptIn = (socialOptIn==null) ? false : socialOptIn;
        this.postOptOut = (postOptOut==null) ? false : postOptOut;

        this.optInDataSource = (source==null) ? 'DEMFRND_DB' : source;
        this.bAllFieldsConfirmed = bAllFieldsConfirmed;

        this.mapValues = new Map<String,Boolean>();
        mapValues.put('Email_Optin', this.emailOptIn);
        mapValues.put('Phone_Optin', this.phoneOptIn);
        mapValues.put('SMS_Optin', this.SmsOptIn);
        mapValues.put('Social_Media_Optin', this.socialOptIn);
        mapValues.put('Post_Optout', this.postOptOut);

        System.debug('MapValues = ' + mapValues);

    }

    // This new constructor extends the previous constructor
    public GDPR(Boolean emailOptIn, Boolean phoneOptIn,
                Boolean smsOptIn, Boolean socialOptIn,
                Boolean postOptOut,
                String source, Boolean bAllFieldsConfirmed) {

                init(emailOptIn, phoneOptIn,smsOptIn,socialOptIn,postOptOut,source,bAllFieldsConfirmed);

    }

    /* This constructor was in the orginal class and is called by all the existing code
       it sets defaults for the source and bConfirm all fields values on the extended constructor */
    public GDPR(Boolean emailOptIn, Boolean phoneOptIn,
                Boolean smsOptIn, Boolean socialOptIn,
                Boolean postOptOut) {

                init(emailOptIn, phoneOptIn,smsOptIn,socialOptIn,postOptOut,'DEMFRND_DB',true);

    }
	
    /* This method is called on creation of a new contact in the before trigger */
    public static void createDefaultIndivRecord(List<Contact> contacts) {
    
        List<Individual> indivs = new List<Individual>();
        List<Contact> contsToAssignIndv = new List<Contact>();

        for(Contact c : contacts) {
            if(c.IndividualId == null) {

                Individual indv = new Individual(

                    FirstName = c.FirstName,
                    LastName = c.LastName,
                    DF_Contact__c = c.DF_Contact__c

                );

                indivs.add(indv);
                contsToAssignIndv.add(c);

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

        /* In general, don't retrieve the Date and Source fields. If they are null values in the in-memory object they will be
           defaulted in the before trigger event
        */
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
    
        // Re-query to ensure the correct data is available    
        Contact c = [SELECT IndividualId, DF_Contact__c, Firstname, Lastname FROM Contact WHERE Id = :contact.Id]; // Could not get IndividualId from Virtual class
        System.debug('Updating form in GDPR class');
        doUpdate(c.IndividualId);

    }
    
    public void populateIndvData(DF_Contact__c dfContact) {
    	
        System.debug('Updating GDPR prefs');
        Contact c = [SELECT IndividualId, DF_Contact__c, FirstName, LastName FROM Contact WHERE DF_Contact__r.Id = :dfContact.Id]; // Could not get IndividualId from Virtual class
        doUpdate(c.IndividualId);
    }

    /*
     Method used to update an existing Individual record
     Unless the preference has been updated from a page that allows it (e.g. ChampionEditMyDetails)
     only register true ('checked') items as a valid update.
     Any false values are considered as a nochange (null) value

     This method is required in addition to the trigger so that dates can be recorded
     against all fields. The trigger alone would not be able to distinguish a process
     that allows a user to update all fields from a process that updates only an individual
     field. The assumpion being that if a user is shown all fields in the UI, even if they
     have not changed any values, they have confirmed the current status of all fields

    */
    private void doUpdate(Id indvId) {
        
        Individual indv = [SELECT Id,
                            Email_Optin__c, Phone_Optin__c, Sms_Optin__c, Social_Media_Optin__c, Post_Optout__c
                            FROM Individual
                            WHERE Id = :indvId];

        for ( String f : getFieldList() ) {

            String sFieldName = f + '__c';
            String sDateFieldName = f + '_Date__c';
            String sSourceFieldName = f + '_Source__c';

            if ( bAllFieldsConfirmed ) {

                indv.put(sDateFieldName, System.now() );
                indv.put(sSourceFieldName, this.optInDataSource);

            } else {

                if ( indv.get(sFieldName) != this.mapValues.get(f) ) {
                     indv.put(sDateFieldName, System.now());
                     indv.put(sSourceFieldName, this.optInDataSource);
                }

            }

            System.debug('Putting : ' + f + ' - ' + mapValues.get(f) );
            indv.put(sFieldName, mapValues.get(f));

        }

        update indv;
        
    }

    /* June 2018. Capture dates representing the date when an
       option was set. In almost all cases the dates and sources will be the same value.
       However, for flexibility, the fields are stored separately in case there is a process
       that updates one option, without updating the others
       To set individual fields, supply a value for fields

     */

    public static List<String> getFieldList() {

        List<String> vFields = new List<String>();
        vFields.add('Email_Optin');
        vFields.add('Phone_Optin');
        vFields.add('SMS_Optin');
        vFields.add('Social_Media_Optin');
        vFields.add('Post_Optout');

        return vFields;

    }


}