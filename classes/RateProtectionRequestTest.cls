@isTest
public class RateProtectionRequestTest
{
    @isTest
    public static void testEdit()
    {
        Account acc = new Account();
	 	acc.Name = 'Lucian125668';
	 	acc.DYLT_Account__c = 'Lucian0367';
	 	insert acc;
        
        Probill__c pro = new Probill__c(Account__c = acc.Id, Name = 'Acme', Probill__c = '12321qaws');
        insert pro;
        
        Rate_Protection_Request__c rateProtection = new Rate_Protection_Request__c(Account__c = acc.Id, Probillx__c = pro.Id, Probill__c = 'Acme');
        insert rateProtection;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(rateProtection);
        RateProtectionRequestEditController rate = new RateProtectionRequestEditController(controller);
        
        rate.saveRateProtection();
        rate.saveAndSend();
        
        RateProtectionRequestVFEmailController rateProtection2 = new RateProtectionRequestVFEmailController(new ApexPages.StandardController(rateProtection));
    }
    
    @isTest
    public static void testNew()
    {
        Account acc = new Account();
	 	acc.Name = 'Lucian125668';
	 	acc.DYLT_Account__c = 'Lucian0367';
	 	insert acc;
	 	
        Probill__c pro = new Probill__c(Account__c = acc.Id, Name = 'Acme', Probill__c = '32321qaws');
        insert pro;
        
        Rate_Protection_Request__c rateProtection = new Rate_Protection_Request__c(Account__c = acc.Id, Probillx__c = pro.Id, Probill__c = 'Acme');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(rateProtection);
        RateProtectionRequestVFController rate = new RateProtectionRequestVFController(controller);
        
        rate.saveRateProtection();
        
        SendEmailWithRateProtection__c emailaddr = new SendEmailWithRateProtection__c();
        emailaddr.Email__c = 'lucian.ciobanu@deutoria.com';
        emailaddr.Name = 'Recipient';
        insert emailaddr;
        
        SendEmailWithRateProtectionRequest.doPost(rateProtection.Id);
    }
    
    @isTest
    public static void testNew2()
    {
        Account acc = new Account();
	 	acc.Name = 'Lucian125668';
	 	acc.DYLT_Account__c = 'Lucian0367';
	 	insert acc;
	 	
        Probill__c pro = new Probill__c(Account__c = acc.Id, Name = 'Acme', Probill__c = '32321qaws');
        insert pro;
        
        Rate_Protection_Request__c rateProtection = new Rate_Protection_Request__c(Account__c = acc.Id, Probillx__c = pro.Id, Probill__c = 'Acme');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(rateProtection);
        RateProtectionRequestVFController rate = new RateProtectionRequestVFController(controller);
        
        rate.saveAndSend();
    }
}