trigger SendEmailWithDirectorApproved on Rate_Protection_Request__c (after insert, after update)
{
    for(Rate_Protection_Request__c rateProtection : Trigger.new)
    {
        if(Trigger.isInsert)
        {
            if(rateProtection.Direct_Approved_Flag__c == True)
            {
                SendEmailWithRequest.sendEmail(rateProtection.Id, UserInfo.getSessionId());
            }
        }
        else
        {
            Rate_Protection_Request__c oldRateProtection = Trigger.oldMap.get(rateProtection.Id);
         
         	/*  mmott 
         		I temporarily commented out this code to bypass filter criteria and run
         		the trigger any time an update is made to the Rate_Protection_Request object
         	*/
           // if(rateProtection.Status__c == 'Director Approved' && rateProtection.Status__c != oldRateProtection.Status__c)
            //{
              //  SendEmailWithRequest.sendEmail(rateProtection.Id, UserInfo.getSessionId());
           // }
 
           /*  mmott
           		I bypassed the RestResource call out and called the method directly
           */
           
           if(rateProtection.Status__c == 'Director Approved' && rateProtection.Status__c != oldRateProtection.Status__c) {
     	      SendEmailWithRateProtectionRequest.doPost( rateProtection.Id);
           }   
        }
    }
}