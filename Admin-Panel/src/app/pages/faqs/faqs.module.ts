import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, FaqsRoutingModule } from './faqs-routing.module';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    FaqsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class FaqsModule { }
