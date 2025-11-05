import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, ServicesRoutingModule } from './services-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    ServicesRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ServicesModule { }
