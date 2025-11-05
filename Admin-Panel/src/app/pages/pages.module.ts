import { NgModule } from '@angular/core';
import { NbMenuModule, NbSpinnerModule } from '@nebular/theme';

import { ThemeModule } from '../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { PagesComponent } from './pages.component';
import { PagesRoutingModule } from './pages-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    PagesRoutingModule,
    ThemeModule,
    NbMenuModule
  ],
  declarations: [
    PagesComponent,
  ],
})
export class PagesModule {
}
