import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, AmenitiesRoutingModule } from './amenities-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    AmenitiesRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class AmenitiesModule { }
