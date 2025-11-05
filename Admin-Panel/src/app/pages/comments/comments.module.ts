import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, CommentsRoutingModule } from './comments-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    CommentsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class CommentsModule { }
