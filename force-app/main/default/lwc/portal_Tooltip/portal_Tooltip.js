import { LightningElement, api } from 'lwc';

export default class Portal_Tooltip extends LightningElement {
    @api text;

    renderedCallback() {
        let popoverContainer = this.template.querySelector('.popover-container');
        if (popoverContainer) {
            let popover = popoverContainer.firstChild;
            popover.style.left = (-popoverContainer.offsetLeft - 5) + 'px';
        }
    }

    tooltipActive = (event) => {
        let popoverContainer = event.currentTarget.nextSibling;
        popoverContainer.style.display = '';

        let popover = popoverContainer.firstChild;
        popover.style.left = (-popoverContainer.offsetLeft - 5) + 'px';

        popoverContainer.classList.toggle('show');
    }

    tooltipInactive = (event) => {
        let popoverContainer = event.currentTarget.nextSibling;
        popoverContainer.classList.toggle('show');
        popoverContainer.style.display = 'none';
    }
}