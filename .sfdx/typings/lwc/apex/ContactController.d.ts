declare module "@salesforce/apex/ContactController.getContactList" {
  export default function getContactList(): Promise<any>;
}
declare module "@salesforce/apex/ContactController.findContacts" {
  export default function findContacts(param: {searchKey: any}): Promise<any>;
}
declare module "@salesforce/apex/ContactController.getSingleContact" {
  export default function getSingleContact(): Promise<any>;
}
declare module "@salesforce/apex/ContactController.echoInput" {
  export default function echoInput(param: {exploit: any}): Promise<any>;
}
