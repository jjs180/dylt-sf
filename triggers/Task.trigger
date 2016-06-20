trigger Task on Task (before insert, after insert, after update) 
{
	Tasks.run();
}