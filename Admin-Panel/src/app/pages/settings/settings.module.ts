import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, SettingsRoutingModule } from './settings-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    SettingsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class SettingsModule { }
