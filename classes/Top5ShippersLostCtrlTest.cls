/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for the Top5ShippersLostCtrl class
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
public class Top5ShippersLostCtrlTest {
    
    public static testMethod void testClass() {
    
    	Account testAcct = new Account();
        testAcct.Name = 'Lucian268386';
        testAcct.DYLT_Account__c = 'Lucian5398';
        insert testAcct;
        
        Shipper_Consignee__c sc = new Shipper_Consignee__c();
        sc.Name = 'Lucian183482';
        sc.Name__c = 'Lucian143182';
        sc.Current_Month_Revenue__c = 1000;
        sc.State__c = 'CA';
        insert sc;
        
        Probill__c pb = new Probill__c();
        pb.Account__c = testAcct.Id;
        pb.Name = 'Lucian934124';
        pb.Probill__c = 'Lucian3409';
        pb.Paid_Amount__c = 1000;
        pb.Delivery_Start__c = Date.today();
        pb.Shipper__c = sc.Id;
        insert pb;
        
    	Test.startTest();
    	
    	Top5ShippersLostCtrl.FilterDefinition filter = new Top5ShippersLostCtrl.FilterDefinition();
    	filter.column = 'ACCOUNT_ID';
    	filter.operator = '=';
    	filter.value = testAcct.Id;
    	
    	Top5ShippersLostCtrl.getTop5ShippersLost(new List<Top5ShippersLostCtrl.FilterDefinition> { filter }, 'Short Term');
    	
    	Test.stopTest();
    	
    }
    
}