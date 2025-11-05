import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, ResidentsRoutingModule } from './residents-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    ResidentsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ResidentsModule { }
