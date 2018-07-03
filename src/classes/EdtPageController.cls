public virtual class EdtPageController 
{
    public final transient EdtPageContext edtContext { get; private set; }
    public final String refererHeaderUrl {get; set;}
    
    public EdtPageController()
    {
        
        refererHeaderUrl = ApexPages.currentPage().getHeaders().get('Referer');
        if(refererHeaderUrl != null) {
            System.debug('Logging referer as: ' + refererHeaderUrl );
        } else {
            System.debug('No referrer could not be extracted');
        }
        
        edtContext = new EdtPageContext();        
    }
    
    public EdtPageController(ApexPages.StandardController c)
    {
        this();
    }
    
}