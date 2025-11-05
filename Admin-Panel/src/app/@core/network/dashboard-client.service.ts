import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';

import {BaseClient} from './base-client.service';

export interface OrderProfitChartSummary {
  title: string;
  value: number;
}

export class OrderAnalyticsResponse {
  chart: OrdersChart;
  summary: OrderSummary[];
}

export class OrdersChart {
  chartLabel: string[];
  linesData: number[][];
}

export class OrderSummary {
  title: string;
  value: number;
}

export class UserAnalyticsResponse {
  chart: UserChart;
  summary: OrderSummary[];
}

export class UserChart {
  chartLabel: string[];
  linesData: number[][];
}

export class UserStatisticsResponse {
  total: number;
  customers: number;
  stores: number;
}

export class DailyActiveChart {
  weeks: string[];
  count: number[];
}

export class TrafficList {
  date: string;
  value: number;
  delta: {
    up: boolean;
    value: number;
  };
  comparison: {
    prevDate: string;
    prevValue: number;
    nextDate: string;
    nextValue: number;
  };
}

export interface ProgressInfo {
  title: string;
  value: number;
  activeProgress: number;
  description: string;
}

export interface UserActive {
  date: string;
  pagesVisitCount: number;
  deltaUp: boolean;
  newVisits: number;
}

@Injectable()
export class DashboardClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/dashboard';
  }

  public orderAnalytics(period): Observable<OrderAnalyticsResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<OrderAnalyticsResponse>(this.getBaseEndpoint() + '/order-analytics?period=' + period,
        {headers: this.getHeaders(token)});
    }));
  }

  public progressInfo(): Observable<Array<ProgressInfo>> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<ProgressInfo>>(this.getBaseEndpoint() + '/progress-info',
        {headers: this.getHeaders(token)});
    }));
  }

  public userAnalytics(period): Observable<UserAnalyticsResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<UserAnalyticsResponse>(this.getBaseEndpoint() + '/user-analytics?period=' + period,
        {headers: this.getHeaders(token)});
    }));
  }

  public transactionAnalytics(period): Observable<UserAnalyticsResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<UserAnalyticsResponse>(this.getBaseEndpoint() + '/transaction-analytics?period=' + period,
        {headers: this.getHeaders(token)});
    }));
  }

  public activityAnalytics(period): Observable<UserActive[]> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<UserActive[]>(this.getBaseEndpoint() + '/activity-analytics?period=' + period,
        {headers: this.getHeaders(token)});
    }));
  }

  public userStatitics(): Observable<UserStatisticsResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<UserStatisticsResponse>(this.getBaseEndpoint() + '/user-statitics',
        {headers: this.getHeaders(token)});
    }));
  }
  
  public dailyActiveAnalytics(): Observable<DailyActiveChart> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<DailyActiveChart>(
        this.getBaseEndpoint() + '/daily-active-analytics',
        {headers: this.getHeaders(token)});
    }));
  }
}
