global class SendEmailWithRequest
{
     @future(callout=true)
     public static void sendEmail(Id rateProtectionId, String userSessionId)
     {
        //String addr = 'https://dev-dylt.cs17.force.com/services/apexrest/SendEmailWithRateProtectionRequest'; // SANDBOX
        String addr = 'https://dylt.secure.force.com/services/apexrest/SendEmailWithRateProtectionRequest'; // PROD
        HttpRequest req = new HttpRequest();
        req.setEndpoint(addr);
        req.setMethod('POST');
        req.setTimeout(60000);
        //req.setHeader('Authorization', 'OAuth ' + userSessionId);
        req.setHeader('Content-Type','application/json');
 
        Map<String,String> postBody = new Map<String,String>();
        postBody.put('Id', rateProtectionId);
        
        String reqBody = JSON.serialize(postBody);
        if(Test.isRunningTest() == false) {
            req.setBody(reqBody);
            Http http = new Http();
            HttpResponse response = http.send(req);
        }
    }
}