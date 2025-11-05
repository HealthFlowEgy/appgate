import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, PaymentmethodsRoutingModule } from './paymentmethods-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    PaymentmethodsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PaymentmethodsModule { }
