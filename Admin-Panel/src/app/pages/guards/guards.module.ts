import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, GuardsRoutingModule } from './guards-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    GuardsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class GuardsModule { }
