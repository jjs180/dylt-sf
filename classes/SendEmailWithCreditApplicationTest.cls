@isTest(seeAllData = true)
public class SendEmailWithCreditApplicationTest
{
    @isTest
    public static void testSendEmail()
    {
        //Lead lead = [select Id from Lead where IsConverted = false limit 1];
        Lead lead = new Lead(LastName = 'Test', Company = 'Acme', Email='test@abc.com');
        insert lead;
        
        Credit_Application__c creditApp = new Credit_Application__c(Lead__c = lead.Id, Status__c = 'Draft', A_P_Contact_Name__c = '12312', Einvoice_Phone__c='321123');
        
        insert creditApp;
        
        creditApp.Status__c = 'Submitted for Finance Approval';
        
        update creditApp;
        
        creditApp.Status__c = 'Finance Approved';
        
        update creditApp;
        
        SendEmailWithCreditApplication.doPost(creditApp.Id);
    }
}