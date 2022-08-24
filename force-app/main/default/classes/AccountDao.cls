/**
 * Dao class of Account Object
 *
 * @author NamNH4
 */
public with sharing class AccountDao {
    /**
    *  Get AccountList by conditions and data for pagination
    * @param accName account name
    * @param accNum account number
    * @param accPhone account phone
    * @param accInd account industry name
    * @param pageSize size of pagination
    * @param pageNumber page number
    * @return AccountInfoWrapper object
    **/
    @AuraEnabled (cacheable = true)
    public static AccountInfoWrapper getAccountsByConditions (String accName, String accNum, String accPhone, 
                                                String accInd, Integer pageSize, Integer pageNumber) {

        AccountInfoWrapper obj = new AccountInfoWrapper();

        String query = 'SELECT Id, Name, AccountNumber, Phone, Industry, AnnualRevenue, Fax, Rating FROM Account ';
        String countAccountQuery = 'SELECT COUNT() FROM Account';
        Integer offset = 0;
        
        if (String.isNotBlank(accName) || String.isNotBlank(accNum) || 
            String.isNotBlank(accPhone) || String.isNotBlank(accInd)) {
            query = query + ' WHERE ';
            countAccountQuery = countAccountQuery + ' WHERE ';
        } 

        if (String.isNotBlank(accName)) {
            String concatQuery = ' Name LIKE ' + '\'' +'%' + accName + '%' + '\'';
            query = query + concatQuery;
            countAccountQuery = countAccountQuery + concatQuery;
        }
        
        if (String.isNotBlank(accNum)) {
            String concatQuery = 'AccountNumber LIKE ' + '\'' + accNum + '\'';
            if (query.endsWith('\'')) {
                concatQuery = ' AND ' + concatQuery;
            }
            query = query + concatQuery;
            countAccountQuery = countAccountQuery + concatQuery;
        } 
        
        if (String.isNotBlank(accPhone)) {
            String concatQuery = 'Phone LIKE ' + '\'' + accPhone + '\'';
            if (query.endsWith('\'')) {
                concatQuery = ' AND ' + concatQuery;
            }
            query = query + concatQuery;
            countAccountQuery = countAccountQuery + concatQuery;
        } 
         
        if (String.isNotBlank(accInd)) {
            String concatQuery = 'Industry = ' + '\'' + accInd + '\'';
            if (query.endsWith('\'')) {
                concatQuery = ' AND ' + concatQuery;
            }
            query = query + concatQuery;
            countAccountQuery = countAccountQuery + concatQuery;
        } 
        offset = (pageNumber - 1) * pageSize;
        query = query + ' ORDER BY Name LIMIT ' + pageSize + ' OFFSET ' + offset;

        obj.totalRecords = Database.countQuery(countAccountQuery);
        obj.pageSize = pageSize;
        obj.pageNumber = pageNumber;
        obj.accounts = Database.query(query);
        return obj;
    }

    /**
    *  Wrapper class of pagination data
    **/
    public class AccountInfoWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer pageNumber {get;set;}
        @AuraEnabled public Integer totalRecords {get;set;}
        @AuraEnabled public List<Account> accounts {get;set;}
    }
}
