import { Component, OnDestroy, ViewChild, OnInit } from '@angular/core';
import { takeWhile } from 'rxjs/operators';

import { NbThemeService } from '@nebular/theme';
import { OrderSummary, OrdersChart, DashboardClient } from '../../../../@core/network/dashboard-client.service';
import { CoreService } from '../../../../@core/service/core.service';
import { OrdersChartComponent } from '../../../../@theme/components/charts-panel/charts/orders-chart.component';

@Component({
  selector: 'ngx-user-analytics-charts',
  styleUrls: ['./charts-panel.component.scss'],
  templateUrl: './charts-panel.component.html',
})
export class UserAnalyticsChartsPanelComponent implements OnInit, OnDestroy {

  private alive = true;

  chartPanelSummary: OrderSummary[];
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
        iconColor: orderProfitLegend.firstItem,
        title: 'New Registrations',
      }
    ];
  }

  setPeriodAndGetChartData(value: string): void {
    if (this.period !== value) {
      this.period = value;
    }

    this.getOrdersChartData(value);
  }

  getOrdersChartData(period: string) {
    this.dashboardClient.userAnalytics(period)
      .subscribe((response) => {
        this.chartPanelSummary = response.summary;
        this.ordersChartData = response.chart;
      });
  }

  ngOnDestroy() {
    this.alive = false;
  }
}
