import { LightningElement, api } from 'lwc';

export default class Portal_HonorRollFilters extends LightningElement {
    @api listOfFiscalYears;
    @api selectedFiscalYear;
    @api givingSocietiesNames;
    @api selectedGivingSociety;
    @api classYears;
    @api selectedClassYear;
    @api listOfDivisionsAndSchools;
    @api selectedDivisionOrSchool;
    @api honorRollNameSearchString;

    @api honorYearLabel;
    @api givingSocietyLabel;
    @api divisionOrSchoolLabel;
    @api classYearLabel;

    @api showHonorRollYearFilter;
    @api showGivingSocietyFilter;
    @api showDivisionOrSchoolFilter;
    @api showClassYearLabel;

    // functions
    @api handleFiscalYearInput = () => {};
    @api handleSearchInput = () => {};
    @api handleGivingSocietyInput = () => {};
    @api handleClassYearInput = () => {};
    @api handleApplyFilterClick = () => {};
    @api handleDivisionAndSchoolInput = () => {};
    @api handleClearInput = () => {};
}