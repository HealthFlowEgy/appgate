import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, ProjectsRoutingModule } from './projects-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    ProjectsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ProjectsModule { }
