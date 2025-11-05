import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, BuildingsRoutingModule } from './buildings-routing.module';
import { NbInputModule } from '@nebular/theme';
import { MaterialModule } from '../../@core/material/material.module';

@NgModule({
  imports: [
    ThemeModule,
    BuildingsRoutingModule,
    MaterialModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class BuildingsModule { }
