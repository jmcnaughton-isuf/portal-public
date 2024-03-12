import { LightningElement, api } from 'lwc';

export default class Portal_HonorRollTable extends LightningElement {
    @api honorRollNameList;
    @api honorRollYear;
    @api handleHonorRollNameClick = () => {};
}