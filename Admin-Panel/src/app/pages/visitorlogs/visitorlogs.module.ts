import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, VisitorlogsRoutingModule } from './visitorlogs-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    VisitorlogsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class VisitorlogsModule { }
