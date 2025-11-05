import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, MediasRoutingModule } from './medias-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    MediasRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class MediasModule { }
