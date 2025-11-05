import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, ComplaintsRoutingModule } from './complaints-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    ComplaintsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ComplaintsModule { }
