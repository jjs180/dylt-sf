trigger Probill on Probill__c (after insert, before insert, before update) 
{
	Probills.run();
}