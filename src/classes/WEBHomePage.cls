public class WEBHomePage extends WEBController {

    public News_Flash__c newsFlash {
        get {
            if (newsFlash == null){
                List<News_Flash__c> nfList = new List<News_Flash__c>();
                nfList = [Select n.Main_Body__c, n.IsActive__c, n.Date_to_be_published__c From News_Flash__c n where n.IsActive__c = true ORDER BY n.Date_to_be_published__c DESC LIMIT 1];
                if (nfList.size() > 0){
                    newsFlash = nfList[0];
                }else {
                    newsFlash = new News_Flash__c();
                }
            }
            
            return newsFlash;
        }
        set;
    }
    public static testmethod void webhomepage_test()
    {
       WEBHomePage whp1=new WEBHomePage ();
        News_Flash__c  NF1=whp1.newsFlash;
        News_Flash__c  NF=new News_Flash__c (IsActive__c=true,Date_to_be_published__c=system.today(),Main_Body__c='atestb');
        insert NF;
        WEBHomePage whp=new WEBHomePage ();
        whp.newsFlash =null;
        News_Flash__c  NF2=whp.newsFlash;
        
    }
    
}