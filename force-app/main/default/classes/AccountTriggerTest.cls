@isTest
public class AccountTriggerTest {

    @isTest static void testTriggerInsertAccountsAutoConfigAccountNumber() {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account acc = new Account(Name = 'Test-acc-' + i, Email__c = 'test@gmail.com', Phone = '01238', Rating = 'Warm');
            accs.add(acc);
        }
        Test.startTest();
        insert accs;
        Test.stopTest();
        List<Account> verifyAccs = [SELECT Id, Name, AccountNumber FROM Account WHERE AccountNumber LIKE 'Test-acc-_01238test@gmail.com'];
        System.assertEquals(10, verifyAccs.size());
    }

    @isTest static void testTriggerInsertAccountsWithRatingCold() {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account acc = new Account(Name = 'Test-acc-' + i, Email__c = 'test@gmail.com', Phone = '01238', Rating = 'Cold');
            accs.add(acc);
        }
        Test.startTest();
        insert accs;
        Test.stopTest();
        List<Account> verifyAccs = [SELECT Id
                                    FROM Account 
                                    WHERE AccountNumber LIKE 'Test-acc-_01238test@gmail.com' 
                                    AND Rating LIKE 'Cold'];
        System.assertEquals(10, verifyAccs.size());
        List<Task> verifyTasks = [SELECT Id, Subject, WhatId 
                                FROM Task 
                                WHERE WhatId IN :verifyAccs];
        System.assertEquals(10, verifyTasks.size());
    }

    @isTest static void testTriggerUpdateAccountsWithRatingCold() {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account acc = new Account(Name = 'Test-acc-' + i, Email__c = 'test@gmail.com', Phone = '01238', Rating = 'Warm');
            accs.add(acc);
        }
        Test.startTest();
        insert accs;
        List<Account> verifyAccs = [SELECT Id, Name, AccountNumber 
                                    FROM Account WHERE AccountNumber LIKE 'Test-acc-_01238test@gmail.com' 
                                    AND Rating LIKE 'Warm'];
        List<Account> updateAccs = new List<Account>();
        for (Account acc : verifyAccs) {
            acc.Rating = 'Cold';
            updateAccs.add(acc);
        }
        update updateAccs;
        Test.stopTest();
        List<Account> verifyAccsAfterTest = [SELECT Id
                                            FROM Account WHERE AccountNumber LIKE 'Test-acc-_01238test@gmail.com' 
                                            AND Rating LIKE 'Cold'];
        System.assertEquals(10, verifyAccsAfterTest.size());
        List<Task> verifyTasks = [SELECT Id, Subject, WhatId 
                                FROM Task 
                                WHERE WhatId IN :verifyAccsAfterTest];
        System.assertEquals(10, verifyTasks.size());
    }
}