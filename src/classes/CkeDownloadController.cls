public with sharing class CkeDownloadController {


	public CkeDownloadController() {
		
	}

	/* Push the user off to a servlet url */
	public PageReference go() {

		String key = ApexPages.currentPage().getParameters().get('key');
		EdtDownloadController edt = new EdtDownloadController();
		PageReference pr = edt.getRedirect(key, 'cke-downloads');

		if ( pr!=null ) { return pr; } 

		return Page.Cke_Error;

	}


}