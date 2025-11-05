import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, VisitorlogsRoutingModule } from './visitorlogs-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    VisitorlogsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class VisitorlogsModule { }
