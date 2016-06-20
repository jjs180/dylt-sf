@isTest
public class Probills_Test 
{
	@testsetup
	private static void datasetup()
	{
		List<Account> accnts = TestUtilities.createAccounts();
		List<Probill__c> probills = TestUtilities.createProbills(accnts);		
	}
	
	@isTest
	private static void testProbillCreation()
	{
		Set<Id> accntId = new Set<Id>();
		List<Probill__c> probills = [SELECT Id, Account__c, CreatedDate FROM Probill__c LIMIT 10];
		
		for(Probill__c pb : probills)
		{
			accntId.add(pb.Account__c);
		}
		
		Map<Id,Account> accntMap = new Map<Id,Account>([SELECT Id, Last_Probill_Date__c FROM Account WHERE Id IN :accntId LIMIT 10]);
		
		for(Probill__c pb : probills)
		{
			Account a = accntMap.get(pb.Account__c);
			
			system.assertEquals(pb.CreatedDate.date(), a.Last_Probill_Date__c); // probill CreatedDate and associated account Last_Probill_Date__c are the same.
		}		
	}
}