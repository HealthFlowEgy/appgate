import { Component, OnDestroy, OnInit } from '@angular/core';
import { takeWhile } from 'rxjs/operators';
import { DashboardClient, ProgressInfo } from '../../../@core/network/dashboard-client.service';

@Component({
  selector: 'ngx-progress-section',
  styleUrls: ['./progress-section.component.scss'],
  templateUrl: './progress-section.component.html',
})
export class ECommerceProgressSectionComponent implements OnInit, OnDestroy {

  private alive = true;

  progressInfoData: ProgressInfo[];

  constructor(private dashboardClient: DashboardClient) {
  }
  ngOnInit(): void {
    this.dashboardClient.progressInfo()
      .subscribe((response) => {
        this.progressInfoData = response;
      });
  }

  ngOnDestroy() {
    this.alive = true;
  }
}
