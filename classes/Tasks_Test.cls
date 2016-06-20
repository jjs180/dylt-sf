@isTest
public class Tasks_Test 
{
	@testsetup
	private static void datasetup()
	{
		List<Account> accnts = TestUtilities.createAccounts();
        List<Contact> conts = TestUtilities.createContact(accnts[0].Id);
		List<Task> taskList = TestUtilities.createTasks(accnts);
        List<Task> whotaskList = TestUtilities.createWhoTasks(conts);
	}
	
	@isTest
	private static void testTaskCompletion()
	{
		List<Task> taskList = [SELECT WhatId, Status, Completed_Date__c, Subject
											/*,TYPEOF What
							        			WHEN Account THEN Last_Visit_Date__c        
						    				END*/
							     FROM Task 
								  WHERE Status != :System.Label.Task_Status_Completed AND 
								  		  Completed_Date__c = null AND
								  		  What.Type IN ('Account')
								  		  LIMIT 10];
		
		Set<Id> whatIds = new Set<id>();		
		
		for(Task t : taskList)
		{
			whatIds.add(t.WhatId);
		}

		List<Task> whotaskList = [SELECT WhoId, AccountId, Status, Completed_Date__c, Subject
							     FROM Task 
								  WHERE Status != :System.Label.Task_Status_Completed AND 
								  		  Completed_Date__c = null AND
								  		  Who.Type IN ('Contact')
								  		  LIMIT 10];	
		
		for(Task t : whotaskList)
		{
			whatIds.add(t.AccountId);
		}        
        
        
		// account map before task updates
		Map<Id,Account> accntMap = new Map<Id,Account>([SELECT Id, Last_Visit_Date__c FROM Account WHERE Id IN :whatIds]);
		
		Test.startTest();
		
		/* test 1 - update existing task and verify the associated accounts got updated */
		for(Task t : taskList)
		{			
			t.Subject = 'Visit';
			t.Status = System.Label.Task_Status_Completed;			
		}
		
		update taskList;
		
        for(Task t : whotaskList){
			t.Subject = 'Visit';
			t.Status = System.Label.Task_Status_Completed;            
        }
        
        update whotaskList;
        
		Map<Id,Account> accntMapPost = new Map<Id,Account>([SELECT Id, Last_Visit_Date__c FROM Account WHERE Id IN :whatIds]);
		for(Account a : accntMapPost.values())
		{
			Account preA = accntMap.get(a.Id);
			system.assertNotEquals(preA.Last_Visit_Date__c, a.Last_Visit_Date__c); // CHECK POST: account Last_Visit_Date__c HAS been changed.
		}	
		/* test 1 end */
		
		/* test 2 - create a new set of completed visit tasks and verify associated account last_visit_date__c is updated */
		// create a new set of tasks for Visit
		List<Task> newCompTasks = new List<Task>();
		
		for(Task t : taskList)
		{
			Task nt = t.clone(false,true);
			nt.Subject = 'Visit';
			nt.Status = System.Label.Task_Status_Completed;
			nt.Completed_Date__c = Date.today();
			newCompTasks.add(nt);
		}	
		
		insert newCompTasks;	

		List<Task> newCompWhoTasks = new List<Task>();
		
		for(Task t : whotaskList)
		{
			Task nt = t.clone(false,true);
			nt.Subject = 'Visit';
			nt.Status = System.Label.Task_Status_Completed;
			nt.Completed_Date__c = Date.today();
			newCompTasks.add(nt);
		}	
		
		insert newCompWhoTasks;        
		/* test 2 */	
		
		Test.stopTest();
		
		/* test 2 */
		taskList = [SELECT WhatId, Status, Completed_Date__c, Subject, CreatedDate, LastModifiedDate FROM Task WHERE Id IN :newCompTasks];
		accntMapPost = new Map<Id,Account>([SELECT Id, Last_Visit_Date__c FROM Account WHERE Id IN :whatIds]);
		
		for(Task t : taskList)
		{			
			Account a = accntMapPost.get(t.WhatId);
			
			system.assertEquals(System.Label.Task_Status_Completed, t.Status);
			system.assertNotEquals(null, t.Completed_Date__c); // CHECK POST: task Completed_Date__c has been changed.
			
			if(Tasks.SUBJECTS_TORECORD.contains(t.Subject))
				system.assertEquals(t.Completed_Date__c, a.Last_Visit_Date__c); // CHECK POST: task Completed_Date__c and associated account Last_Visit_Date__c are the same.
		}
		
		/* test 3 Subject = meeting */
		taskList = new List<Task>();
		
		for(Account a : accntMapPost.values())
		{
			a.Last_Visit_Date__c = null;
			
			Task nt = new Task();
			nt.Subject = 'Meeting';
			nt.Status = System.Label.Task_Status_Completed;
			nt.Completed_Date__c = Date.today();
			nt.WhatId = a.Id;
			taskList.add(nt);
		}
		
		update accntMapPost.values();
		insert taskList;
		
		accntMapPost = new Map<Id,Account>([SELECT Id, Last_Visit_Date__c FROM Account WHERE Id IN :accntMapPost.keyset()]);
		
		for(Task t : taskList)
		{
			Account a = accntMapPost.get(t.WhatId);
			if(Tasks.SUBJECTS_TORECORD.contains(t.Subject))
				system.assertEquals(t.Completed_Date__c, a.Last_Visit_Date__c); // CHECK POST: task Completed_Date__c and associated account Last_Visit_Date__c are the same.
		}
		
		/* test 3 */
		
		/* test 2 end*/
	}
}