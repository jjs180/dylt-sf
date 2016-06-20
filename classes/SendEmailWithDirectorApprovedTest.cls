@isTest(seeAllData=true)
public class SendEmailWithDirectorApprovedTest
{
    @isTest
    public static void testSendEmail()
    {
        Account acc = [select Id from Account limit 1];
        
        Rate_Protection_Request__c rate = new Rate_Protection_Request__c(Account__c = acc.Id, Status__c = 'Director Approved', Probill__c = '123');
        
        insert rate;
        
        Rate_Protection_Request__c rate2 = new Rate_Protection_Request__c(Account__c = acc.Id, Probill__c = '123');
        
        insert rate2;
        
        rate2.Status__c = 'Director Approved';
        update rate2;
    }
}