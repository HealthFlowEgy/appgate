import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, TransactionsRoutingModule } from './transactions-routing.module';
import { TransactionAnalyticsChartsPanelComponent } from './transaction-analysis/charts-panel.component';

@NgModule({
  imports: [
    ThemeModule,
    TransactionsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
    TransactionAnalyticsChartsPanelComponent
  ],
})
export class TransactionsModule { }
