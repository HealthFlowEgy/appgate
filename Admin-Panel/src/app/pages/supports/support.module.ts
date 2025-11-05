import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { SupportsRoutingModule, routedComponents } from './support-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    SupportsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class SupportsModule { }
