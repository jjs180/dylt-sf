@isTest
public class SendEmailWithDirectorApprovedTest
{
    @isTest
    public static void testSendEmail()
    {
        SendEmailWithRateProtection__c emailaddr = new SendEmailWithRateProtection__c();
        emailaddr.Email__c = 'lucian.ciobanu@deutoria.com';
        emailaddr.Name = 'Recipient';
        insert emailaddr;
        
        Account acc = new Account();
	 	acc.Name = 'Lucian125668';
	 	acc.DYLT_Account__c = 'Lucian0367';
	 	insert acc;
        
        Rate_Protection_Request__c rate = new Rate_Protection_Request__c(Account__c = acc.Id, Status__c = 'Director Approved', Probill__c = '123');
        
        insert rate;
        
        Rate_Protection_Request__c rate2 = new Rate_Protection_Request__c(Account__c = acc.Id, Probill__c = '123');
        
        insert rate2;
        
        rate2.Status__c = 'Director Approved';
        update rate2;
    }
}