import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, PaymentrequestsRoutingModule } from './paymentrequests-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    PaymentrequestsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PaymentrequestsModule { }
