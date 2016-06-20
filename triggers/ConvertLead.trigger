trigger ConvertLead on Lead (after update, before insert) {
     LeadStatus convertStatus = [
          select MasterLabel
          from LeadStatus
          where IsConverted = true
          limit 1
     ];
     List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
     
                     
     if (Trigger.isUpdate) {
         List<Contact> consForInsert= new List<Contact>();
         List<Account> acctsForUpdate= new List<Account>();
         List<Credit_Application__c> appsForUpdate = new List<Credit_Application__c>();
         List<Rate_Protection_Request__c> rpsForUpdate = new List<Rate_Protection_Request__c>();
         
         for (Lead lead: Trigger.new) {
            
            Lead oldLead = Trigger.oldMap.get(lead.Id);
            if (lead.IsConverted) {
                System.debug('Convert Lead Id  is: ' + lead.Id);
               //get related contacts
               List<Lead_Contact__c> cons = [Select Id, Name, First_Name__c, Email__c, title__c, phone__c From Lead_Contact__c Where Lead__c =:lead.Id];
                for (Lead_Contact__c con : cons) {
                    System.debug('Related COntact: ' + con.Id);
                    Contact newcon =  new Contact();
                    newcon.FirstName = con.First_Name__c;
                    newcon.LastName = con.Name;
                    newcon.EMail= con.EMail__c;
                    newcon.Phone= con.Phone__c;
                    newcon.Title= con.Title__c;
                    newcon.AccountId = lead.convertedAccountId;
                    consForInsert.add(newcon);
                } 
                
                //get Credit Applications
                List<Credit_Application__c> capps = [Select id, Lead__c, Account__c from Credit_Application__c Where Lead__c =:lead.Id];
                for (Credit_Application__c capp : capps) {
                    System.debug('Credit Application: ' + capp.Id);
                    capp.Account__c = lead.convertedAccountId;
                    appsForUpdate.add(capp);
                }
                
                //get Rate Protection Requests
                List<Rate_Protection_Request__c> rpreqs = [Select id, Lead__c, Account__c from Rate_Protection_Request__c Where Lead__c =:lead.Id];
                for (Rate_Protection_Request__c rpreq : rpreqs) {
                    System.debug('Rate Protection Request: ' + rpreq.Id);
                    rpreq.Account__c = lead.convertedAccountId;
                    rpsForUpdate.add(rpreq);
                }
                
                
            } else if (Lead.AutoConvert__c == true && oldLead.AutoConvert__c == false ){   
                if (!String.isEmpty(lead.AccountIdForLeadConversion__c)) {
                    //convert the lead
                    Database.LeadConvert lc = new Database.LeadConvert();
                    String oppName = lead.Name;
                    lc.setLeadId(lead.Id);
                    lc.setAccountId(Id.valueOf(lead.AccountIdForLeadConversion__c));
                    lc.setDoNotCreateOpportunity(True);
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    leadConverts.add(lc);
                    
                    Account acct = [Select Id, Converted_Lead__c, Converted_Lead_Created_Date__c, Lead_Conversion_Date__c From Account Where Id=:lead.AccountIdForLeadConversion__c];
                    acct.Converted_Lead__c  = true;
                    acct.Converted_Lead_Created_Date__c = lead.CreatedDate;
                    acct.Lead_Conversion_Date__c = DateTime.NOW();
                    acct.AccountSource = lead.LeadSource;
                    acctsForUpdate.add(acct);
                }
                
             }
         }
         if (acctsForUpdate.size() > 0) {
             update acctsForUpdate;
         }
         if (consForInsert.size() > 0) {
             insert consForInsert;
         }
         if (rpsForUpdate.size() > 0) {
             update rpsForUpdate;
         }
         if (appsForUpdate.size() > 0) {
             update appsForUpdate;
         }
         
         
         if (!leadConverts.isEmpty()) {
             //LeadConvert_Methods.myconvert(leadConverts);
             try {
             List<Database.LeadConvertResult> lcrs = Database.convertLead(leadConverts);
             for (Database.LeadConvertResult lcr : lcrs) {
                if (!lcr.isSuccess()) {
                    System.debug('Exception converting lead: ' + lcr.getErrors()[0].getMessage());

                } else {
                    System.debug('Successfullly convert lead to account - ' + lcr.getAccountId());
                }
             }
             } catch (EXception e) {System.debug('Exception converting lead ' + lead.Id + ' ' + e.getStackTraceString());}
         }
    }
}