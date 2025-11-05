import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, ResidentsRoutingModule } from './residents-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    ResidentsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ResidentsModule { }
