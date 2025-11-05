import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, FlatsRoutingModule } from './flats-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    FlatsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class FlatsModule { }
