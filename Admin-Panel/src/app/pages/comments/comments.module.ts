import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, CommentsRoutingModule } from './comments-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    CommentsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class CommentsModule { }
