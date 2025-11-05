import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, MediasRoutingModule } from './medias-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    MediasRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class MediasModule { }
