public with sharing class WEBC_Set_Password {
	

	public WEBC_Set_Password() {
		
	}

	public PageReference doSetPassword() {

		User u = [select id, Email from User where UserName = 'gg-tt-307@mailinator.com'];
		system.debug('Password Set : ' + u.id);
		System.setPassword(u.id, 'bbbb1111');

		system.debug('Password Set Done: ' + u.id);
		return null;

	}

	public PageReference doResetPassword() {

		User u = [select id, Email from User where UserName = 'gg-tt-307@mailinator.com'];
		system.debug('Password Reset : ' + u.id);

		System.resetPassword(u.id, true);
		system.debug('Password Reset Done : ' + u.id);

		return null;


	}


}