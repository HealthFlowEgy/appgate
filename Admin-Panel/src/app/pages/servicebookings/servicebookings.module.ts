import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, ServicebookingsRoutingModule } from './servicebookings-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    ServicebookingsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ServicebookingsModule { }
