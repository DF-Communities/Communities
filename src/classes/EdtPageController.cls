public virtual class EdtPageController 
{
    public final transient EdtPageContext edtContext { get; private set; }
    public final String refererHeaderUrl {get; set;}
    
    
    
    public String companyTooltip {get;set;}
    public String proximityTooltip {get;set;}
    public String preferencesTooltip {get;set;}
    
    
    public EdtPageController()
    {
        
        EdtPageContext pgContext = new EdtPageContext();
        companyTooltip = pgContext.readStore('gdpr','company').Text1__c;
        proximityTooltip = pgContext.readStore('gdpr','connection-to-dementia').Text1__c;
        preferencesTooltip = pgContext.readStore('gdpr','contact-preferences').Text1__c;
        
        refererHeaderUrl = ApexPages.currentPage().getHeaders().get('Referer');
        
        edtContext = new EdtPageContext();        
    }
    
    public EdtPageController(ApexPages.StandardController c)
    {
        this();
    }
    
}