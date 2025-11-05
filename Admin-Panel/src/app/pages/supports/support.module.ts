import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { SupportsRoutingModule, routedComponents } from './support-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    SupportsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class SupportsModule { }
