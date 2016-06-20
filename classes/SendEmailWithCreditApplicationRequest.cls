global class SendEmailWithCreditApplicationRequest
{
     @future(callout=true)
     public static void sendEmail(Id creditAppId, String userSessionId)
     {
        //String addr = 'https://cs18.salesforce.com/services/apexrest/SendEmailWithCreditApplication'; // SANDBOX
        String addr = 'https://na16.salesforce.com/services/apexrest/SendEmailWithCreditApplication'; // PROD
        HttpRequest req = new HttpRequest();
        req.setEndpoint(addr);
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + userSessionId);
        req.setHeader('Content-Type','application/json');

        Map<String,String> postBody = new Map<String,String>();
        postBody.put('Id', creditAppId);
        
        String reqBody = JSON.serialize(postBody);
        if(Test.isRunningTest() == false) {
            req.setBody(reqBody);
            Http http = new Http();
            HttpResponse response = http.send(req);
        }
    }
}