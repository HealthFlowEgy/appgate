import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, BuildingsRoutingModule } from './buildings-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    BuildingsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class BuildingsModule { }
