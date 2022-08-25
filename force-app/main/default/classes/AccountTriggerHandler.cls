public with sharing class AccountTriggerHandler {
    public static void onBeforeInsert(List<Account> accList) {
        System.debug('Start updateInsertAccNumber function');
        for (Account acc : accList) {
            acc.AccountNumber = acc.Name + acc.Phone + acc.Email__c;
        }
        System.debug('End updateInsertAccNumber handler');
    }

    public static void onAfterInsertOrUpdate(List<Account> accList) {
        System.debug('Start sendHotAccNotification handler');
        for (Account acc : accList) {
            if (acc.Rating.equals('Hot')) {
                String subject = '[' + acc.AccountNumber + '] [' + acc.Name + '] Hot Account';
                EmailMissionSpecialist.sendMail(acc.Email__c, subject, 'This is a hot account. Please follow it');
            }
        }
        System.debug('End sendHotAccNotification handler');
        
        System.debug('Start createTaskRecordIfRatingCold handler');
        List<Task> newTask = new List<Task>();
        for (Account acc : accList) {
            if (acc.Rating.equals('Cold')) {
                Task coldRatingTask = new Task();
                coldRatingTask.Subject = 'Call';
                coldRatingTask.OwnerId = acc.OwnerId;
                coldRatingTask.WhatId = acc.Id;
                newTask.add(coldRatingTask);
            }
        }
        insert newTask;
        System.debug('End createTaskRecordIfRatingCold handler');
    }
}