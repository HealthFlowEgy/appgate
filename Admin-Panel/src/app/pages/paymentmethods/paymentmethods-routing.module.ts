import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PaymentmethodsComponent } from './paymentmethods.component';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';

const routes: Routes = [
  {
    path: '',
    component: PaymentmethodsComponent,
    children: [
      {
        path: 'add',
        component: SaveComponent,
      },
      {
        path: 'list',
        component: ListComponent,
      },
      {
        path: 'edit/:id',
        component: SaveComponent,
      },
    ],
  },
];

@NgModule({
  imports: [
    RouterModule.forChild(routes),
  ],
  exports: [
    RouterModule,
  ],
})
export class PaymentmethodsRoutingModule {
}

export const routedComponents = [
  PaymentmethodsComponent, 
  ListComponent,
  SaveComponent
];


