public with sharing class WEBRegister extends WEBController {
     
    public final String REGISTER_SNIPPET_NAME = 'Registration_Snippet';
    

    public Page_Snippet__c registerText {
        get {
            if (registerText == null){
                registerText = [Select p.Unique_Name__c, p.Name__c, p.Name, p.Id, p.Body_Text__c From Page_Snippet__c p where p.Unique_Name__c = :REGISTER_SNIPPET_NAME LIMIT 1];
            }
            return registerText;
        }
        set;
    }
    
    public static testmethod void WEBRegisterTest()
    {
    Page_Snippet__c p=new Page_Snippet__c (Unique_Name__c='Registration_Snippet',Name__c='Registration_Snippet',Body_Text__c='atestb');
    insert p;    
    WEBRegister wr=new WEBRegister ();
    wr.registerText=null;
    Page_Snippet__c p1=new Page_Snippet__c();
    p1=wr.registerText;
    
    }

}