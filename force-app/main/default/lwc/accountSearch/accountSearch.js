import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { LightningElement, wire } from 'lwc';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import getAccountsByConditions from '@salesforce/apex/AccountDao.getAccountsByConditions';

export default class AccountSearch extends LightningElement {
    pageData = [];
    currentPage = 1;
    totalPages = 0;
    pageSize = 5;

    nameSearch = '';
    phoneSearch = '';
    numberSearch = '';
    industrySearch = '';

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: INDUSTRY_FIELD})
        industryPicklistValues;

    /**
    *  Get Industry picklist values and add None option
    **/    
    get industryOptions() {
        let noneIndustryOption = {attributes: null, label:'--None--', validFor: Array(0), value: ''};
        console.log('log picklist: ', this.industryPicklistValues);
        let temp = this.industryPicklistValues.data.values.map(item => ({
            attributes: item.attributes,
            label: item.label,
            valideFor: item.validFor,
            value: item.value
        }))
        temp.unshift(noneIndustryOption);
        return temp;
    }

    /**
    *  Call first time when loading page
    **/
    connectedCallback() {
        this.searchAccounts(1);
    }

    /**
    *  Call Apex Class to get List Accounts by conditions
    *  @param pageNumber current page number
    *  @return list accounts and pagination data
    **/
    async searchAccounts(pageNumber) {
        console.log('page: ', pageNumber);
        getAccountsByConditions({
            accName: this.nameSearch,
            accNum: this.numberSearch,
            accPhone: this.phoneSearch,
            accInd: this.industrySearch,
            pageNumber: pageNumber,
            pageSize: this.pageSize
        })
        .then(result => {
            console.log('log result: ', result);
            if (result) {
                this.pageData = result.accounts;
                console.log('log page data: ', this.pageData);
                this.currentPage = result.pageNumber;
                this.totalPages = Math.ceil(result.totalRecords / this.pageSize);
            }
        })
        .catch(error => {
            this.error = error;
        });
    }

    /**
    *  Search button handler
    **/
    searchListHandler () {
        console.log('nameSearch: ', this.nameSearch);
        console.log('numSearch: ', this.numSearch);
        console.log('phoneSearch: ', this.phoneSearch);
        console.log('industrySearch: ', this.industrySearch);
        this.searchAccounts(1);
    }

    /**
    *  Prev page button handler
    **/
    prevPageHandler() {
        console.log('nameSearch: ', this.nameSearch);
        console.log('numSearch: ', this.numSearch);
        console.log('phoneSearch: ', this.phoneSearch);
        console.log('industrySearch: ', this.industrySearch);
        this.searchAccounts(this.currentPage - 1);
    }

    /**
    *  Next page button handler
    **/
    nextPageHandler() {
        console.log('nameSearch: ', this.nameSearch);
        console.log('numSearch: ', this.numSearch);
        console.log('phoneSearch: ', this.phoneSearch);
        console.log('industrySearch: ', this.industrySearch);
        this.searchAccounts(this.currentPage + 1);
    }

    /**
    *  Check condition of prev page button handler
    **/
    get isDisablePrevBtn() {
        return (this.currentPage === 1 || this.totalRecords < this.pageSize);
    }

    /**
    *  Check condition of next button handler
    **/
    get isDisableNextBtn() {
        return (this.currentPage === this.totalPages || this.totalPages === 0);
    }

    /**
    *  onchange Account Name field handler
    **/
    handleNameChange(event) {
            this.nameSearch = event.target.value;
    }

    /**
    *  onchange Phone field handler
    **/
    handlePhoneChange(event) {
        this.phoneSearch = event.target.value;
    }

    /**
    *  onchange Account Number field handler
    **/
    handleNumChange(event) {
        this.numberSearch = event.target.value;
    }

    /**
    *  onchange Industry field handler
    **/
    handleIndustryChange(event) {
        this.industrySearch = event.target.value;
    }
}