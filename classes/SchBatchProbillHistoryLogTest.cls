/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for the SchBatchProbillHistoryLog class
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
public class SchBatchProbillHistoryLogTest {
    
    public static testMethod void testClass() {
    	
    	Account testAcct = new Account();
        testAcct.Name = 'Lucian129873';
        testAcct.DYLT_Account__c = 'Lucian1123';
        insert testAcct;
        
        Probill__c pb = new Probill__c();
        pb.Account__c = testAcct.Id;
        pb.Name = 'Lucian924764';
        pb.Probill__c = 'Lucian2209';
        pb.Paid_Amount__c = 1000;
        pb.Delivery_Start__c = Date.today().addDays(365);
        
        Probill__c pb2 = new Probill__c();
        pb2.Account__c = testAcct.Id;
        pb2.Name = 'Lucian924765';
        pb2.Probill__c = 'Lucian2200';
        pb2.Paid_Amount__c = 1000;
        pb2.Delivery_Start__c = Date.today().addDays(-365);
        
        insert new List<Probill__c> { pb, pb2 };
        
        pb.Days_Since_Last_Probill__c = null;
        
        pb2.Days_Since_Last_Probill__c = null;
        
        update new List<Probill__c> { pb, pb2 };
        
        Test.startTest();
    	
    	SchBatchProbillHistoryLog cls = new SchBatchProbillHistoryLog();
    	cls.execute(null);
    	
    	Test.stopTest();
    	
    }
    
}