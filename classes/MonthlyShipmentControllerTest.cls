@isTest
public class MonthlyShipmentControllerTest
{
    @isTest
    public static void testProbill()
    {
        Account acc = new Account();
	 	acc.Name = 'Lucian125668';
	 	acc.DYLT_Account__c = 'Lucian0367';
	 	insert acc;
	 	
        Probill__c probill = new Probill__c(Account__c = acc.Id, Probill__c = '123qwds');
        insert probill;
        
        MonthlyShipmentController.getMonthlyShipment(acc.Id, '2015', '2');
        MontlyRevenueController.getQuarterRevenues(acc.Id, '2015', '2');
    }
}