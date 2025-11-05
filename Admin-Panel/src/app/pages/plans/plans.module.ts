import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, PlansRoutingModule } from './plans-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    PlansRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PlansModule { }
