import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, ProvidersRoutingModule } from './providers-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    ProvidersRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ProvidersModule { }
