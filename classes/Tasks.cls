public class Tasks 
{
	public static final set<String> SUBJECTS_TORECORD = new Set<String>{'Visit','Meeting'};
	
	public static void run()
	{
		if(trigger.isExecuting)
		{
			if(trigger.isAfter)
			{
                if(trigger.isUpdate)
                {
                	afterUpdate((Map<Id,Task>)trigger.newMap, (Map<Id,Task>)trigger.oldMap);    
                }
				if(trigger.isInsert)
				{
					
					afterInsert((Map<Id,Task>)trigger.newMap);
				}
			}
			else
			{
				if(trigger.isInsert)
				{					
					beforeInsert((List<Task>)trigger.new);
				}
			}
		}
	}
	
	private static void beforeInsert(List<Task> newList)
	{
		for(Task t : newList)
		{
			if(t.Status == System.Label.Task_Status_Completed)
			{
				t.Completed_Date__c = date.today();	
			}
		}
	}
	
    private static void afterUpdate(Map<Id,Task> newMap, Map<Id,Task> oldMap){
        List<Task> toRecord = new List<Task>();
        for(Task t: newMap.values()){
            if(t.Status == System.Label.Task_Status_Completed && 
               SUBJECTS_TORECORD.contains(t.Subject) && 
               oldMap.get(t.Id).Status != System.Label.Task_Status_Completed)
            {
            	toRecord.add(t);	       
            }
        }
        toRecordsCompletedDate(toRecord);
    }
    
	private static void afterInsert(Map<Id,Task> newMap)
	{		
		List<Task> toRecord = new List<Task>();
		
		for(Task t : newMap.values())
		{			
			if(t.Status == System.Label.Task_Status_Completed && SUBJECTS_TORECORD.contains(t.Subject))
			{
                if(t.WhatId == NULL && t.WhoId != NULL && t.WhoId.getSobjectType() == Schema.Contact.SobjectType ){
                	toRecord.add(t); //Handle cases of Task on Contact and no WhatID
                }
                if(t.WhatId != NULL){ //Only run if a RelatedTo/WhatID exists
					if(t.WhatId.getSobjectType() == Schema.Account.SobjectType) //this Method fails when there is a NULL WhatID
					{
						toRecord.add(t);
					}
                }
			}
		}
        
        if(toRecord.size() > 0 ){
			toRecordsCompletedDate(toRecord);
        }
        
	}
	
	private static void toRecordsCompletedDate(List<Task> ts)
	{
		if(ts.isEmpty())
			return;
		
		Map<Id,Account> aMap = new Map<Id,Account>();
		
		for(Task t : ts)
		{
			//Account a = new Account(Id = t.WhatId);
            if(t.AccountId != NULL){
			Account a = new Account(Id = t.AccountId);
			
				if(t.Completed_Date__c != null && a.Id != NULL)
				{
					a.Last_Visit_Date__c = t.Completed_Date__c; // today(), only works for the second trigger fire after the WF			
					aMap.put(a.Id,a);
				}
            
            }
		}
        if(aMap.size() > 0){
            try{
				update aMap.values();
            }
            catch(Exception e){
                system.debug('---Task update error:  ' + e.getMessage());
            }
        }
	}
}