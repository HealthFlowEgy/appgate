import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, PermissionsRoutingModule } from './permission-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    PermissionsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PermissionsModule { }
