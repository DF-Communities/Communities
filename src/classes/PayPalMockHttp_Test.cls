@istest
global with sharing class PayPalMockHttp_Test implements HttpCalloutMock {

	public PayPalMockHttp_Test() {
		
	}
	
    global HTTPResponse respond(HTTPRequest req) {

    	PayPalClient client = new PayPalClient();

    	if ( req.getEndpoint().contains('oauth2') ) {

    		HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
    		res.setStatusCode(200);
    		res.setBody('xxxx');
    		return res;

    	}
    	
		if ( req.getEndpoint().contains('api-3t.paypal.com') ) {

    		HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
    		res.setStatusCode(200);
    		res.setBody('xxxx');
    		return res;

    	}

        if ( req.getEndpoint().contains('payment') ) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(201);
            res.setBody('{"id":"PAY-7DP258919H523561BK4D7LLY","create_time":"2016-04-08T18:17:19Z","update_time":"2016-04-08T18:17:23Z","state":"approved","intent":"sale","payer":{"payment_method":"credit_card","funding_instruments":[{"credit_card":{"type":"visa","number":"xxxxxxxxxxxx0119","expire_month":"4","expire_year":"2021","first_name":"Test","last_name":"User","billing_address":{"line1":"5 Vivian Way","line2":"","city":"London","postal_code":"N2 0AB","country_code":"GB"}}}]},"transactions":[{"amount":{"total":"100.54","currency":"GBP","details":{"subtotal":"100.54"}},"related_resources":[{"sale":{"id":"36L70577M0106592V","create_time":"2016-04-08T18:17:19Z","update_time":"2016-04-08T18:17:23Z","amount":{"total":"100.54","currency":"GBP"},"state":"completed","parent_payment":"PAY-7DP258919H523561BK4D7LLY","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/sale/36L70577M0106592V","rel":"self","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/sale/36L70577M0106592V/refund","rel":"refund","method":"POST"},{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAY-7DP258919H523561BK4D7LLY","rel":"parent_payment","method":"GET"}],"fmf_details":{},"processor_response":{"avs_code":"X","cvv_code":"M"}}}]}],"links":[{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAY-7DP258919H523561BK4D7LLY","rel":"self","method":"GET"}]}');
            return res;

        }


        if ( req.getEndpoint().endsWith('nvp') ) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/text');
            res.setStatusCode(200);
            res.setBody('payypal.com?ACK=Success');
            return res;

        }


        // This should work for the mail client
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<xml>some response</xml>');
        res.setStatusCode(200);
        return res;

    	
    }

}