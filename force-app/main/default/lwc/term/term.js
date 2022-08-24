import { LightningElement } from 'lwc';
import getTerms from '@salesforce/apex/TermDao.getTerms';

export default class Term extends LightningElement {
    termList = [];
    term = {};
    title = '';
    enforcementDate;
    context = '';
    isDisableNextButton = true;
    isDisablePrevButton = true;

    // @wire(getTermList) termListWire ({ error, data }) {
    //     if (data) {
    //         this.termList = data;
    //     } else if (error) {
    //         console.log("Error: ", error);
    //     }
    // }

    async connectedCallback() {
        this.getTerms();
        
    }

    async getTerms() {
        this.termList = await getTerms();
        this.term = this.termList[0];
        console.log('log in render try: ', this.term);
        this.title = this.termList[0].Name;
        this.enforcementDate = this.termList[0].EnforcementDate__c;
        this.context = this.termList[0].Context__c;
        if (this.termList.length != 0 && this.termList.length != 1) {
            console.log('enable btn');
            this.isDisableNextButton = false;   
        }
    }

    nextHandler () {
        console.log('click next btn');
        let i = this.termList.indexOf(this.term) + 1;
        this.term = this.termList[i];
        this.title = this.termList[i].Name;
        this.enforcementDate = this.termList[i].EnforcementDate__c;
        this.context = this.termList[i].Context__c;
        console.log(this.term);
        if (i == (this.termList.length-1)) {
            this.isDisableNextButton = true;
        }
        this.isDisablePrevButton = false;
    }
    
    prevHandler () {
        console.log('click prev btn');
        let i = this.termList.indexOf(this.term) - 1;
        if (i >= 0) {
            this.term = this.termList[i];
            this.title = this.termList[i].Name;
            this.enforcementDate = this.termList[i].EnforcementDate__c;
            this.context = this.termList[i].Context__c;
        }
        console.log(this.term);
        if (i == 0) {
            this.isDisablePrevButton = true;
        }
        this.isDisableNextButton = false;
    }
}