@isTest
private class CalculateShipperConsigneeRevenueTest {

	private static testMethod void test() {
	 
	    Test.startTest();
	    CalculateShipperConsigneeRevenue task = new CalculateShipperConsigneeRevenue();
        Database.executeBatch(task);
        Test.stopTest();
        
	}
	
	


}