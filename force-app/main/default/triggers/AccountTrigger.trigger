trigger AccountTrigger on Account (before insert, after insert, after update) {
    System.debug('Call account trigger');
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isUpdate || Trigger.isInsert) {
            AccountTriggerHandler.onAfterInsertOrUpdate(Trigger.new);
        }
    }
    System.debug('End account trigger');
}