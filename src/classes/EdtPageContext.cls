public class EdtPageContext 
{
    private Integer seq = 100;
    private Map<String, Map<String, Edt_Item__c>> groupCache = new Map<String, Map<String, Edt_Item__c>>();
    public boolean editEnabled { get;set; }

    public final static String ENABLING_PERMISSION_SET = 'Cke_Administrators';

    public EdtPageContext() {

        PermissionSetAssignment[] ass = [ SELECT Id FROM PermissionSetAssignment where Assignee.Id = :UserInfo.getUserId() and PermissionSet.Name = :ENABLING_PERMISSION_SET ];
        editEnabled = (!ass.isEmpty());

    }

    public Edt_Item__c readStore(String itemGroup, String itemKey)
    {
        Map<String, Edt_Item__c> grp = groupCache.get(itemGroup);
        if (grp == null) {
            Edt_Item__c[] items = [select Id, (select id, ContentType from Attachments order by CreatedDate desc limit 1), Group__c, Key__c, Value2__c, Value1__c, Value3__c, Value4__c, Value5__c, Value6__c, Text1__C, Text2__C, Text3__C from Edt_Item__c where Group__c = :itemGroup ];
            grp = new Map<String, Edt_Item__c>();
            for (Edt_Item__c item : items) grp.put(item.Key__c, item);
            groupCache.put(itemGroup, grp);
        }
        return grp.get(itemKey);
    }
    
    public String generateId()
    {
        return 'EDT'+seq++;
    }

}