public class WEBRobotsController {

public string siteUrl{
    get {
        String surl = site.getcustomwebaddress();
        
        if (Test.isRunningTest()) surl = '';
            
        if (surl != '' && surl != null) {
            return site.getcustomwebaddress();
        } else {
            surl = site.getcurrentsiteurl();
            
            if (Test.isRunningTest()) surl = '';
            
            if (surl != '' && surl != null) {
                return site.getcurrentsiteurl();
            } else {
                return URL.getSalesforceBaseUrl().toExternalForm() + '/apex/';
            }
        }
    }
    set;
    }
    
    @isTest(SeeAllData=false)
     private static void test_siteUrl() {
     
         WebRobotsController controller = new WebRobotsController();
     
         String theUrl = controller.siteUrl;
     }
}