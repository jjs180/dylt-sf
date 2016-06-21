/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for the SendEmailWithRequest class
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
public class SendEmailWithRequestTest {
    
    public static testMethod void testClass() {
    	
    	Test.startTest();
    	
    	SendEmailWithRequest.sendEmail(null, null);
    	
    	Test.stopTest();
    	
    }
    
}