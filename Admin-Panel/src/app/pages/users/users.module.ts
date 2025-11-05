import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, UsersRoutingModule } from './users-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    UsersRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class UsersModule { }
