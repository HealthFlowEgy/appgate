import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, SettingsRoutingModule } from './settings-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    SettingsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class SettingsModule { }
