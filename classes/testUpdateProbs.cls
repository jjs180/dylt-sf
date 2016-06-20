@isTest
public class testUpdateProbs
{    
    @istest
    static void testJob()
    {
        List<Account> accnts = TestUtilities.createAccounts();
        Probill__c prob = new Probill__c(Name = '123', Account__c = accnts[0].Id, Probill__c = '123abcdefs', AE_Rate_To__c = '005vcdhcdh22', Delivery_Start__c = datetime.now(), Shipper_ID__c = '123456', Consignee_ID__c = '654321');
        insert prob;
        Test.startTest();        
        UpdateAProbillsBatch updateAProbillsJob = new UpdateAProbillsBatch();
        Database.executeBatch(updateAProbillsJob); 
        Test.stopTest();
    }
}