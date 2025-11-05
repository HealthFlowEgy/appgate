import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, CouponsRoutingModule } from './coupons-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    CouponsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class CouponsModule { }
