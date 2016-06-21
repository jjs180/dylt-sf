/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for the NewTopShippersLost class
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
public class NewTopShippersLostTest {
    
    public static testMethod void testClass() {
    	
    	Account testAcct = new Account();
        testAcct.Name = 'Lucian238386';
        testAcct.DYLT_Account__c = 'Lucian2598';
        insert testAcct;
        
        Shipper_Consignee__c sc = new Shipper_Consignee__c();
        sc.Name = 'Lucian189182';
        sc.Name__c = 'Lucian189182';
        sc.Current_Month_Revenue__c = 1000;
        sc.State__c = 'CA';
        insert sc;
        
        Probill__c pb = new Probill__c();
        pb.Account__c = testAcct.Id;
        pb.Name = 'Lucian989124';
        pb.Probill__c = 'Lucian9809';
        pb.Paid_Amount__c = 1000;
        pb.Delivery_Start__c = Date.today();
        pb.Shipper__c = sc.Id;
        insert pb;
    	
    	Test.startTest();
    	
    	NewTopShippersLost.FilterDefinition filter = new NewTopShippersLost.FilterDefinition();
    	filter.column = 'ACCOUNT_ID';
    	filter.operator = '=';
    	filter.value = testAcct.Id;
    	
    	NewTopShippersLost.getTop5ShippersLost(new List<NewTopShippersLost.FilterDefinition> { filter });
    	
    	Test.stopTest();
    	
    }
    
}