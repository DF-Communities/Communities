global class DF_Mail_DoAllMailBatches implements Schedulable{
   global void execute(SchedulableContext SC) {

  
  if(Test.isRunningTest())
  {
      DF_Mail_ChampCloseSession_Batcher a = new DF_Mail_ChampCloseSession_Batcher(); 
      a.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_14_DAYS;
      a.days = -14;
      database.executebatch(a,1);
      
      DF_Mail_ChampCloseSession_Batcher b = new DF_Mail_ChampCloseSession_Batcher(); 
      b.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_30_DAYS;
      b.days = -30;
      database.executebatch(b,1);
      
      DF_Mail_ChampCloseSession_Batcher c = new DF_Mail_ChampCloseSession_Batcher(); 
      c.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_45_DAYS;
      c.days = -45;
      database.executebatch(c,1);
      
      
      
   }else {

      DF_Mail_ChampCloseSession_Batcher a = new DF_Mail_ChampCloseSession_Batcher(); 
      a.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_14_DAYS;
      a.days = -14;
      database.executebatch(a,1);
      
      DF_Mail_ChampCloseSession_Batcher b = new DF_Mail_ChampCloseSession_Batcher(); 
      b.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_30_DAYS;
      b.days = -30;
      database.executebatch(b,1);
      
      DF_Mail_ChampCloseSession_Batcher c = new DF_Mail_ChampCloseSession_Batcher(); 
      c.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_45_DAYS;
      c.days = -45;
      database.executebatch(c,1);
      
      /*         
      DF_Mail_ActivateChamp_Batcher f = new DF_Mail_ActivateChamp_Batcher(); 
      f.days =-14;
      database.executebatch(f,1);*/
           
      
      DF_MAIL_NeverRunSession_Batcher g = new DF_MAIL_NeverRunSession_Batcher();
      g.templateName = DF_Mail_Utils.VF_WITHOUTSESSIONS1M;
      g.days = -30;
      database.executebatch(g,1);
      
      DF_MAIL_NeverRunSession_Batcher h = new DF_MAIL_NeverRunSession_Batcher();
      h.templateName = DF_Mail_Utils.VF_WITHOUTSESSIONS2M;
      h.days = -60;
      database.executebatch(h,1);
      
      DF_MAIL_NeverRunSession_Batcher h1 = new DF_MAIL_NeverRunSession_Batcher();
      h1.templateName = DF_Mail_Utils.VF_WITHOUTSESSIONS3M;
      h1.days = -90;
      database.executebatch(h1,1);

      
      DF_MAIL_NeverRunSession_Batcher i = new DF_MAIL_NeverRunSession_Batcher();
      i.templateName = DF_Mail_Utils.VF_WITHOUTSESSIONS4M;
      i.days = -120;
      database.executebatch(i,1);
      
     
      
      DF_Mail_ChampNoSessions_Batcher j = new DF_Mail_ChampNoSessions_Batcher(); 
      j.templateName =DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_2_MONTHS;
      j.days = -60;
      database.executebatch(j,1);
      
      
      DF_Mail_ChampNoSessions_Batcher k = new DF_Mail_ChampNoSessions_Batcher(); 
      k.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_4_MONTHS;
      k.days = -120;
      database.executebatch(k,1);
      
      
      DF_Mail_ChampNoSessions_Batcher l = new DF_Mail_ChampNoSessions_Batcher(); 
      l.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_6_MONTHS;
      l.days = -180;
      database.executebatch(l,1);
      
      DF_Mail_ChampNoSessions_Batcher m = new DF_Mail_ChampNoSessions_Batcher(); 
      m.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_8_MONTHS;
      m.days = -240; 
      database.executebatch(m,1);
      
      DF_Mail_ChampNoSessions_Batcher n = new DF_Mail_ChampNoSessions_Batcher(); 
      n.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_10_MONTHS;
      n.days = -300;
      n.newStatus = DF_Utils.STATUS_RETIRED;
      database.executebatch(n,1);
  
     
      DF_Mail_NoOfFriends_Batcher o = new DF_Mail_NoOfFriends_Batcher();
      o.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
      o.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;
      database.executebatch(o,1);
      
      DF_Mail_SessionReminder p = new DF_Mail_SessionReminder();
      p.templatename = DF_Mail_Utils.VF_DF_SESSION_REMINDER;
      Database.executeBatch( p, 1 );
      
      DF_Mail_CourseReminder q = new DF_Mail_CourseReminder();
      q.templatename = DF_Mail_Utils.VF_DFC_COURSE_REMINDER;
      Database.executeBatch( q , 1 );
      
      
     

  }
  }
  
  }