@isTest
public class TestLookForLeadAndConvert
{
    @isTest
    public static void testLeadConvert()
    {
        List<Lead> leads = [select TruckMate_Id__c from Lead where TruckMate_Id__c != null limit 1];
        if(leads.size() > 0)
        {
            Account acc = new Account(DYLT_Account__c = leads[0].TruckMate_Id__c, Name = 'Test');
            insert acc;
        }
    }
}