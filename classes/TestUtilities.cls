public with sharing class TestUtilities 
{
    public static List<Account> createAccounts()
    {       
        List<Account> accnts = new List<Account>
        {
            new Account(DYLT_Account__c=String.ValueOf(Math.Random()*100000000).right(10),Name='test1',BillingStreet='121 street',BillingCity='test city1',BillingState='California',BillingPostalCode='12356',Phone='1231121325',Fax='8485652512'),
            new Account(DYLT_Account__c=String.ValueOf(Math.Random()*100000000).right(10),Name='test2',BillingStreet='122 pkwy',BillingCity='test city2',BillingState='Texas',BillingPostalCode='12358',Phone='',Fax='8485652111'),
            new Account(DYLT_Account__c=String.ValueOf(Math.Random()*100000000).right(10),Name='test3',BillingStreet='123 dr',BillingCity='test city3',BillingState='Washington',BillingPostalCode='12311',Phone='1231121856',Fax='')
        };
        
        insert accnts;
        
        return accnts;
    }

    public static List<Contact> createContact(Id AccountId)
    {       
        List<Contact> contacts = new List<Contact>
        {
            new Contact(AccountId = AccountId, FirstName='test1', LastName='lnametest' + String.ValueOf(Math.Random()*100000000).right(10) )
        };
        
        insert contacts;
        
        return contacts;
    }
    
    public static List<Task> createTasks(List<sObject> whats)
    {
        List<Task> tasks = new List<Task>();
        
        for(sObject w : whats)
        {
            tasks.add(new Task(Subject='testTask1_' + w.get('Name'),WhatId=w.Id));
            tasks.add(new Task(Subject='testTask2_' + w.get('Name'),WhatId=w.Id));
            tasks.add(new Task(Subject='testTask3_' + w.get('Name'),WhatId=w.Id));
        }
        
        insert tasks;
        
        return tasks;
    }

    public static List<Task> createWhoTasks(List<sObject> Whos)
    {
        List<Task> tasks = new List<Task>();
        
        for(sObject w : Whos)
        {
            tasks.add(new Task(Subject='testTask1_' + w.get('Name'),WhoId=w.Id));
            tasks.add(new Task(Subject='testTask2_' + w.get('Name'),WhoId=w.Id));
            tasks.add(new Task(Subject='testTask3_' + w.get('Name'),WhoId=w.Id));
        }
        
        insert tasks;
        
        return tasks;
    }
    
    public static List<Probill__c> createProbills(List<Account> accnts)
    {
        List<Probill__c> probills = new List<Probill__c>();
        
        for(Account a : accnts)
        {
            probills.add(new Probill__c(Name='test1_' + a.Id,Account__c=a.Id,Probill__c=String.ValueOf(Math.Random()*100000000).right(10),Rev_Cont_Total__c=1000,Rev_Curr_Total__c=500,Actual_Pickup__c=Date.today(),Delivery_Start__c=Date.today().addMonths(-1)));
            probills.add(new Probill__c(Name='test2_' + a.Id,Account__c=a.Id,Probill__c=String.ValueOf(Math.Random()*100000000).right(10),Rev_Cont_Total__c=2000,Rev_Curr_Total__c=600,Actual_Pickup__c=Date.today(),Delivery_Start__c=Date.today()));
            probills.add(new Probill__c(Name='test3_' + a.Id,Account__c=a.Id,Probill__c=String.ValueOf(Math.Random()*100000000).right(10),Rev_Cont_Total__c=3000,Rev_Curr_Total__c=700,Actual_Pickup__c=Date.today(),Delivery_Start__c=Date.today().addMonths(1)));
            
            probills.add(new Probill__c(Name='test1Prior_' + a.Id,Account__c=a.Id,Probill__c=String.ValueOf(Math.Random()*100000000).right(10),Rev_Cont_Total__c=800,Rev_Curr_Total__c=555,Actual_Pickup__c=Date.today(),Delivery_Start__c=Date.today().addYears(-1).addMonths(-1)));
            probills.add(new Probill__c(Name='test2Prior_' + a.Id,Account__c=a.Id,Probill__c=String.ValueOf(Math.Random()*100000000).right(10),Rev_Cont_Total__c=1600,Rev_Curr_Total__c=666,Actual_Pickup__c=Date.today(),Delivery_Start__c=Date.today().addYears(-1)));
            probills.add(new Probill__c(Name='test3Prior_' + a.Id,Account__c=a.Id,Probill__c=String.ValueOf(Math.Random()*100000000).right(10),Rev_Cont_Total__c=2400,Rev_Curr_Total__c=777,Actual_Pickup__c=Date.today(),Delivery_Start__c=Date.today().addYears(-1).addMonths(1)));
        }
        
        insert probills;
        
        return probills;
    }
    
    
    
    // managed package
 /*   public static void setCustomSettingSalesInfoMapSetting()
    {
        List<Extentia_SIM__SalesInfoMapSetting__c> simCSList = new List<Extentia_SIM__SalesInfoMapSetting__c>();
        
        Map<String,String> nvCSMap = new Map<String,String>
        {
            'IsGoogleKeyValid' => 'Yes',
            'IsGoogleAPIQueryLimitExceeded' => 'No'
        };
        
        for(String n : nvCSMap.keyset())
        {
            Extentia_SIM__SalesInfoMapSetting__c cs = new Extentia_SIM__SalesInfoMapSetting__c();
            cs.Name = n;
            cs.Extentia_SIM__Value__c = nvCSMap.get(n);
            simCSList.add(cs);
        }

        insert simCSList;
    }*/
}