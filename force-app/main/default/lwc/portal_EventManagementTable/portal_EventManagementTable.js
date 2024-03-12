import { LightningElement, api } from 'lwc';

export default class Portal_EventManagementTable extends LightningElement {
    @api participationList;
    @api markAsAttended = () => {};
    @api deleteParticipationRecord = () => {};

    _participationId;
    _showModal = false;

    handleMarkAsAttendedClick(event) {
        let attendedValueBoolean = (event.currentTarget.dataset.attended === 'true');
        const params = {id : event.currentTarget.dataset.id, attendedValue : attendedValueBoolean};
        this.markAsAttended(params);
    }

    handleDeleteClick(event) {
        this._participationId = event.currentTarget.dataset.id;
        this.handleOpenModal();
    }

    handleDeleteParticipationRecord() {
        this.deleteParticipationRecord({id: this._participationId});
        this.handleCloseModal();
    }

    handleOpenModal() {
        this._showModal = true;
    }

    handleCloseModal() {
        this._showModal = false;
    }


    renderedCallback() {
        this.equalHeight(true);
        window.addEventListener('resize', (event) => {this.equalHeight(true);});
    }

    equalHeight = (resize) => {
        let headerElements = this.template.querySelectorAll('.headerEqualHeight');
        let elements = this.template.querySelectorAll(".equalHeight")
        let expandedElements = this.template.querySelectorAll(".element-row");
        let allHeights = [];
        let allHeaderHeights = [];
        let allRowHeights = [];

        if (!headerElements || !elements) {
            return;
        }

        if(resize === true){
            for(let i = 0; i < elements.length; i++){
                elements[i].style.height = 'auto';
            }
            for(let i = 0; i < headerElements.length; i++){
                headerElements[i].style.height = 'auto';
            }
            for(let i = 0; i < expandedElements.length; i++){
                expandedElements[i].style.height = 'auto';
            }
        }

        for(let i = 0; i < elements.length; i++){
            var elementHeight = elements[i].clientHeight;
            allHeights.push(elementHeight);
        }

        for(let i = 0; i < headerElements.length; i++){
            var elementHeight = headerElements[i].clientHeight;
            allHeaderHeights.push(elementHeight);
        }

        for(let i = 0; i < expandedElements.length; i++){
            var elementHeight = expandedElements[i].clientHeight;
            allRowHeights.push(elementHeight);
        }

        for(let i = 0; i < elements.length; i++){
            elements[i].style.height = Math.max.apply( Math, allHeights) + 'px';
            if(resize === false){
                elements[i].className = elements[i].className + " show";
            }
        }

        for(let i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = Math.max.apply( Math, allHeaderHeights) + 'px';
            if(resize === false){
                headerElements[i].className = headerElements[i].className + " show";
            }
        }

        for(let i = 0; i < expandedElements.length; i++){
            expandedElements[i].style.height = Math.max.apply( Math, allRowHeights) + 'px';
            if(resize === false){
                expandedElements[i].className = expandedElements[i].className + " show";
            }
        }
    }
}