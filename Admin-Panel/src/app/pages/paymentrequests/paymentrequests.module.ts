import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { MaterialModule } from '../../@core/material/material.module';
import { routedComponents, PaymentrequestsRoutingModule } from './paymentrequests-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    MaterialModule,
    ThemeModule,
    PaymentrequestsRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class PaymentrequestsModule { }
