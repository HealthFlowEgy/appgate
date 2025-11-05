import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, UsersRoutingModule } from './users-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    UsersRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class UsersModule { }
