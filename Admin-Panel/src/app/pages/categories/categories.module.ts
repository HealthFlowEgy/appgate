import { NgModule } from '@angular/core';

import { ThemeModule } from '../../@theme/theme.module';
import { routedComponents, CategoriesRoutingModule } from './categories-routing.module';
import { NbInputModule } from '@nebular/theme';

@NgModule({
  imports: [
    ThemeModule,
    CategoriesRoutingModule,
  ],
  declarations: [
    ...routedComponents,
  ],
})
export class CategoriesModule { }
