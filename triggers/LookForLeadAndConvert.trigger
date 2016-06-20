trigger LookForLeadAndConvert on Account (before insert, after insert)
{
    List<Lead> leadsForUpdate = new List<Lead>();
    List<Contact> contacts = new List<Contact>();
    Set<String> dyltAccounts = new Set<String>();
    
    for(Account acct : Trigger.new)
    {
        if(!String.isEmpty(acct.DYLT_Account__c))
        {
            dyltAccounts.add(acct.DYLT_Account__c);
        }
    }
    
    List<Lead> leads = [Select Id, TruckMate_Id__c, Status, Converted_Date__c, Competitive_Carrier__c, Current_Shipper__c, Decision_Location__c, Pay_for_Freight__c,
                                    LTL_Spend__c, What_do_they_ship__c, Who_do_they_ship_to__c, Year_Company_Started__c, Countries_that_they_Import_From__c, emma__Emma_Member_ID__c, emma__Bounced__c, Shipping_Service__c,
                                    FirstName, LastName, Phone, MobilePhone, Email, Description, HasOptedOutOfEmail, LeadSource from Lead Where IsConverted = false and TruckMate_Id__c in :dyltAccounts];
    Map<String, List<Lead>> leadMap = new Map<String, List<Lead>>();
    
    for(Lead thelead : leads)
    {
        if(!leadMap.containsKey(thelead.TruckMate_Id__c))
        {
            leadMap.put(thelead.TruckMate_Id__c, new List<Lead>());
        }
        leadMap.get(thelead.TruckMate_Id__c).add(thelead);
    }
    
    for(Account acct: Trigger.new)
    {
        //look for lead with this DYTL number
        if(!String.isEmpty(acct.DYLT_Account__c) && leadMap.containsKey(acct.DYLT_Account__c))
        {
            for(Lead thelead : leadMap.get(acct.DYLT_Account__c))
            {
                thelead.Status = 'Converted';
                
                if(Trigger.isBefore)
                {
                    acct.Competitive_Carrier__c = thelead.Competitive_Carrier__c;
                    acct.Current_Carrier__c = thelead.Current_Shipper__c;
                    acct.Decision_Location__c = thelead.Decision_Location__c;
                    acct.Pay_for_Freight__c = thelead.Pay_for_Freight__c;
                    acct.Monthly_Potential_Revenue__c = thelead.LTL_Spend__c;
                    acct.What_do_they_ship__c = thelead.What_do_they_ship__c;
                    acct.Who_do_they_ship_to__c = thelead.Who_do_they_ship_to__c;
                    acct.Year_Company_Started__c = thelead.Year_Company_Started__c;
                    acct.Countries_that_they_Import_From__c = thelead.Countries_that_they_Import_From__c;
                    acct.Shipping_Service__c = thelead.Shipping_Service__c;
                }
                else
                {
                    System.debug('FOund lead for DYLT number: ' + acct.DYLT_Account__c + ' Id: ' + thelead.Id);
                    //thelead.AutoConvert__c = true;
                    thelead.AccountIdForLeadConversion__c = acct.Id;
                    thelead.Converted_Date__c = DateTime.now();
                    leadsForUpdate.add(thelead);
                    
                    Contact con = new Contact(AccountId = acct.Id, OwnerId = acct.OwnerId, emma__Bounced__c = thelead.emma__Bounced__c, emma__Emma_Member_ID__c = thelead.emma__Emma_Member_ID__c);
                    con.FirstName = thelead.FirstName;
                    con.LastName = thelead.LastName;
                    con.Phone = thelead.Phone;
                    con.MobilePhone = thelead.MobilePhone;
                    con.Email = thelead.Email;
                    con.Description = thelead.Description;
                    con.HasOptedOutOfEmail = thelead.HasOptedOutOfEmail;
                    con.LeadSource = thelead.LeadSource;
                    contacts.add(con);
                }
            }
        }
    }
    
    if (leadsForUpdate.size() >0)
    {
        update leadsForUpdate;
    }
    
    if(contacts.size() > 0)
    {
        insert contacts;
    }
}