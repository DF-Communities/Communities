@isTest
public class CustomUtils_Test {

	public CustomUtils_Test() {
		
	}

    public static TestMethod void test_objectWithAllFields()
	  {
	    
	     Account acc = new Account(Name = 'Test Account');
	     insert acc;
	     
	     SObject o = CustomUtils.objectWithAllFields('id', acc.id, Schema.sObjectType.Account);	    
	        
	  } 
	 
	      
   public static TestMethod void  test_objectMapWithAllFields()
	  {
	    
	       Account acc = new Account(Name = 'Test Account');
	       insert acc;
	       
	       List<String> lis = new List<String>();
	       lis.add(acc.id);
	       
	       Map<String, sObject> mapO = CustomUtils.objectMapWithAllFields('id', lis, Schema.sObjectType.Account);
	  }

}