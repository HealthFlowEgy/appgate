import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, AppointmentsRoutingModule } from './appointments-routing.module';
import { GoogleMapsModule } from '@angular/google-maps';

@NgModule({
  imports: [
    ThemeModule,
    AppointmentsRoutingModule
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class AppointmentsModule { }
