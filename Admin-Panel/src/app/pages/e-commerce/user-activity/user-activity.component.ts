import { Component, OnDestroy, OnInit } from '@angular/core';
import { NbThemeService } from '@nebular/theme';
import { takeWhile } from 'rxjs/operators';

import { DashboardClient, UserActive } from '../../../@core/network/dashboard-client.service';

@Component({
  selector: 'ngx-user-activity',
  styleUrls: ['./user-activity.component.scss'],
  templateUrl: './user-activity.component.html',
})
export class ECommerceUserActivityComponent implements OnInit, OnDestroy {

  private alive = true;

  userActivity: UserActive[] = [];
  type = 'week';
  types = ['week', 'month', 'year', 'all'];
  currentTheme: string;

  constructor(private dashboardClient: DashboardClient, private themeService: NbThemeService) {
    this.themeService.getJsTheme()
      .pipe(takeWhile(() => this.alive))
      .subscribe(theme => {
        this.currentTheme = theme.name;
    });
  }

  ngOnInit(): void {
    this.getUserActivity(this.type);
  }

  getUserActivity(period: string) {
    this.dashboardClient.activityAnalytics(period)
      .subscribe((userActivityData) => {
        this.userActivity = userActivityData;
      });
  }

  ngOnDestroy() {
    this.alive = false;
  }
}
