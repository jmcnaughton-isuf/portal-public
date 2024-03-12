import { api, LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import chartJs from '@salesforce/resourceUrl/ucinn_ascendv2__ChartJS';
import getPieChartData from '@salesforce/apex/PORTAL_PieChartController.SERVER_getPieChartData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_GivingHistoryPieChart extends LightningElement {

    @api helperText;
    @api maxDesginations;
    @api pieChartColorsCSV;
    @api noDataLabel;

    noData = false;

    chartJsRendered = false;
    listOfColors = [];
    permissionMap = {};
    callbackDone = false;

    get chartStyle() {
        return this.callbackDone ? '' : 'display: none';
    }

    get isDisplayPieChart() {
        return !this.noData || this.noDataLabel;
    }

    connectedCallback() {
        if (this.pieChartColorsCSV) {
            this.listOfColors = this.pieChartColorsCSV.split(',').map(s => s.trim());
        }
    }

    renderedCallback() {
        if (this.chartJsRendered) {
            return;
        }

        this.chartJsRendered = true;
        loadScript(this, chartJs)
        .then(() => {
            getPieChartData({'paramMap' : {'maxDesignations' : this.maxDesginations}})
            .then(result => {
                this.permissionMap = result['permissionMap'];
                let records = result['records'];
                this.callbackDone = true;

                if (records['labels'].length == 0 || records['values'].length == 0) {
                    this.noData = true;
                    return;
                }

                let chart = new Chart(this.template.querySelector('.pie-chart'), {
                    type: 'pie',
                    data: {
                        datasets: [
                            {
                                data: records['values'],
                                backgroundColor: this.listOfColors,
                                hoverBackgroundColor : this.listOfColors
                            }
                        ],
                        labels: records['labels']
                    },
                    options: {
                        responsive: true,
                        aspectRatio: 2,
                        plugins: {
                            legend: {
                                position: 'left',
                                align: 'center',
                                display: true
                            },
                        },
                        animation: {
                            animateScale: true,
                            animateRotate: true
                        },
                        tooltips: {
                            bodyFontSize: 10,
                            callbacks: {
                                label: function(tooltipItem, data) {
                                    let returnLabel = []; // multi-line tooltip
                                    var dataset = data.datasets[tooltipItem.datasetIndex];
                                    var label = data.labels[tooltipItem.index];
                                    var total = dataset.data.reduce(function(previousValue, currentValue, currentIndex, array) {
                                        return previousValue + currentValue;
                                    });
                                    var currentValue = dataset.data[tooltipItem.index];
                                    //calculate the precentage based on the total and current item, also this does a rough rounding to give a whole number
                                    var percentage = Math.floor(((currentValue/total) * 100)+0.5);
                                    //returnLabel += label + ' ';
                                    returnLabel.push(label);
                                    returnLabel.push(percentage + "%" + ' ($' + Number(currentValue).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
                                    //returnLabel += ;
                                    return returnLabel;
                                },
                                labelColor: function(tooltipItem, chart) {
                                    var dataset = chart.data.datasets[0];
                                    let backgroundColor = dataset.hoverBackgroundColor[tooltipItem.index];
                                    return {
                                        backgroundColor: backgroundColor
                                    };
                                }
                            }
                        },
                        title: {
                            display: false,
                            text: this.chartTitle,
                            fontSize : 24,
                            padding : 20,
                        }
                    }
                });

                chart.resize();
            })
            .catch(error => {
                console.log(error);
                this.showNotification('Error', error.body.message, 'error');
            });


        })
        .catch(error => {
            console.log(error);
        });
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        this.dispatchEvent(evt);
    }
}