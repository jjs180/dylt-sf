@isTest
private class CalculateShipperConsigneeRevenueTest {

	private static testMethod void test() {
	 
	 	Account a = new Account();
	 	a.Name = 'Lucian123268';
	 	a.DYLT_Account__c = 'Lucian0327';
	 	insert a;
	 
	 	Working_Day__c wd = new Working_Day__c();
	 	wd.Month__c = Date.today().month();
	 	wd.Year__c = Date.today().year();
	 	wd.TM_External_ID__c = 'Lucian352127';
	 	insert wd;
	 	
	 	Shipper_Consignee__c sc = new Shipper_Consignee__c();
	 	insert sc;
	 	
	 	Probill__c pb = new Probill__c();
	 	pb.consignee__c = sc.Id;
	 	pb.shipper__c = sc.Id;
	 	pb.delivery_start__c = Date.today();
	 	pb.Account__c = a.Id;
	 	pb.Probill__c = 'Lucian2757';
	 	pb.Rev_Curr_Total__c = 100;
	 	insert pb;
	 
	    Test.startTest();
	    CalculateShipperConsigneeRevenue task = new CalculateShipperConsigneeRevenue();
	    task.execute(null);
        Test.stopTest(); 
        
        sc = [SELECT Id, Current_Month_Revenue__c FROM Shipper_Consignee__c WHERE Id = :sc.Id];
        System.assertEquals(100, sc.Current_Month_Revenue__c);
        
	}
	
}