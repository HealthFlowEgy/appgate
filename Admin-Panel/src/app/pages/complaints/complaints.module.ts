import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, ComplaintsRoutingModule } from './complaints-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    ComplaintsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class ComplaintsModule { }
