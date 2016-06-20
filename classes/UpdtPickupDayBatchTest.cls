@isTest
private class UpdtPickupDayBatchTest {

    static testMethod void testUpdatePickupDay() {
         // Setup test data
        
        Account accnt = new Account( name='test account', Date_Lost__c = Date.today(), DYLT_Account__c = '12345', BillingStreet='121 street',BillingCity='test city1',BillingState='California',BillingPostalCode='12356' );
        insert accnt;
        
        // add a previous month probill
        Date currentDate = Date.today();
        
        Probill__c probill1 = new Probill__c( Delivery_Start__c = currentDate, Rev_Curr_Total__c = 1000, name='pb1', account__c = accnt.id, probill__c = '123453' );
        insert probill1;
        
 		Test.startTest();
        	UpdtPickupDayBatch task = new UpdtPickupDayBatch();
        	Database.executeBatch(task);
		Test.stopTest();
		
		Probill__c updatedProbill = [Select Pickup_Day__c from Probill__c Where id = :probill1.id];
				
		System.assertEquals( Date.today(), updatedProbill.Pickup_Day__c );
        
        
        
    }
}