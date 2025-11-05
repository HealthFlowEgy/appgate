import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, ServicesRoutingModule } from './services-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    ServicesRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ServicesModule { }
