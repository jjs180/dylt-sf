public class Probills 
{
	public static void run()
	{
		if(trigger.isExecuting)
		{
			if(trigger.isAfter)
			{
				if(trigger.isInsert)
				{
					afterInsert((Map<Id,Probill__c>)trigger.newMap);
				}
			}
			/*else
			{
				if(trigger.isInsert)
				{
				 	beforeInsert((List<Probill__c>)trigger.new);
				}
				else if(trigger.isUpdate)
				{
					beforeUpdate((Map<Id,Probill__c>)trigger.newMap, (Map<Id,Probill__c>)trigger.oldMap);
				}
			}*/
		}
	}	
	
	private static void afterInsert(Map<Id,Probill__c> newMap)
	{
		updateAccount(newMap.values());
	}
	
	/*private static void beforeInsert(List<Probill__c> newList)
	{
		updateProbillSinceLastPickup(newList);
	}
	
	private static void beforeUpdate(Map<Id,Probill__c> newMap, Map<Id,Probill__c> oldMap)
	{
		List<Probill__c> toUpdate = new List<Probill__c>();
		
		for(Probill__c pb : newMap.values())
		{
			if(pb.Days_Since_Last_Probill__c == null)
				toUpdate.add(pb);
		}
		
		updateProbillSinceLastPickup(toUpdate);
	}*/
	
	private static void updateAccount(List<Probill__c> pbs)
	{
		Map<Id,Account> aMap = new Map<Id,Account>();
		
		for(Probill__c pb : pbs)
		{
			Account a = new Account(Id = pb.Account__c);
			a.Last_Probill_Date__c = pb.CreatedDate.date();
			
			aMap.put(a.Id,a);
		}
		
		update aMap.values();
	}
	
	/*
	private static void updateProbillSinceLastPickup(List<Probill__c> pbs)
	{
		if(pbs.isEmpty())
			return;
		
		Set<Id> accIds = new Set<Id>();	
		List<Account_Won_History__c> toLog = new List<Account_Won_History__c>();
		
		for(Probill__c pb : pbs)
		{
			accIds.add(pb.Account__c);
		}		
		
		// get account-probills for the input probills, so we can check for 
		Map<Id,List<Probill__c>> acctProbillsMap = new Map<Id,List<Probill__c>>();
		List<Probill__c> allAcctPBs = [SELECT Id, Days_Since_Last_Probill__c, Account__c, Delivery_Start__c 
												 FROM Probill__c 
												 WHERE Account__c IN :accIds AND
												 		 Delivery_Start__c = LAST_N_YEARS:2 ORDER BY Account__c, Delivery_Start__c];
		
		for(Probill__c pb : allAcctPBs)
		{
			if(!acctProbillsMap.containskey(pb.Account__c))
				acctProbillsMap.put(pb.Account__c, new List<Probill__c>());
				
			acctProbillsMap.get(pb.Account__c).add(pb);
		}
		
		// go through each probill and calculate the days
		for(Probill__c pb : pbs)
		{
			Map<Id,Probill__c> pbForAcctMap = new Map<Id,Probill__c>(acctProbillsMap.get(pb.Account__c));
			
			if(!acctProbillsMap.containskey(pb.Account__c)) // the first probill ever
			{
				pb.Days_Since_Last_Probill__c = 0;
			}
			else
			{
				List<Probill__c> sortedList = acctProbillsMap.get(pb.Account__c);
				
				if(pbForAcctMap.containskey(pb.Id)) // exisiting
				{				
					for(Integer i = 0; i < sortedList.size(); i++) // loop in order
					{
						if(pb.Id == sortedList[i].Id)
						{
							pb.Days_Since_Last_Probill__c = sortedList[i-1].Delivery_Start__c.date().daysbetween(pb.Delivery_Start__c.date());
							break;
						}
					}
				}
				else // new
				{
					// only need to get the last one
					Probill__c lastPB = sortedList[sortedList.size()-1];
					pb.Days_Since_Last_Probill__c = lastPB.Delivery_Start__c.date().daysbetween(pb.Delivery_Start__c.date());
				}
			}
			
			if(pb.Days_Since_Last_Probill__c > 180)
				toLog.add(new Account_Won_History__c(Account_Name__c = pb.Account__c, Date_Won__c = pb.Delivery_Start__c.date()));
		}		
		
		if(!toLog.isEmpty())
			insert toLog;
	}*/
}