trigger LeadAssignmentTrigger on Lead (before insert) 
{
    List<Lead> leadsToUpdate = new List<Lead>();

    for (Lead lead : Trigger.new)
    {     
      if (lead.PostalCode != NULL)
      {
          // Find the sales rep for the current zip code
          List<Zip_Code__c> zip = [select Sales_Rep__c from Zip_Code__c 
                                   where Name = :lead.PostalCode limit 1];
                
          // if you found one
          if (zip.size() > 0) 
          {    
              //assign the lead owner to the zip code owner
              lead.OwnerId = zip[0].Sales_Rep__c; 
          
              leadsToUpdate.add(lead);
          
          }
       } 
          
     }
     
     
      {
            
      }     
}