import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, GuardsRoutingModule } from './guards-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    GuardsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class GuardsModule { }
