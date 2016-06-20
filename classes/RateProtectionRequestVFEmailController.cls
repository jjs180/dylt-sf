public class RateProtectionRequestVFEmailController
{
    public Rate_Protection_Request__c RateProtectionRequest {get; set;}
    public List<Freight__c> Freights {get; set;}
    public Boolean isAccountOrLead {get; set;}
    
    public RateProtectionRequestVFEmailController(ApexPages.StandardController controller)
    {
        isAccountOrLead = false;
        RateProtectionRequest = [select Id, Volume_Quote__c, Volume_Price__c, Probill__c, Probillx__r.Name, Probill_Datex__c, Acct__c, Account__c, Account__r.DYLT_Account__c, Account__r.Name, Lead__c, Lead__r.Company, Lead__r.TruckMate_Id__c, Origin_City_State_Zip__c, Destination_City_State_Zip__c,
            Was_this_shipment_W_I_d__c, W_I_corrected_amount__c, Requested_Pricing__c, Notes_Justification__c from Rate_Protection_Request__c where Id = :controller.getId()];
        if(RateProtectionRequest.Account__c != null)
        {
            isAccountOrLead = true;
        }
        else
        {
            isAccountOrLead = false;
        }
        initFreight(controller.getId());
    }
    
    private void initFreight(String rateProId)
    {
        Freights = new List<Freight__c>();
        Freights = [select Pieces__c, Weight_in_Lbs__c, Dimension_L_x_W_x_H__c, Freight_Description_Actual_Class__c, Stackable__c from Freight__c where Rate_Protection__c = :rateProId];
    }
}