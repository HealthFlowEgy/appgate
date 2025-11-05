import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, BannersRoutingModule } from './banners-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    BannersRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class BannersModule { }
