/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for the Top5ShippersLostController class
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
public class Top5ShippersLostControllerTest {
    
    public static testMethod void testClass() {
    	
    	Account testAcct = new Account();
        testAcct.Name = 'Lucian231286';
        testAcct.DYLT_Account__c = 'Lucian2549';
        testAcct.Date_Lost__c = Date.today();
        insert testAcct;
        
        Shipper_Consignee__c sc = new Shipper_Consignee__c();
        sc.Name = 'Lucian155652';
        sc.Name__c = 'Lucian189552';
        sc.Current_Month_Revenue__c = 1000;
        sc.State__c = 'CA';
        insert sc;
        
        Probill__c pb = new Probill__c();
        pb.Account__c = testAcct.Id;
        pb.Name = 'Lucian989155';
        pb.Probill__c = 'Lucian9855';
        pb.Paid_Amount__c = 1000;
        pb.Delivery_Start__c = Date.today();
        pb.Shipper__c = sc.Id;
        pb.Shipper_Name__c = 'Lucian102749';
        insert pb;
        
    	Test.startTest();
    	
    	Top5ShippersLostController.getTop5Shippers('' + testAcct.Id + ',THIS_MONTH');
    	
    	Test.stopTest();
    	
    }
    
}