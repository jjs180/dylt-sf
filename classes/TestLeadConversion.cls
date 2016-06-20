@isTest
public class TestLeadConversion {

 
  @isTest
  private static void testBatch()
  {
    Test.startTest();
    
      
    Account acct = new Account();
      acct.DYLT_Account__c = '9346289200';
      acct.name = 'Lucian131687';
      
      Lead thelead=new Lead(LastName='Doe',email = 'test@test.com',FirstName='John',Company='Test',Status='Inquiry', PostalCode='90099',TruckMate_Id__c = '1234512345');
      //thelead.firstname = 'test';
      //thelead.lastname = 'test';
      //thelead.email = 'test@test.com';
      //thelead.TruckMate_Id__c = '1234512345';
      insert thelead;
      
      Lead_Contact__c lc = new Lead_Contact__c();
      lc.Name = 'Test';
      lc.email__c = 'test@test.com';
      lc.Lead__c = thelead.Id;
      insert lc;
      
      Rate_Protection_Request__c r = new Rate_Protection_Request__c();
      r.Probill__c = 'test';
      r.Lead__c = thelead.Id;
      insert r;
          
      insert acct;
    
    Test.stopTest();
    
    
  }


}