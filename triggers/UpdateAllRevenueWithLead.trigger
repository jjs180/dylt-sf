trigger UpdateAllRevenueWithLead on Account (before update)
{
    Map<String, Decimal> accountMap = new Map<String, Decimal>();
    
    for(Account acc : Trigger.new)
    {
        Account oldAcc = Trigger.oldMap.get(acc.Id);
        if(acc.DYLT_Account__c != null && acc.All_Revenue__c != oldAcc.All_Revenue__c)
        {
            accountMap.put(acc.DYLT_Account__c, acc.All_Revenue__c);
        }
    }
    
    List<Lead> leads = new List<Lead>();
    for(Lead l : [Select Id, TruckMate_Id__c, All_Revenue__c from Lead Where IsConverted = false and TruckMate_Id__c in :accountMap.keySet()])
    {
        if(accountMap.containsKey(l.TruckMate_Id__c))
        {
            l.All_Revenue__c = accountMap.get(l.TruckMate_Id__c);
            leads.add(l);
        }
    }
    if(leads.size() > 0)
    {
        update leads;
    }
    
}