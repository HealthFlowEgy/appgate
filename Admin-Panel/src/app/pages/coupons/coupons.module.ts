import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, CouponsRoutingModule } from './coupons-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    CouponsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class CouponsModule { }
