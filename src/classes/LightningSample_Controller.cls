public class LightningSample_Controller {


    @AuraEnabled
    public static User getCurrentUser() {

      if ( UserInfo.getUserId()==null ) { return null;  }
      User u = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
      return u;


    }

}