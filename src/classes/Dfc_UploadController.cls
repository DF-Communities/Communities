public without sharing class Dfc_UploadController 
{
   public Attachment attachment {
    get {
      if (attachment == null) attachment = new Attachment(); 
      return attachment;
    }
   set;
  }
    
  public transient String errorMessage { get; private set;} 
  public transient  String diagnostic { get; private set;} 
    
  public AttData[] getAttachments()
  {
      String parentId = ApexPages.currentPage().getParameters().get('id');
      Attachment[] atts = [ select Id, Name, ContentType, BodyLength from attachment where ParentId = :parentId];
      List<AttData> data = new List<AttData>();
      for (Attachment att : atts){
          data.add(new AttData(att));
      }
      return data;
  }

  public String signId(String id)
  {
      return id;
  }
    
  public PageReference upload() 
  {
    attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = ApexPages.currentPage().getParameters().get('id');
   // attachment.IsPrivate = true;

    try {
    if (attachment.Body == null) throw new Dfc_Exception('File size cannot exceed 25MB');
      insert attachment;
      errorMessage = 'Ok';
    } 
    catch (Exception e) {
      errorMessage = e.getMessage();
      diagnostic = e.getStackTraceString();
    } 
    finally {
      attachment = new Attachment(); 
    }

    return null;
  }
    
  @AuraEnabled
  public static Object removeAttachment(String id)
  {
  Attachment[] data = [ select Id from Attachment where Id = :id ];
    if (data.isEmpty()) return null;
    delete data[0];
    return null;
  }
    
  public class AttData
  {
      public String Id {get;set;}
      public String Name {get;set;}
      public String ContentType {get;set;}
      public Integer BodyLength {get;set;}
      public String signedId {get;set;}
      
      public AttData(Attachment att)
      {
          this.Id = att.Id;
          this.Name = att.Name;
          this.ContentType = att.ContentType;
          this.BodyLength = att.BodyLength;
          this.signedId = Dfc_Util.createSignedPayload(att.Id);
      }
      
  }
 
}