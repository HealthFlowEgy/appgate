import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, AnnouncementsRoutingModule } from './announcements-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    AnnouncementsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class AnnouncementsModule { }
