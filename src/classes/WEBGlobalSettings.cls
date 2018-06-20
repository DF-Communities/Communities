public with sharing class WEBGlobalSettings {
	private static final Id default_webAccountOwnerId = '001200000173xrc';
	// TEST private static final Id default_webAccountOwnerId = '001g000000Gjqjf';
    public static Id webAccountOwnerId {
        get {
            if (webAccountOwnerId == null) {
                webAccountOwnerId = default_webAccountOwnerId;

                Global_Setting__c globalSetting = Global_Setting__c.getInstance('webAccountOwnerId');
                if (globalSetting != null
                        && globalSetting.Value__c != null) {

                    webAccountOwnerId = globalSetting.Value__c;
                }
            }

            return webAccountOwnerId;
        }
        private set;
    }

    private static final String default_friendConvertCode = 'DementiaFriend123';
    public static String friendConvertCode {
        get {
            if (friendConvertCode == null) {
                friendConvertCode = default_friendConvertCode;

                Global_Setting__c globalSetting = Global_Setting__c.getInstance('friendConvertCode');
                if (globalSetting != null
                        && globalSetting.Value__c != null) {

                    friendConvertCode = globalSetting.Value__c;
                }
            }

            return friendConvertCode;
        }
        private set;
    }

    private static final String default_championConvertCode = 'ABC123';
    public static String championConvertCode {
        get {
            if (championConvertCode == null) {
                championConvertCode = default_championConvertCode;

                Global_Setting__c globalSetting = Global_Setting__c.getInstance('championConvertCode');
                if (globalSetting != null
                        && globalSetting.Value__c != null) {

                    championConvertCode = globalSetting.Value__c;
                }
            }

            return championConvertCode;
        }
        private set;
    }

	public WEBGlobalSettings() {
		
	}
}