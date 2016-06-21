/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for ConvertLead trigger
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author         Lucian Ciobanu   <lucian.ciobanu@deutoria.com>
* @created        2016-06-21
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
public class ConvertLeadTest {
    
    public static testMethod void testTrigger() {
    	
    	Account testAcct = new Account();
        testAcct.Name = 'Lucian233386';
        testAcct.DYLT_Account__c = 'Lucian2521';
        insert testAcct;
        
        Probill__c pb = new Probill__c();
        pb.Account__c = testAcct.Id;
        pb.Name = 'Lucian989844';
        pb.Probill__c = 'Lucian9899';
        pb.Paid_Amount__c = 1000;
        pb.Delivery_Start__c = Date.today();
        insert pb;
        
    	Lead l = new Lead();
    	l.LastName = 'Lucian218762';
    	l.Lead_Stage__c = '1 - Identification';
		l.Company = 'Test';//,Status='Inquiry', PostalCode='90099',TruckMate_Id__c = '1234512345');
		insert l;
		
		Credit_Application__c ca = new Credit_Application__c();
		ca.Lead__c = l.Id;
		ca.A_P_Contact_Name__c = 'Lucian198919';
		ca.Einvoice_Phone__c = '0000000000';
		insert ca;
		
		Rate_Protection_Request__c rpr = new Rate_Protection_Request__c();
		rpr.Lead__c = l.Id;
		rpr.Probill__c = pb.Id;
		insert rpr;
		
		Test.startTest();
		
		l.AutoConvert__c = true;
		l.AccountIdForLeadConversion__c = testAcct.Id;
		update l;
		
		Test.stopTest();
    	
    }
    
}