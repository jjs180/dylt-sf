@isTest(seeAllData=true)
public class MonthlyShipmentControllerTest
{
    @isTest
    public static void testProbill()
    {
        Account acc = [select Id from Account limit 1];
        Probill__c probill = new Probill__c(Account__c = acc.Id, Probill__c = '123qwds');
        insert probill;
        
        MonthlyShipmentController.getMonthlyShipment(acc.Id, '2015', '2');
        MontlyRevenueController.getQuarterRevenues(acc.Id, '2015', '2');
    }
}