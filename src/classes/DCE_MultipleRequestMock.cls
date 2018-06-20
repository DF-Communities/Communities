/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class DCE_MultipleRequestMock implements HttpCalloutMock{

	private map<String, DCE_SingleRequestMock> requests;

	public DCE_MultipleRequestMock(Map<String, DCE_SingleRequestMock> requests) {
		system.debug('SETTING UP THE MULTIMOCK - '+requests);
		this.requests = requests;
	}

	public HTTPResponse respond(HTTPRequest req) {
		system.debug('GETTING THE ENDPOINT - '+req);
		system.debug('GETTING THE MOCK RESPONSE - '+requests.get(req.getEndpoint()));
		HttpCalloutMock mock = requests.get(req.getEndpoint());
		if (mock != null) {
			return mock.respond(req);
		} else {
			throw new DCE_Exception('HTTP callout not supported for test methods');
		}
	}

	/*public void addRequestMock(String url, DCE_SingleRequestMock mock) {
		requests.put(url, mock);
	}*/

}