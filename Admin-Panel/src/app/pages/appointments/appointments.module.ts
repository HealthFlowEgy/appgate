import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, AppointmentsRoutingModule } from './appointments-routing.module';
import { GoogleMapsModule } from '@angular/google-maps';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    AppointmentsRoutingModule
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class AppointmentsModule { }
