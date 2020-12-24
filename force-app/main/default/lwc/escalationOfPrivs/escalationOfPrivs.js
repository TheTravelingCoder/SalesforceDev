import { LightningElement, track, api } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';
import updateUser from '@salesforce/apex/escalationOfPrivs.updateUser';
import User_FirstName from '@salesforce/schema/User.FirstName';
import User_LastName from '@salesforce/schema/User.LastName';
import User_Email from '@salesforce/schema/User.Email';
import User_Alias from '@salesforce/schema/User.Alias';
import User_Username from '@salesforce/schema/User.Alias';


export default class escalationOfPrivs extends LightningElement {
    @track contacts;
    @track error;
    
    handleLoad() {
        getContactList()
            .then(result => {
                this.contacts = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.contacts = undefined;
            });
    }
    value = 'System Administrator';

    get options() {
        return [
            { label: 'System Administrator', value: 'System Administrator' },
            { label: 'Standard User', value: 'Standard User' },
            { label: 'Guest', value: 'Guest' },
            { label: 'Partner User', value: 'Partner User' },
            { label: 'Force.com - Free User', value: 'Force.com - Free User' },
            
        ];
    }

    handleChange(event) {
        try
        {
        this.value = event.detail.value;
        console.log(event.detail.value);
       updateUser({profileName: event.detail.value}).then(result => {
            console.log('Response: ' + result);
        })
    }catch(e)
        {
            console.log(e);
        }
    }
}