public class RateProtectionRequestEditController
{
    public Rate_Protection_Request__c RateProtectionRequest {get; set;}
    public List<Freight__c> Freights {get; set;}
    public Boolean isAccount {get; set;}
    public Boolean isLead {get; set;}
    public Map<String, String> rtMap = new Map<String, String>();
    
    public RateProtectionRequestEditController(ApexPages.StandardController controller)
    {
        isAccount = false;
        isLead = false;
        readRecordType();
        RateProtectionRequest = [select Id, Probill__c, Lead__c, Status__c, Account__c, Volume_Quote__c, Volume_Price__c, Requested_Pricing__c, Origin_City_State_Zip__c, Destination_City_State_Zip__c, Was_this_shipment_W_I_d__c, W_I_corrected_amount__c, Notes_Justification__c,
        (select Id, Pieces__c, Weight_in_Lbs__c, Dimension_L_x_W_x_H__c, Freight_Description_Actual_Class__c, Stackable__c from Freight__r limit 4) from Rate_Protection_Request__c where Id =:controller.getId()];
        if(RateProtectionRequest.Account__c != null)
        {
            isAccount = true;
        }
        else if(RateProtectionRequest.Lead__c != null)
        {
            isLead = true;
        }
        else if(rtMap.get(RateProtectionRequest.recordTypeId) == 'Account Rate Protection')
        {
            isAccount = true;
        }
        else if(rtMap.get(RateProtectionRequest.recordTypeId) == 'Lead Rate Protection')
        {
            isLead = true;
        }
        initFreight();
    }
    
    private void readRecordType()
    {
        List<RecordType> rts = [select Id, Name from RecordType where sObjectType = 'Rate_Protection_Request__c'];
        for(RecordType rt : rts)
        {
            rtMap.put(rt.Id, rt.Name);
        }
    }
    
    private void initFreight()
    {
        Freights = new List<Freight__c>();
        for(Freight__c freight : RateProtectionRequest.Freight__r)
        {
            Freights.add(freight);
        }
        for(Integer i = 0; i < 4 - Freights.size(); i++)
        {
            Freights.add(new Freight__c());
        }
    }
    
    public PageReference saveRateProtection()
    {
        upsert RateProtectionRequest;
        
        for(Freight__c freight : Freights)
        {
            if(freight.Id == null)
            {
                freight.Rate_Protection__c = RateProtectionRequest.Id;
            }
        }
        
        upsert Freights;
        
        return new PageReference('/' + RateProtectionRequest.Id);
    }
    
    public PageReference saveAndSend()
    {
        upsert RateProtectionRequest;
        
        for(Freight__c freight : Freights)
        {
            if(freight.Id == null)
            {
                freight.Rate_Protection__c = RateProtectionRequest.Id;
            }
        }
        
        upsert Freights;
        
        sendEmail(RateProtectionRequest.Id, UserInfo.getSessionId());
        
        return new PageReference('/' + RateProtectionRequest.Id);
    }
    
    @future(Callout = true)
    public static void sendEmail(Id rateProtectionId, String userSessionId) {
        //String addr = 'https://cs18.salesforce.com/services/apexrest/SendEmailWithRateProtectionRequest'; // SANDBOX
        String addr = 'https://na16.salesforce.com/services/apexrest/SendEmailWithRateProtectionRequest'; // PROD
        HttpRequest req = new HttpRequest();
        req.setEndpoint(addr);
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + userSessionId);
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