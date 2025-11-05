import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, PlansRoutingModule } from './plans-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    PlansRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PlansModule { }
