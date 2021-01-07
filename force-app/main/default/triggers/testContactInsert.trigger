trigger testContactInsert on Contact (after insert) {

Set<ID> aID = new Set<ID>();

for(Contact c: trigger.new)
{
aID.add(c.accountId);
}

// List<Account> la = [Select Name,Number_of_Contacts__c from Account where Id in :aID];

// for(Account ax: la)
// {
// List<Contact> ca = [Select Id, Name from Contact where accountId = :ax.Id]; 
// ax.Number_of_Contacts__c = ca.size();
// }
// update la;
}