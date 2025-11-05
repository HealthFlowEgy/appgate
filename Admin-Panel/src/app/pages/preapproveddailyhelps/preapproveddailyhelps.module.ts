import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, PreapproveddailyhelpsRoutingModule } from './preapproveddailyhelps-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    PreapproveddailyhelpsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PreapproveddailyhelpsModule { }
