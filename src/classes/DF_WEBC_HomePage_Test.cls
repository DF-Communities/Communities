/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_HomePage
 *  Author  : Lakshmi Rajendram
 *  Date    : 12-03-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
public class DF_WEBC_HomePage_Test {
    
    
    static testMethod void testWEBC_HomePage() {
    
        DF_WEBC_HomePage ctl=new DF_WEBC_HomePage();

        News_Flash__c  NF1=ctl.newsFlash;
        News_Flash__c  NF=new News_Flash__c (IsActive__c=true,Date_to_be_published__c=system.today(),Main_Body__c='atestb');
        insert NF;

        DF_WEBC_HomePage ctl2 = new DF_WEBC_HomePage();
        ctl2.newsFlash =null;

        News_Flash__c  NF2=ctl2.newsFlash;

        Page_Snippet__c  ps=new Page_Snippet__c (Name__c='test',Position__c = 'slide');
        insert ps;

        Page__c p=new Page__c(Unique_text__c = 'Home_Page');
        insert p;

        Page_Display_Snippet__c  pds= new  Page_Display_Snippet__c(Page__c=p.id,Page_Snippet__c=ps.id);
        insert pds;
       
        List<DF_WEBC_HomePage.Slide> lisSlides = ctl.slides; 
        
    }
        
    
}