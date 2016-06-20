trigger SubmittedforFinanceApproval on Credit_Application__c (after update)
{
    Set<String> leadIds = new Set<String>();
    Set<String> financeApprovedLeadIds = new Set<String>();
    Set<String> financeRejectedLeadIds = new Set<String>();
    
    for(Credit_Application__c creditApp : Trigger.new)
    {
        Credit_Application__c oldCreditApp = Trigger.oldMap.get(creditApp.Id);
        if(creditApp.Status__c == 'Submitted for Finance Approval' && oldCreditApp.Status__c != creditApp.Status__c)
        {
            leadIds.add(creditApp.Lead__c);
            try
            {
                SendEmailWithCreditApplicationRequest.sendEmail(creditApp.Id, UserInfo.getSessionId());
            }
            catch(Exception ex)
            {
                System.debug('###' + ex.getMessage());
            }
        }
        if(creditApp.Status__c == 'Finance Approved' && oldCreditApp.Status__c != creditApp.Status__c)
        {
            financeApprovedLeadIds.add(creditApp.Lead__c);
        }
        if(creditApp.Status__c == 'Finance Rejected' && oldCreditApp.Status__c != creditApp.Status__c)
        {
            financeRejectedLeadIds.add(creditApp.Lead__c);
        }
    }
    List<Lead> leads = new List<Lead>();
    
    for(Lead l : [select Credit_Application_Status__c, Email from Lead where Id in :leadIds])
    {
        l.Credit_Application_Status__c = 'Submitted for Finance Approval';
        leads.add(l);
    }
    
    if(leads.size() > 0)
    {
        update leads;
    }
    
    List<Lead> financeApprovedLeads = new List<Lead>();
    for(Lead l : [select Credit_Application_Status__c, Email from Lead where Id in :financeApprovedLeadIds])
    {
        l.Credit_Application_Status__c = 'Finance Approved';
        financeApprovedLeads.add(l);
    }
    if(financeApprovedLeads.size() > 0)
    {
        update financeApprovedLeads;
    }
    
    List<Lead> financeRejectedLeads = new List<Lead>();
    for(Lead l : [select Credit_Application_Status__c, Email from Lead where Id in :financeRejectedLeadIds])
    {
        l.Credit_Application_Status__c = 'Finance Rejected';
        financeRejectedLeads.add(l);
    }
    if(financeRejectedLeads.size() > 0)
    {
        update financeRejectedLeads;
    }
}