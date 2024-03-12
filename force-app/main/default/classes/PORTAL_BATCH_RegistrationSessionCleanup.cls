public virtual class PORTAL_BATCH_RegistrationSessionCleanup implements Database.Batchable<sObject>, Schedulable{
    public virtual Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT id FROM ucinn_portal_Registration_Session__c WHERE Is_Valid_Session__c = false');
    }

    public virtual void execute(Database.BatchableContext bc, List<ucinn_portal_Registration_Session__c> sessionList) {
        if (sessionList == null || sessionList.isEmpty()) {
            return;
        }

        Set<String> sessionIdSet = new Set<String>();

        for (ucinn_portal_Registration_Session__c eachSession : sessionList) {
            sessionIdSet.add(eachSession.Id);
        }

        List<ucinn_portal_Ticket__c> ticketListToDelete = [SELECT id, Participation__c
                                                           FROM ucinn_portal_Ticket__c
                                                           WHERE Registration_Session__c IN :sessionIdSet];

        Set<String> participationIdSet = new Set<String>();

        for (ucinn_portal_Ticket__c eachTicket : ticketListToDelete) {
            participationIdSet.add(eachTicket.Participation__c);
        }

        List<ucinn_portal_Participation__c> participationListToDelete = [SELECT id
                                                                         FROM ucinn_portal_Participation__c
                                                                         WHERE Id IN :participationIdSet
                                                                         AND Status__c != :PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED];

        delete ticketListToDelete;
        delete participationListToDelete;
        delete sessionList;
    }

    public virtual void finish(Database.BatchableContext bc) {}

    public virtual void execute(SchedulableContext scon) {
      Database.executeBatch(new PORTAL_BATCH_RegistrationSessionCleanup(), 100);
    }
}