/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : A utility class with useful utilities for encryptinhg data
 *  Author  : Gary Grant
 *  Date    : 10 Feb 2015
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 
                        
*******************************************************************************************/ 


public class WEBC_CryptoUtils {


	/* This code can be run as Anonymous Apex to create the key
   	   The key can be stored in a Custom Setting or a restricted access custom object */
	public static String createCryptoKey()
	{

			Blob cryptoKey = Crypto.generateAesKey(128);
			String encodedKey = EncodingUtil.base64encode(cryptoKey);
			System.debug(encodedKey);
			return encodedKey;

			/*	
			String myValue = 'Test Value';
			Blob encryptedValue = Crypto.encryptWithManagedIV('AES128', cryptoKey, Blob.valueOf(myValue));
			Blob decodedKey = EncodingUtil.base64decode(encodedKey);
			Blob decryptedValue = Crypto.decryptWithmanagedIV('AES128', decodedKey, encryptedValue);
			System.debug(decryptedValue.toString());
			*/

	}

	/*
		Encryption:  Start Value > Blob.valueOf > Encrypt > encode > End Value
	    Decryption:  End Value > decode > Decrypt > Blob.toString > Start Value	*/    
	public static String decryptValue(String encryptedValue, String key)
	{

		try { 
			
			Blob decodedKey = EncodingUtil.base64decode(key);
			Blob data = EncodingUtil.base64decode(encryptedValue);
			Blob decryptedValue = Crypto.decryptWithManagedIV('AES128', decodedKey, data);
			return decryptedValue.toString();
			} catch (Exception x) {
				return 'Error : ' + x.getMessage();
			}


	}

	public static String encryptValue(String v, String key)
	{
		try { 

			Blob encodedKey = EncodingUtil.base64decode(key);
			Blob data = Blob.valueOf(v);
			Blob encryptedValue = Crypto.encryptWithManagedIV('AES128', encodedKey, data);
			return EncodingUtil.base64Encode(encryptedValue);	
//			return encryptedValue.toString();

			} catch (Exception x) {
				return 'Error : ' + x.getMessage();
			}

	}


}