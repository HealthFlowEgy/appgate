import { ModuleWithProviders, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  NbActionsModule,
  NbLayoutModule,
  NbMenuModule,
  NbSearchModule,
  NbSidebarModule,
  NbUserModule,
  NbContextMenuModule,
  NbButtonModule,
  NbSelectModule,
  NbIconModule,
  NbThemeModule,
  NbSpinnerModule,
  NbCardModule,
  NbCheckboxModule,
  NbRadioModule,
  NbTooltipModule,
  NbTabsetModule,
  NbInputModule
} from '@nebular/theme';
import { NbEvaIconsModule } from '@nebular/eva-icons';
import { NbSecurityModule } from '@nebular/security';

import {
  FooterComponent,
  HeaderComponent,
} from './components';
import {
  CapitalizePipe,
  PluralPipe,
  RoundPipe,
  TimingPipe,
  NumberWithCommasPipe,
  LanguageTitlePipe,
} from './pipes';
import {
  OneColumnLayoutComponent,
  ThreeColumnsLayoutComponent,
  TwoColumnsLayoutComponent,
} from './layouts';
import { DEFAULT_THEME } from './styles/theme.default';
import { COSMIC_THEME } from './styles/theme.cosmic';
import { CORPORATE_THEME } from './styles/theme.corporate';
import { DARK_THEME } from './styles/theme.dark';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { Angular2SmartTableModule } from 'angular2-smart-table';
import { OrdersChartComponent } from './components/charts-panel/charts/orders-chart.component';
import { ChartPanelSummaryComponent } from './components/charts-panel/chart-panel-summary/chart-panel-summary.component';
import { ChartPanelHeaderComponent } from './components/charts-panel/chart-panel-header/chart-panel-header.component';
import { ECommerceLegendChartComponent } from './components/legend-chart/legend-chart.component';
// import { ChartModule } from 'angular2-chartjs';
import { NgxEchartsModule } from 'ngx-echarts';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { MetaeditorComponent } from './components/metaeditor/metaeditor.component';

const BASE_MODULES = [CommonModule, FormsModule, ReactiveFormsModule, TranslateModule];

const NB_MODULES = [
  NbLayoutModule,
  NbMenuModule,
  NbUserModule,
  NbActionsModule,
  NbSearchModule,
  NbSidebarModule,
  NbContextMenuModule,
  NbSecurityModule,
  NbButtonModule,
  NbSelectModule,
  NbIconModule,
  NbEvaIconsModule,
  NbSpinnerModule,
  NbMenuModule,
  NbCardModule,
  Angular2SmartTableModule,
  NbCheckboxModule,
  NbRadioModule,
  NbTooltipModule,
  NbTabsetModule,
  // ChartModule,
  NgxEchartsModule,
  NgxChartsModule,
  NbInputModule
];
const COMPONENTS = [
  HeaderComponent,
  FooterComponent,
  OneColumnLayoutComponent,
  ThreeColumnsLayoutComponent,
  TwoColumnsLayoutComponent,

  OrdersChartComponent,
  ChartPanelSummaryComponent,
  ChartPanelHeaderComponent,

  ECommerceLegendChartComponent,

  MetaeditorComponent
];
const PIPES = [
  CapitalizePipe,
  PluralPipe,
  RoundPipe,
  TimingPipe,
  NumberWithCommasPipe,
  LanguageTitlePipe
];

@NgModule({
  imports: [...BASE_MODULES, ...NB_MODULES, NgxEchartsModule.forRoot({ echarts: () => import('echarts') }),], 
  exports: [...BASE_MODULES, ...NB_MODULES, ...PIPES, ...COMPONENTS],
  declarations: [...COMPONENTS, ...PIPES],
})
export class ThemeModule {
  static forRoot(): ModuleWithProviders<ThemeModule> {
    return {
      ngModule: ThemeModule,
      providers: [
        ...NbThemeModule.forRoot(
          {
            name: localStorage.getItem('theme') ?? 'default',
          },
          [DEFAULT_THEME, COSMIC_THEME, CORPORATE_THEME, DARK_THEME],
        ).providers,
      ],
    };
  }
}
