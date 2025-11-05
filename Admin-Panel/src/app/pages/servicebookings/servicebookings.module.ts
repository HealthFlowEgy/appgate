import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, ServicebookingsRoutingModule } from './servicebookings-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    ServicebookingsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ServicebookingsModule { }
