import { NgModule } from '@angular/core';
import {
  NbButtonModule,
  NbCardModule,
  NbProgressBarModule,
  NbTabsetModule,
  NbUserModule,
  NbIconModule,
  NbSelectModule,
  NbListModule,
} from '@nebular/theme';
import { NgxEchartsModule } from 'ngx-echarts';
import { NgxChartsModule } from '@swimlane/ngx-charts';

import { GoogleMapsModule } from '@angular/google-maps';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { ECommerceComponent } from './e-commerce.component';
// import { ChartModule } from 'angular2-chartjs';

import { ECommerceUserActivityComponent } from './user-activity/user-activity.component';
import { ECommerceProgressSectionComponent } from './progress-section/progress-section.component';

import { LeafletModule } from '@asymmetrik/ngx-leaflet';
import { UserAnalyticsChartsPanelComponent } from './charts-panel/users-analysis/charts-panel.component';
import { ECommerceChartsPanelComponent } from './charts-panel/orders-analysis/charts-panel.component';
import { OrdersMapComponent } from './orders-map/orders-map.component';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    NbCardModule,
    NbUserModule,
    NbButtonModule,
    NbIconModule,
    NbTabsetModule,
    NbSelectModule,
    NbListModule,
    // ChartModule,
    NbProgressBarModule,
    NgxEchartsModule,
    NgxChartsModule,
    LeafletModule,
    GoogleMapsModule
  ],
  declarations: [
    ECommerceComponent,
    ECommerceChartsPanelComponent,
    ECommerceUserActivityComponent,
    ECommerceProgressSectionComponent,
    UserAnalyticsChartsPanelComponent,
    OrdersMapComponent
  ],
  providers: [
  ],
})
export class ECommerceModule { }
