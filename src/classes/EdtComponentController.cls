public virtual class EdtComponentController 
{
    public String itemGroup { get; set; }
    public String itemKey { get; set; }
    
    public String itemValue1 { get { checkStore(); return itemValue1; } set; }
    public String itemValue2 { get { checkStore(); return itemValue2; } set; }
    public String itemValue3 { get { checkStore(); return itemValue3; } set; }
    public String itemValue4 { get { checkStore(); return itemValue4; } set; }
    public String itemValue5 { get { checkStore(); return itemValue5; } set; }
    public String itemValue6 { get { checkStore(); return itemValue6; } set; }
    public String itemText1 { get { checkStore(); return itemText1; } set; }
    public String itemText2 { get { checkStore(); return itemText2; } set; }
    public String itemText3 { get { checkStore(); return itemText3; } set; }
    
    public String htmlClass { get; set; }
    public String htmlStyle { get; set; }
    
    public EdtPageContext pageContext { get; set; }

    private Boolean storeChecked = false;
    
    public void checkStore() { checkstore(true); }
    public void checkStore(boolean bCache)
    {
        if (bCache && storeChecked) { return; }
        Edt_Item__c item = pageContext.readStore(itemGroup, itemKey);
    
        if (item!=null) {
    
          itemValue1 = item.Value1__c;
          itemValue2 = item.Value2__c;
          itemValue3 = item.Value3__c;
          itemValue4 = item.Value4__c;
          itemValue5 = item.Value5__c;
          itemValue6 = item.Value6__c;
          itemText1 = item.Text1__c;
          itemText2 = item.Text2__c;
          itemText3 = item.Text3__c;

          if ( item.Attachments!=null && item.Attachments.size()>0 ) {

              itemAttachmentId = item.Attachments[0].id;  

          }


        }
        storeChecked = true;
    }

    public Boolean hasAttachment { get { checkstore(false); return itemAttachmentId != null; } private set; }
    public String itemAttachmentId { get { checkstore(); return itemAttachmentId; } set; }
    public Attachment attachment { get;set; }
    public Attachment getAttachment() 
    {
            if ( attachment != null ) { return attachment; }
            checkStore();
            if ( itemAttachmentId == null ) return null;
            attachment = [select id, Name, ContentType, Body from Attachment where id=:itemAttachmentId limit 1]; 

            return attachment;            
    }

  	private String itemId;
    public String getItemId()
    {
        if (itemId==null) itemId = pageContext.generateId();
        return itemId;
	}
	    
}