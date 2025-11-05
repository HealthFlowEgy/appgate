import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, FaqsRoutingModule } from './faqs-routing.module';

@NgModule({
  imports: [
    ThemeModule,
    FaqsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class FaqsModule { }
