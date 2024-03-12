import { LightningElement, api } from 'lwc';

export default class Portal_ConfirmAction extends LightningElement {
    @api messageMap;  // .action, .warning, .cancel., .confirm
    @api callbackMap; // .handleAction(), .handleCancel(), .handleConfirm()
    @api actionClass;

    get actionDivClasses() {
        return this.actionClass + ' show';
    }

    handleAction = (event) => {
        let actionDiv = event.currentTarget.parentNode;
        actionDiv.nextSibling.classList.toggle('show');
        actionDiv.classList.toggle('show');

        this.callbackMap.handleAction();
    }

    handleCancel = (event) => {
        let alertDiv = event.currentTarget.parentNode.parentNode;
        alertDiv.previousSibling.classList.toggle('show');
        alertDiv.classList.toggle('show');
        
        this.callbackMap.handleCancel();
    }

    handleConfirm = (event) => {
        this.callbackMap.handleConfirm();
    }
}