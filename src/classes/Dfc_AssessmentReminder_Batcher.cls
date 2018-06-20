/************************************************************************************************
     * @author          Gary
     * @date            18-2-16
     * @description     Batch send Dementia Friendly Community Annual Assessment assessment email reminders
***********************************************************************************************/

public without sharing class Dfc_AssessmentReminder_Batcher { 

     string DFC_ASSESSMENT_REMINDER = 'DFC_Assessment_Reminder_HTML';
     string DFC_ASSESSMENT_REMINDER_TODAY = 'DFC_Assessment_Reminder_TODAY_HTML';
     string DFC_ASSESSMENT_REMINDER_OD = 'DFC_Assessment_Reminder_OD_HTML';
     String ORG_WIDE_EMAIL_ADDRESS_ID = WEBC_CommunityWrapper.getOrgWideEmailId('DF');
     String dfcPage= 'dfc_manage';

    public Dfc_AssessmentReminder_Batcher() {
    
    }


    public void execute() {


        // Loop the map of lists and process the emails according to the key value
        Map<String, List<CommunityDataHolder>> mapToProcess = getCommunitiesToProcess();
         system.debug('mapToProcess' + mapToProcess.values());
        List<Messaging.SingleEmailMessage> lisEmailsToSend = new List<Messaging.SingleEmailMessage>();    

        for ( String key : mapToProcess.keySet() ) { 

            List<Messaging.SingleEmailMessage> lisEmails = getEmails(mapToProcess.get(key), key);    
             System.Debug ( 'assessment to process' +lisEmails.size() );
            lisEmailsToSend.addAll(lisEmails);

        }

        if ( lisEmailsToSend.size() > 0 ) { Messaging.sendEmail(lisEmailsToSend); }

    }

    private List<Messaging.SingleEmailMessage> getEmails(List<CommunityDataHolder> lisCommunityData, String emailKey) {
      
       
        List<Messaging.SingleEmailMessage> lisReturn = new List<Messaging.SingleEmailMessage>();

        for ( CommunityDataHolder data : lisCommunityData ) {

            DFC_Community__c community = data.community;
            
            // Create the email here
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        
             String sDueDate = data.dueDate.format();
             String stubURL = Community_Settings__c.getInstance('DF_Stub_Url').value__c;
             

             Map<String, String> mapValues = (Map<String, String>)replacementValuesMap.get(emailKey);
             mapValues.put('contact_name', community.Owner.Name);
             mapValues.put('assessment_due_date', sDueDate); 
             mapValues.put('community_name', community.Name__c); 
             mapValues.put('survey_url', stubURL+dfcPage+'?dfcid='+community.Id); 
                        
           if (emailKey == 'TODAY')
               {
                 msg = Mail_Utils.getEmailWithData(DFC_ASSESSMENT_REMINDER_TODAY, 
                                                       community.Ownerid, 
                                                       null, 
                                                       ORG_WIDE_EMAIL_ADDRESS_ID, 
                                                       false, 
                                                       null, 
                                                       mapValues);
                
                  lisReturn.add(msg);
            
               } else if(emailKey == 'OD')
           
           {
        
             msg = Mail_Utils.getEmailWithData(DFC_ASSESSMENT_REMINDER_OD, 
                                                   community.Ownerid, 
                                                   null, 
                                                   ORG_WIDE_EMAIL_ADDRESS_ID, 
                                                   false, 
                                                   null, 
                                                   mapValues);
             lisReturn.add(msg);
        
           } else
           
           {
             msg = Mail_Utils.getEmailWithData(DFC_ASSESSMENT_REMINDER, 
                                                   community.Ownerid, 
                                                   null, 
                                                   ORG_WIDE_EMAIL_ADDRESS_ID, 
                                                   false, 
                                                   null, 
                                                   mapValues);
            lisReturn.add(msg);

           }
           
        }
        system.debug('MAIL MeSSAGES' + lisReturn);
        return lisReturn;

    }


    private static Map<String, Map<String, String>> replacementValuesMap {

        get {


            if ( replacementValuesMap != null ) { return replacementValuesMap; }

            Map<String, String> map3M = new Map<String, String>();
            map3M.put('xM_reminder', 'due in 3 months time');

            Map<String, String> map1M = new Map<String, String>();
            map1M.put('xM_reminder', 'due in 1 month');            

            Map<String, String> mapToday = new Map<String, String>();
            mapToday.put('xM_reminder', 'due today');

            Map<String, String> mapOD = new Map<String, String>();
            mapOD.put('xM_reminder', 'overdue');

            Map<String, Map<String, String>> rtn = new Map<String, Map<String,String>>();
            rtn.put('3M', map3M);
            rtn.put('1M', map1M);
            rtn.put('TODAY', mapToday);
            rtn.put('OD', mapOD);

            replacementValuesMap = rtn;
            return replacementValuesMap;


        }

        set;


    }




    private Map<String, List<CommunityDataHolder>> getCommunitiesToProcess() {  

        // 1. Get all the Active / Approved Dementia Friendly Communities

        List<DFC_Community__c> lisCommunities = [
            SELECT Id, Name__c, Date_Approved__c, Owner.Name, Ownerid, Status__c 
            FROM DFC_Community__c 
            WHERE Status__c = 'Active' 
            AND Date_Approved__c != null
        ];

        if ( lisCommunities.size() ==0 ) { return new Map<String, List<CommunityDataHolder>>(); }

        List<String> lisCommunityIds = new List<String>();
        List<CommunityDataHolder> lisDataHolders = new List<CommunityDataHolder>();

        // 2. For each community, Get the next Assessment Year, and Due date for the next assessment
        for ( DFC_Community__c community : lisCommunities ) {

            Integer i = getNextAssessmentYear(community);
            
            Date dueDate = community.Date_Approved__c.addMonths((i * 12)+12).date();
            System.debug('DUE DATE COMPUTED '+ duedate+'//'+ community.Date_Approved__c);
            CommunityDataHolder data = new CommunityDataHolder(dueDate, i, community);

            lisDataHolders.add(data);
            lisCommunityIds.add(community.Id);

        }


        //3. Get all the Assessments (include the submitted ones, so they can be checked for existence)
         List<DFC_Assessment__c> lisAssessments = [
               SELECT Id, Status__c, Community__c, Year_Number__c 
               FROM DFC_Assessment__c 
               WHERE Community__c in:lisCommunityIds
         ];
         Map<String, DFC_Assessment__c> mapAssessments = new Map<String, DFC_Assessment__c>();

         for (DFC_Assessment__c assessment : lisAssessments) {

            String key = assessment.Community__c + '$' + assessment.Year_Number__c;
            mapAssessments.put( key, assessment );

         }


         //4. Compile the list of lists for Communities due a reminder email

         Map<String, List<CommunityDataHolder>> mapReturn = new Map<String, List<CommunityDataHolder>>();

         List<CommunityDataHolder> lis3MonthReminders = new List<CommunityDataHolder>();
         List<CommunityDataHolder> lis1MonthReminders = new List<CommunityDataHolder>();
         List<CommunityDataHolder> lisTodayReminders = new List<CommunityDataHolder>();
         List<CommunityDataHolder> lis1MonthOverdueReminders = new List<CommunityDataHolder>();


         for (CommunityDataHolder data : lisDataHolders) {

            String key = data.community.id + '$' + data.year;
            DFC_Assessment__c assessment = mapAssessments.get(key);
            system.debug('DUE DATE' + data.dueDate);
            

            //1. Check for a 3 month due date

            if ( data.dueDate == System.Today().addMonths(3) ) {
            system.debug('3M DUE DATE' + data.dueDate);

                if ( (assessment == null) || (assessment != null && assessment.Status__c != 'Submitted') )  { 

                    lis3MonthReminders.add(data);
                     system.debug( 'size of the list 3m reminder'+lis3MonthReminders.size());
                }


            }

            //2. Check for 1 month due date

            if ( data.dueDate == System.Today().addMonths(1) ) {
              
                system.debug('1M DUE DATE' + data.dueDate);

                if ( (assessment == null) || (assessment != null && assessment.Status__c != 'Submitted') )  { 

                    lis1MonthReminders.add(data);
                
                }


            }

            //3. Check for a today due date 

            if ( data.dueDate == System.Today() ) {

                system.debug('DUE DATE IS TODAY' + data.dueDate);
                
                if ( (assessment == null) || (assessment != null && assessment.Status__c != 'Submitted') )  { 

                    lisTodayReminders.add(data);
                
                }


            }

            //4. Check for a 1 month over due date

            if ( data.dueDate == System.Today().addMonths(-1) ) {

                if ( (assessment == null) || (assessment != null && assessment.Status__c != 'Submitted') )  { 

                    lis1MonthOverdueReminders.add(data);
                
                }


            }

            //5. Nothing to do today


         }

         mapReturn.put('3M', lis3MonthReminders);
         mapReturn.put('1M', lis1MonthReminders);
         mapReturn.put('TODAY', lisTodayReminders);
         mapReturn.put('OD', lis1MonthOverdueReminders);
         system.debug ('Map Return' + mapReturn.values());
         return mapReturn;

    }

    private class CommunityDataHolder {

        Date dueDate {get;set;}
        Integer year {get;set;}
        DFC_Community__c community {get;set;}

        public CommunityDataHolder(Date dueDate, Integer year, DFC_Community__c community) {

            this.dueDate = dueDate;
            this.year = year;
            this.community = community;

        }

    }


    // This will be used to compute the number of the next assessment year.
    private static Integer getNextAssessmentYear(DFC_Community__c comm)
    {
      DateTime ad = comm.Date_Approved__c;
      Date now = Date.today();
      if ( Date.isLeapYear(now.Year()) && now.dayOfYear() > 59 ) {
        
        now = now.addDays(-1);
        system.debug('Adjusted Date for Leap Year '+ now);
        
      }
      
      system.debug('Assessment Reminder : Current Day of Year '+ now.dayOfYear());
      system.debug('Assessment Reminder : Approved Day of Year '+ ad.dayOfYear());
      
      system.debug('Assessment Reminder : Now Year '+ now.year());
      system.debug('Assessment Reminder : Approved Year '+ ad.year());

      integer i =  now.dayOfYear() <= ad.dayOfYear() ? now.year() - ad.year()-1  : now.year() - ad.year();
      system.debug('GET ASSESSMENT YEAR Integer Value '+ i);
      return i;
    }


}