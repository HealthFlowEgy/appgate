import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, ProvidersRoutingModule } from './providers-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    ProvidersRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ProvidersModule { }
