import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, AnnouncementsRoutingModule } from './announcements-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    AnnouncementsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class AnnouncementsModule { }
