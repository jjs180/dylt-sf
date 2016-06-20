@istest
public class LeadAssigmentTriggerTest{
private static testMethod void testclass1 () {
//Create one lead record
Lead lead=new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Inquiry', PostalCode='90099');
//required fields
    try{
		insert Lead;        
    }catch(exception ex){}

}
}