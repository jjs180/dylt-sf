@isTest(seeAllData=true)
public class TestUpdateAllRevenueWithLead
{
    @isTest
    public static void testUpdate()
    {
        List<Account> accounts = [select Id from Account where DYLT_Account__c != null];
        if(accounts.size() > 0)
        {
            Probill__c probill = new Probill__c(Name = 'Test', Probill__c = '0p9olmkjn', Account__c = accounts[0].Id, Rev_Cont_Total__c = 123.21, Rev_Curr_Total__c = 21);
            insert probill;   
        }
    }
}