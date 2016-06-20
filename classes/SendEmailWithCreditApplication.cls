@RestResource(urlMapping='/SendEmailWithCreditApplication/*')
global class SendEmailWithCreditApplication
{
    @HttpPost
    global static void doPost(String Id)
    {
        Credit_Application__c creditApp = [select Name, Lead__c from Credit_Application__c where Id = :Id];
        Blob b = Blob.valueOf('Acme Test');
        if(!Test.isRunningTest())
        {
            PageReference ref = Page.ApplicationForCreditPDF2;
            ref.getParameters().put('id', Id);
            
            b = ref.getContentAsPDF();
        }
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();  
        efa1.setFileName(creditApp.Name + ' Credit Application ' + Date.today().format() + '.pdf');  
        efa1.setBody(b);
        
        EmailTemplate emailTemplateInstance = [select Id from EmailTemplate where Name = 'Notification Email to Customer'];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        email.setTemplateId(emailTemplateInstance.Id);
        email.setTargetObjectId(creditApp.Lead__c);
        email.setWhatId(Id);
        email.setSaveAsActivity(false);
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}