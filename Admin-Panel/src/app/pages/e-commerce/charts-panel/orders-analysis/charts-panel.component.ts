import { Component, OnDestroy, ViewChild, OnInit } from '@angular/core';
import { takeWhile } from 'rxjs/operators';


import { NbThemeService } from '@nebular/theme';
import { OrderSummary, OrdersChart, DashboardClient, OrderProfitChartSummary } from '../../../../@core/network/dashboard-client.service';
import { CoreService } from '../../../../@core/service/core.service';
import { OrdersChartComponent } from '../../../../@theme/components/charts-panel/charts/orders-chart.component';

@Component({
  selector: 'ngx-ecommerce-charts',
  styleUrls: ['./charts-panel.component.scss'],
  templateUrl: './charts-panel.component.html',
})
export class ECommerceChartsPanelComponent implements OnInit, OnDestroy {

  private alive = true;

  chartPanelSummary: OrderProfitChartSummary[];
  period: string = 'week';
  ordersChartData: OrdersChart;
  chartLegend = [];

  @ViewChild('ordersChart', { static: true }) ordersChart: OrdersChartComponent;

  constructor(private dashboardClient: DashboardClient, private coreService: CoreService, private themeService: NbThemeService) {
    this.themeService.getJsTheme()
      .pipe(takeWhile(() => this.alive))
      .subscribe(theme => {
        const orderProfitLegend = theme.variables.orderProfitLegend;
        this.setLegendItems(orderProfitLegend);
      });

  }

  ngOnInit(): void {
    this.getOrdersChartData(this.period);
  }

  setLegendItems(orderProfitLegend) {
    this.chartLegend = [
      {
        iconColor: orderProfitLegend.thirdItem,
        title: 'Complete',
      },
      {
        iconColor: orderProfitLegend.secondItem,
        title: 'Other',
      },
      {
        iconColor: orderProfitLegend.firstItem,
        title: 'All',
      },
    ];
  }

  setPeriodAndGetChartData(value: string): void {
    if (this.period !== value) {
      this.period = value;
    }

    this.getOrdersChartData(value);
  }

  getOrdersChartData(period: string) {
    this.dashboardClient.orderAnalytics(period)
      .subscribe((response) => {
        this.chartPanelSummary = response.summary;
        this.ordersChartData = response.chart;
      });
  }

  ngOnDestroy() {
    this.alive = false;
  }
}
