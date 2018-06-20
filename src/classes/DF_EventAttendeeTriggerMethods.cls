/*
* 2014-03-25 : SM : This class holds methods called from the DF_EventAttendee__c trigger

   20 Jan 2016 : Update to handle change in permissioning	
				 All templates converted to HTML and data processed into the emails
				 from this class. Because the messaging action cannot run without sharing
				 it's not possible to send a VF email from a template
*/

public class DF_EventAttendeeTriggerMethods {

	public static final String CHAMPION_RT = 'Champion_Training_Course';
	public static final String SESSION_RT = 'Dementia_Friend_Awareness_Session';
	public static final String EVENT_STATUS_CANCELLED = 'Cancelled';
	public static final String ATTENDEE_STATUS_CANCELLED = 'Cancelled';
	public static final String ATTENDEE_STATUS_NOSHOW = 'No Show';
	public static final String ATTENDEE_STATUS_ATTENDED = 'Attended';
	
	public static final String VF_CHAMPION_TRAINING_BOOKED = 'DF_Champion_Training_Booked_HTML';
	public static final String VF_CHAMPION_TRAINING_UNREGISTERED = 'DF_Champion_Training_Unregistered_HTML';
	public static final String VF_FRIEND_SESSION_BOOKING_CONFIRMED = 'DF_Friend_Session_Booking_Confirmed_HTML';
	public static final String VF_FRIEND_SESSION_CANCELLED = 'DF_Friend_Session_Cancelled_HTML';
	public static final String VF_NEW_ATTENDEE_ON_SESSION = 'DF_New_Attendee_On_Session_HTML';
	public static final String VF_SESSION_ATTENDEE_CANCELLATION = 'DF_Session_Attendee_Cancellation_HTML';

	public static final String VF_UPDATED_SESSION_INFORMATION = 'VF_Updated_Session_Information';
	public static final String VF_NEW_INFORMATION_SESSIONS = 'VF_New_Information_Sessions';
		
	//2014-03-25 : SM : This method will process ALL incoming DF_EventAttendee__c records and send the appropriate emails to either the
	//DF_Contact__c record or the Session_Organiser__c record
	public static void processNotificationEmails(List<DF_EventAttendee__c> inRecords, boolean isDelete, boolean isInsert){

		List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

		String ORG_WIDE_EMAIL_ADDRESS_ID = WEBC_CommunityWrapper.getOrgWideEmailId('DF');		
        String stubUrl = WEBC_CommunityWrapper.getCustomSetting('Stub_Url', 'DF');       

		Map<Id, RecordType> rtMap = new Map<Id, RecordType>();
		Set<Id> dfEventIdSet = new Set<Id>();
		Set<Id> dfContactIdSet = new Set<Id>();
		
		for (RecordType rt : [select r.Id, r.DeveloperName from RecordType r where r.SObjectType = 'DF_Event__c' and r.IsActive = true]){
			rtMap.put(rt.Id, rt);
		}
		
		for (DF_EventAttendee__c dfe : inRecords){

			dfEventIdSet.add(dfe.DF_Event__c);
			dfContactIdSet.add(dfe.DF_Contact__c);

		}
		
		Map<Id, DF_Event__c> dfEventMap = new Map<Id, DF_Event__c>([select d.Id, d.Name, d.RecordTypeId, d.Event_Date_Time__c, d.Event_Status__c, d.Number_of_Attendees__c, d.Number_of_Attendee_Records__c, d.Session_Organiser__c, d.Session_Organiser__r.Name, d.Session_Organiser__r.Portal_Contact__c from DF_Event__c d where d.Id in :dfEventIdSet]);
		Map<Id, DF_Contact__c> dfContactMap = new Map<Id, DF_Contact__c>([select d.Id, d.First_Name__c, d.Last_Name__c, d.Portal_Contact__c from DF_Contact__c d where d.Id in :dfContactIdSet]);
		
		//Loop through each DF_EventAttendee__c record and work out which emails need to be sent
		for (DF_EventAttendee__c dfe : inRecords){

			boolean isTrainingCourse = false;
			boolean isSession = false;
			
			DF_Event__c event = dfEventMap.get(dfe.DF_Event__c);
			DF_Contact__c con = dfContactMap.get(dfe.DF_Contact__c);

			if (event != null){
			
				Date todayDate = system.today();
			
				if (todayDate.daysBetween(event.Event_Date_Time__c.date()) < 0 || EVENT_STATUS_CANCELLED.equalsIgnoreCase(event.Event_Status__c)){
		
				//Don't do anything if this event is before todays date
				} else {

					if (CHAMPION_RT.equalsIgnoreCase(rtMap.get(event.RecordTypeId).DeveloperName)){
					
						//This event attendee is against a Training Course
						isTrainingCourse = true;
	
					} else if (SESSION_RT.equalsIgnoreCase(rtMap.get(event.RecordTypeId).DeveloperName)){
							
						//This event attendee is against an Awareness Session
						isSession = true;
						
					}
					//This method is disabled - no longer called from the Trigger
					if (isTrainingCourse){

						if (con.Portal_Contact__c != null){


							String sDate = event.Event_Date_Time__c.format('d MMMM YYYY');
							Map<String, String> mapValues = new Map<String, String>();
							mapValues.put('contact.First_Name__c', con.First_Name__c);
							mapValues.put('contact.Last_Name__c', con.Last_Name__c);
							mapValues.put('event.Name', event.Name);
							mapValues.put('event.Event_Date_Time__c', sDate);

							

							Messaging.SingleEmailMessage sme = Mail_Utils.getEmailWithData(VF_CHAMPION_TRAINING_UNREGISTERED, 
																						   con.Portal_Contact__c, 
																						   dfe.id, 
																						   ORG_WIDE_EMAIL_ADDRESS_ID, 
																						   false, 
																						   null, 
																						   mapValues);

							emailsToSend.add(sme);

						}

					} else if (isSession) {
						
						//Send a message to the Event Organiser
						if (event.Session_Organiser__r.Portal_Contact__c != null){

							String sDate = event.Event_Date_Time__c.format('d MMMM YYYY');
							Map<String, String> mapValues = new Map<String, String>();
                            mapValues.put('event.Session_Organiser__r.Name', event.Session_Organiser__r.Name);
                            mapValues.put('event.Name', event.Name);
                            mapValues.put('contact.First_Name__c', con.First_Name__c);
                            mapValues.put('contact.Last_Name__c', con.Last_Name__c);
                            mapValues.put('event.Event_Date_Time__c', sDate);
                            mapValues.put('event.Number_Of_Attendee_Records__c', String.valueOf(event.Number_Of_Attendee_Records__c-1));

							Messaging.SingleEmailMessage sme = Mail_Utils.getEmailWithData(VF_SESSION_ATTENDEE_CANCELLATION, 
																						   event.Session_Organiser__r.Portal_Contact__c, 
																						   dfe.id, 
																						   ORG_WIDE_EMAIL_ADDRESS_ID, 
																						   false, 
																						   null, 
																						   mapValues);




							emailsToSend.add(sme);

				    	}

				    }
			    }
					
		   }

		}
		
		if (emailsToSend.size() > 0){
			
			Messaging.sendEmail(emailsToSend);
		
		} 
			
	}
	
	
	//2014-03-25 : SM : This method will process ALL incoming DF_EventAttendee__c records and send the appropriate emails to either the
	//DF_Contact__c record or the Session_Organiser__c record

	/* Jan 2016 None of these emails are sent. Disabled since before Jan 2015 */
	@future(callout=false)
	public static void processNotificationEmailsFuture(Set<Id> inIdSet, boolean isDelete, boolean isInsert){

		List<DF_EventAttendee__c> inRecords = new List<DF_EventAttendee__c>();
		inRecords = [Select d.Trainer__c, d.Name, d.Id, d.Event_Status__c, d.EventAttendeeStatus__c, d.DF_Event__c, 
						d.DF_EntAtExt_Id__c, d.DF_Contact__c From DF_EventAttendee__c d where d.Id in :inIdSet];

		List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

		String ORG_WIDE_EMAIL_ADDRESS_ID = WEBC_CommunityWrapper.getOrgWideEmailId('DF');		
        String stubUrl = WEBC_CommunityWrapper.getCustomSetting('Stub_Url', 'DF');     
		
		Map<Id, RecordType> rtMap = new Map<Id, RecordType>();
		Set<Id> dfEventIdSet = new Set<Id>();
		Set<Id> dfContactIdSet = new Set<Id>();
		
		for (RecordType rt : [select r.Id, r.DeveloperName from RecordType r where r.SObjectType = 'DF_Event__c' and r.IsActive = true]){
			rtMap.put(rt.Id, rt);
		}
		
		for (DF_EventAttendee__c dfe : inRecords){

			dfEventIdSet.add(dfe.DF_Event__c);
			dfContactIdSet.add(dfe.DF_Contact__c);

		}
		
		Map<Id, DF_Event__c> dfEventMap = new Map<Id, DF_Event__c>([select d.Id,d.Name, d.RecordTypeId, d.Event_Date_Time__c,d.Session_Organiser__r.Name,d.Session_Organiser__r.Portal_Contact__c,d.Location__c,d.Street__c,d.City__c,d.County__c,d.Postcode__c, d.Number_Of_Attendee_Records__c from DF_Event__c d where d.Id in :dfEventIdSet]);
		Map<Id, DF_Contact__c> dfContactMap = new Map<Id, DF_Contact__c>([select d.Id, d.First_Name__c, d.Last_Name__c, d.Portal_Contact__c from DF_Contact__c d where d.Id in :dfContactIdSet]);
		
		//We need to loop through each DF_EventAttendee__c record and work out which emails need to be sent
		for (DF_EventAttendee__c dfe : inRecords){

			boolean isTrainingCourse = false; 
			boolean isSession = false;
			
			DF_Event__c event = dfEventMap.get(dfe.DF_Event__c);
			DF_Contact__c con = dfContactMap.get(dfe.DF_Contact__c);

			if (event != null){

				Date todayDate = system.today();

				if (todayDate.daysBetween(event.Event_Date_Time__c.date()) < 0){

						//We don't do anything if this event is before todays date

				} else {

 					if (CHAMPION_RT.equalsIgnoreCase(rtMap.get(event.RecordTypeId).DeveloperName)){

						//This event attendee is against a Training Course
						isTrainingCourse = true;
		
		 			} else if (SESSION_RT.equalsIgnoreCase(rtMap.get(event.RecordTypeId).DeveloperName)){
	
						//This event attendee is against an Awareness Session
						isSession = true;
	
					}

					if (!isDelete){

						if (!ATTENDEE_STATUS_ATTENDED.equalsIgnoreCase(dfe.EventAttendeeStatus__c) && 
							!ATTENDEE_STATUS_NOSHOW.equalsIgnoreCase(dfe.EventAttendeeStatus__c) && 
							!ATTENDEE_STATUS_CANCELLED.equalsIgnoreCase(dfe.EventAttendeeStatus__c)){

							if (isTrainingCourse){

								if (isInsert){

									if (con.Portal_Contact__c != null){


										String sDate = event.Event_Date_Time__c.format('d MMMM YYYY');
										String sTime = event.Event_Date_Time__c.format('HH:mm');

										Map<String, String> mapValues = new Map<String, String>();
			                            mapValues.put('event.Session_Organiser__r.Name', event.Session_Organiser__r.Name);
			                            mapValues.put('event.Name', event.Name);
			                            mapValues.put('contact.First_Name__c', con.First_Name__c);
			                            mapValues.put('contact.Last_Name__c', con.Last_Name__c);
			                            mapValues.put('event.Event_Date', sDate);
			                            mapValues.put('event.Event_Time', sTime);

   									    mapValues.put('event.Location__c', event.Location__c);			                            	
   									    mapValues.put('event.Street__c', event.Street__c);			                            	
   									    mapValues.put('event.City__c', event.City__c);			                            	
   									    mapValues.put('event.County__c', event.County__c);			                            	
   									    mapValues.put('event.Postcode__c', event.Postcode__c);	
   									    mapValues.put('sessionLink', stubUrl + 'WebTrainingDetails?id=' + event.id);	

										Messaging.SingleEmailMessage sme = Mail_Utils.getEmailWithData(VF_CHAMPION_TRAINING_BOOKED, 
																						   con.Portal_Contact__c, 
																						   dfe.id, 
																						   ORG_WIDE_EMAIL_ADDRESS_ID, 
																						   false, 
																						   null, 
																						   mapValues);


										emailsToSend.add(sme);

									}

								}

							} else if(isSession){
	
								if (isInsert){
	
									if (con.Portal_Contact__c != null){
	
										String sDate = event.Event_Date_Time__c.format('d MMMM YYYY HH:mm');

										Map<String, String> mapValues = new Map<String, String>();

			                            mapValues.put('contact.First_Name__c', con.First_Name__c);
			                            mapValues.put('contact.Last_Name__c', con.Last_Name__c);
			                            mapValues.put('event.Event_Date_Time__c', sDate);

   									    mapValues.put('event.Location__c', event.Location__c);			                            	
   									    mapValues.put('event.Street__c', event.Street__c);			                            	
   									    mapValues.put('event.City__c', event.City__c);			                            	
   									    mapValues.put('event.County__c', event.County__c);			                            	
   									    mapValues.put('event.Postcode__c', event.Postcode__c);	
   									    mapValues.put('sessionLink', stubUrl + 'WebSessionDetails?id=' + event.id);			                            	

										Messaging.SingleEmailMessage sme = Mail_Utils.getEmailWithData(VF_FRIEND_SESSION_BOOKING_CONFIRMED, 
																						   con.Portal_Contact__c, 
																						   dfe.id, 
																						   ORG_WIDE_EMAIL_ADDRESS_ID, 
																						   false, 
																						   null, 
																						   mapValues);


										emailsToSend.add(sme);
									}
									
									if (event.Session_Organiser__r.Portal_Contact__c != null){


										String sDate = event.Event_Date_Time__c.format('d MMMM YYYY HH:mm');

										Map<String, String> mapValues = new Map<String, String>();

			                            mapValues.put('event.Session_Organiser__r.Name', event.Session_Organiser__r.Name);
			                            mapValues.put('contact.First_Name__c', con.First_Name__c);
			                            mapValues.put('contact.Last_Name__c', con.Last_Name__c);
			                            mapValues.put('event.Event_Date_Time__c', sDate);
   			                            mapValues.put('event.Name', event.Name);

   									    mapValues.put('event.Location__c', event.Location__c);			                            	
   									    mapValues.put('event.Street__c', event.Street__c);			                            	
   									    mapValues.put('event.City__c', event.City__c);			                            	
   									    mapValues.put('event.County__c', event.County__c);			                            	
   									    mapValues.put('event.Postcode__c', event.Postcode__c);		
			                            mapValues.put('event.Number_Of_Attendee_Records__c', String.valueOf(event.Number_Of_Attendee_Records__c));   									    	                            	

										Messaging.SingleEmailMessage sme = Mail_Utils.getEmailWithData(VF_NEW_ATTENDEE_ON_SESSION, 
																						   event.Session_Organiser__r.Portal_Contact__c, 
																						   dfe.id, 
																						   ORG_WIDE_EMAIL_ADDRESS_ID, 
																						   false, 
																						   null, 
																						   mapValues);


										emailsToSend.add(sme);

									}

								}

							}

						}


					//We don't run the Delete part in the future method
					}
				}
			}

		}
		
		if (emailsToSend.size() > 0){

			if ( !Test.isRunningTest() ) { 
				Messaging.sendEmail(emailsToSend);
			}

		} 
		
	}

}