/*  mmott
	I removed the RestResource annottation and the HttpPost annotation
	because they are not required for the desired funtionality
	
	I added the Future annotation because triggers can not send email
	directly.  Instead we have to use a future method.

*/
//RestResource(urlMapping='/SendEmailWithRateProtectionRequest/*')
global class SendEmailWithRateProtectionRequest
{
	
    //HttpPost
    @future(callout=true)
    global static void doPost(String Id)
    {
        Blob b = Blob.valueOf('Acme Test');
        if(!Test.isRunningTest())
        {
            PageReference ref = Page.RateProtectionRequestEmail;
            ref.getParameters().put('id', Id);
            
            b = ref.getContentAsPDF();
        }
        Rate_Protection_Request__c rateRequest = [select Id, Name, Approver_s_Name__c, Owner.Name from Rate_Protection_Request__c where Id = :Id];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();  
        efa1.setFileName('Rate Protection Request.pdf');  
        efa1.setBody(b);
        List<SendEmailWithRateProtection__c> sendEmailWith = [select Email__c from SendEmailWithRateProtection__c where Name = 'Recipient'];
        //String emailAddress = 'mpandit@relationedge.com';
        String emailAddress;
        
        if(sendEmailWith.size() > 0)
        {
            emailAddress = sendEmailWith[0].Email__c;
        }
        
        String[] addresses = new String[]{emailAddress};
                
        email.setToAddresses(addresses); 
        
       
         
        Contact con = new Contact(LastName = 'Acme', Email = emailAddress);
        insert con;
        
        EmailTemplate emailTemplateInstance = [select Id from EmailTemplate where Name = 'Rate Protection Approval-Pricing Department'];
        //email.setSubject('Rate Protection Request');  
        email.setTemplateId(emailTemplateInstance.Id);
        email.setSenderDisplayName(rateRequest.Approver_s_Name__c);
        email.setTargetObjectId(con.Id);
        email.setWhatId(Id);
        email.setSaveAsActivity(false);
        //email.setPlainTextBody('The Rate Protection Request has been generated, please check the attached. Thanks.');  
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});  
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        
        
        delete con;
    }
}