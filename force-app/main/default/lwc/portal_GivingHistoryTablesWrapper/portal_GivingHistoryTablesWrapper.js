import { api, LightningElement, track } from 'lwc';

export default class Portal_GivingHistoryWrapper extends LightningElement {
    @api tabTitlesCSV;
    @api tabColor;
    @api tabHighlightedColor;
    @api showFirstTable;
    @api showSecondTable;
    @api showThirdTable;
    @api showFourthTable;

    // tab 1 design attribtues
    @api givingHistoryHelperTextHTML;
    @api givingHistoryItemsPerPage;
    @api givingHistoryHideReceipt;
    @api givingHistoryReceiptColumnLabel;
    @api givingHistoryReceiptRowText;
    @api givingHistoryNoReceiptRowText;
    @api givingHistoryReceiptBaseURL;
    @api givingHistoryReceiptContentPageName;
    @api givingHistoryNoTableDataTextHTML;

    // tab 2 design attribtues
    @api pledgesHelperTextHTML;
    @api pledgesShowNumberOfPaymentsColumn;
    @api pledgesNumberOfPaymentsColumnTitle;
    @api pledgesDesginationNameDisplayOption;
    @api pledgesDesginationNameOverride;
    @api pledgesItemsPerPage;
    @api pledgesNoTableDataTextHTML;

    // tab 3 design attribtues
    @api recurringGiftHelperTextHTML;
    @api recurringGiftShowNextInstallmentPaymentCoulmn;
    @api recurringGiftNextInstallmentPaymentColumn;
    @api recurringGiftDesginationNameDisplayOption;
    @api recurringGiftDesginationNameOverride;
    @api recurringGiftItemsPerPage;
    @api recurringGiftDataTextHTML;

    // tab 4 design attribtues
    @api matchingGiftHelperTextHTML;
    @api matchingGiftDesginationNameDisplayOption;
    @api matchingGiftDesginationNameOverride;
    @api matchingGiftItemsPerPage;
    @api matchingGiftDataTextHTML;

    @track tabTitles = [];
    currentTabIndex = '0'; //0 based counting

    connectedCallback() {
        console.log(this.tabTitlesCSV);

        document.documentElement.style.setProperty('--tabHighlightedColor', this.tabHighlightedColor);
        document.documentElement.style.setProperty('--tabColor', this.tabColor);

        let formattedTabTitles = [];
        if (this.tabTitlesCSV) {
            let tabList = this.tabTitlesCSV.split(',');
            for (let tabIndex in tabList) {
                let active = false;

                if (tabIndex == 0) {
                    active = true;
                }

                formattedTabTitles.push({
                    'active' : active,
                    'label' : tabList[tabIndex]
                });
            }
        }

        this.tabTitles = formattedTabTitles;
        console.log(this.tabTitles);
    }

    changeTab(event) {
        let index = event.target.dataset.index;
        this.currentTabIndex = index.trim();

        for (let tabIndex in this.tabTitles) {
            console.log(this.tabTitles[tabIndex]);
            if (tabIndex == index) {
                this.tabTitles[tabIndex].active = true;
            } else {
                this.tabTitles[tabIndex].active = false;
            }
        }

        console.log('New index: ' + this.currentTabIndex + typeof(index));
    }

    get firstTab() {
        return this.currentTabIndex == this.adjustTableIndex(0);
    }

    get secondTab() {
        return this.currentTabIndex == this.adjustTableIndex(1);
    }

    get thirdTab() {
        return this.currentTabIndex == this.adjustTableIndex(2);
    }

    get fourthTab() {
        return this.currentTabIndex == this.adjustTableIndex(3);
    }

    adjustTableIndex(originalIndex) {
        if (originalIndex <=0) {
            return originalIndex
        }

        if (originalIndex >= 3 && !this.showThirdTable) {
            originalIndex -= 1;
        }

        if (originalIndex >= 2 && !this.showSecondTable) {
            originalIndex -= 1;
        }

        if (originalIndex >= 1 && !this.showFirstTable) {
            originalIndex -= 1;
        }

        return originalIndex;

    }
}