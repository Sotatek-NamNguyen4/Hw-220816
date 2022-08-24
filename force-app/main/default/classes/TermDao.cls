/**
 * class Business for object Term
 *
 * @author NamNH4
 */
public with sharing class TermDao {

     /**
      * Query to get all terms
      * @return List<Term__c>
     **/
    @AuraEnabled(cacheable=true)
    public static List<Term__c> getTerms(){
        List<Term__c> termList = [
                SELECT Name, Context__c, EnforcementDate__c 
                FROM Term__c 
                ORDER BY EnforcementDate__c DESC
            ];
        return termList;
    }
}
