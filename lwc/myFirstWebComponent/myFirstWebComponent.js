import { LightningElement, api, wire } from 'lwc';
// eslint-disable-next-line no-unused-vars
import JQUERY from '@salesforce/resourceUrl/jquery';
import {getRecord} from 'lightning/uiRecordApi';

export default class HelloIteration extends LightningElement {
    
    @api recordId;
    @api objectApiName;
    fields =['AccountId', 'Name', 'Title', 'Phone', 'Email'];

    @wire (getRecord,{recordId:'$recordId', fields:['Account.Name']})myProperty;
    contacts = [
        {
            Id: 1,
            Name: '<script>alert();</script> Amy Taylor',
            Title: 'VP of Engineering',
        },
        {
            Id: 2,
            Name: '<a href="#" onmouseover="alert();">Michael Jones</a>',
            Title: 'VP of Sales',
        },
        {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
    ];
}