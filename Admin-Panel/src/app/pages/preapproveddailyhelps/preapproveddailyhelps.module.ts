import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, PreapproveddailyhelpsRoutingModule } from './preapproveddailyhelps-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    PreapproveddailyhelpsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PreapproveddailyhelpsModule { }
