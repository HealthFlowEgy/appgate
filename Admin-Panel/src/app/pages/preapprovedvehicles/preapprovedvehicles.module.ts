import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, PreapprovedvehiclesRoutingModule } from './preapprovedvehicles-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    PreapprovedvehiclesRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PreapprovedvehiclesModule { }
