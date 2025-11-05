import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, TransactionsRoutingModule } from './transactions-routing.module';
import { TransactionAnalyticsChartsPanelComponent } from './transaction-analysis/charts-panel.component';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    TransactionsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
    TransactionAnalyticsChartsPanelComponent
  ],
})
export class TransactionsModule { }
