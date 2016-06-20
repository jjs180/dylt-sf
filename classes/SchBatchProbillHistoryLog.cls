global with sharing class SchBatchProbillHistoryLog  implements Schedulable, Database.Batchable<sObject>, Database.Stateful
{
    /*
        SchBatchProbillHistoryLog m = new SchBatchProbillHistoryLog();      
        String jobID = system.schedule('Account Won History Nightly Sync', SchBatchProbillHistoryLog.sched, m);
    */
    global Map<Id,List<Probill__c>> LastAcctProbillsMapSet; // to track the last batch that's processed for any cutoff list
    
    public static final String sched = '0 00 00 * * ?';  //Every Day at Midnight 
    
   global void execute(SchedulableContext sc) 
   {
      SchBatchProbillHistoryLog b1 = new SchBatchProbillHistoryLog();
      ID batchprocessid = Database.executeBatch(b1,400);  
   }

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator('SELECT Id, Days_Since_Last_Probill__c, Account__c, Account__r.OwnerId, Account__r.Owner.Manager.Name, Account__r.Monthly_Potential_Revenue__c, Account__r.Monthly_Committed_Revenue__c, Account__r.First_Shipment__c, Account__r.Dylt_Account__c, Delivery_Start_2__c, Delivery_Start__c FROM Probill__c WHERE Days_Since_Last_Probill__c = null ORDER BY Account__c, Delivery_Start__c');
   }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope)
   {
    List<Probill__c> probills = (List<Probill__c>)scope;
        List<Account_Won_History__c> toLog = new List<Account_Won_History__c>();
        
        //updateProbillSinceLastPickup(probills);
        
    // get account-probills for the input probills, so we can check for 
        Map<Id,List<Probill__c>> acctProbillsMap = new Map<Id,List<Probill__c>>();
    for(Probill__c pb : probills)
        {
            if(!acctProbillsMap.containskey(pb.Account__c))
                acctProbillsMap.put(pb.Account__c, new List<Probill__c>());
                
            acctProbillsMap.get(pb.Account__c).add(pb);
        }   
    
      // go through each probill and calculate the days
        for(Id acctId : acctProbillsMap.keyset())
        {
            List<Probill__c> sortedList = acctProbillsMap.get(acctId);
            
            for(Integer i = 0; i < sortedList.size(); i++)
            {
                Probill__c thisPb = sortedList[i];
                
                if(i == 0) // the first one or the only probill
                {
                    // check if it's the first one or if it's cutoff from the last batch
                    if(LastAcctProbillsMapSet == null)
                    {
                        thisPb.Days_Since_Last_Probill__c = 0;
                    }
                    else
                    {
                        if(LastAcctProbillsMapSet.containskey(acctId)) // found in the last batch
                        {
                            List<Probill__c> lastBatSortedList = LastAcctProbillsMapSet.get(acctId);
                            Probill__c lastPB = lastBatSortedList[lastBatSortedList.size()-1]; // last one in the last batch
                            thisPb.Days_Since_Last_Probill__c = Math.abs(thisPb.Delivery_Start__c.date().daysbetween(lastPB.Delivery_Start__c.date()));
                        }
                        else
                        {
                            thisPb.Days_Since_Last_Probill__c = 0;
                        }
                    }
                }
                else
                {               
                    Probill__c lastPB = sortedList[i-1];
                    thisPb.Days_Since_Last_Probill__c = Math.abs(thisPb.Delivery_Start__c.date().daysbetween(lastPB.Delivery_Start__c.date()));
                }
                
                if(thisPb.Days_Since_Last_Probill__c > 180)
                {
                    Account_Won_History__c awh = new Account_Won_History__c();
                    awh.Account_Name__c = thisPb.Account__c;
                    //awh.OwnerId = thisPb.Account__r.OwnerId;
                    awh.Date_Won__c = thisPb.Delivery_Start_2__c == null ? null : thisPb.Delivery_Start_2__c.date();
                    awh.Director_text__c = thisPb.Account__r.Owner.Manager.Name;
                    awh.DYLT_Account__c = thisPb.Account__r.Dylt_Account__c;
                    awh.First_Probill_Pickup_Date__c = thisPb.Account__r.First_Shipment__c;
                    awh.Monthly_Committed_Revenue__c = thisPb.Account__r.Monthly_Committed_Revenue__c;
                    awh.Monthly_Potential_Revenue__c = thisPb.Account__r.Monthly_Potential_Revenue__c;
                    
                    toLog.add(awh);
                }
            }
        }       
        
        update probills;
        
        if(!toLog.isEmpty())
            insert toLog;
            
        LastAcctProbillsMapSet = acctProbillsMap; // renew for the next batch
   }

    global void finish(Database.BatchableContext BC)
    {
   }
}