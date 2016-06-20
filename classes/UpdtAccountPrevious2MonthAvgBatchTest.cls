@isTest
private class UpdtAccountPrevious2MonthAvgBatchTest {

    static testMethod void testCalculation() {
        // test that the calculation is correct
        
        // Setup test data
        
        Account accnt = new Account( name='test account', Date_Lost__c = Date.today(), DYLT_Account__c = '12345', BillingStreet='121 street',BillingCity='test city1',BillingState='California',BillingPostalCode='12356' );
        insert accnt;
        
        // add a previous month probill
        Date currentDate = Date.today();
        Date lastMonthDate = currentDate.addMonths(-1);
        
        Probill__c probill1 = new Probill__c( Delivery_Start__c = lastMonthDate, Rev_Curr_Total__c = 1000, name='pb1', account__c = accnt.id, probill__c = '123453' );
        insert probill1;
        
 		Test.startTest();
        	UpdtAccountPrevious2MonthAvgBatch task = new UpdtAccountPrevious2MonthAvgBatch();
        	Database.executeBatch(task);
		Test.stopTest();
		
		Account updatedAccount = [Select Id, Previous_2_Months_Avg__c From Account Where id = :accnt.id];
		
		System.assertEquals( 1000, updatedAccount.Previous_2_Months_Avg__c );		
		
        
    }
    
    static testMethod void testGovernorLimits() {
    	// Setup test data
        
        Date todaysDate = Date.today();
        Account accnt = new Account( name='test account', Date_Lost__c = todaysDate, DYLT_Account__c = '12345', BillingStreet='121 street',BillingCity='test city1',BillingState='California',BillingPostalCode='12356' );
    	insert accnt;
    	
    	Date pickupDate = todaysDate.addMonths(-1);
    	
    	// add  probills
    	List<Probill__c> probillsToInsert = new List<Probill__c>();
    	
    	for ( Integer i=0; i<500; i++ ) {
    		Probill__c probill = new Probill__c( Delivery_Start__c = pickupDate, Rev_Curr_Total__c = 1, name='pb'+i, account__c = accnt.id, probill__c = '1' + i );
    		probillsToInsert.add( probill);	
    	}
    	insert probillsToInsert;
    	
    	Test.startTest();
    		UpdtAccountPrevious2MonthAvgBatch task = new UpdtAccountPrevious2MonthAvgBatch();
        	Database.executeBatch(task);
    	Test.stopTest();
    	
    	// make sure the Previous_2_Months_Avg__c = 500
    	Account accntUpdated = [Select Previous_2_Months_Avg__c From Account Where id = :accnt.id Limit 1];
    	
    	System.assertEquals(accntUpdated.Previous_2_Months_Avg__c, 500);
    	
    	
    	
    	
    	
    	
    	
    	
    }
}