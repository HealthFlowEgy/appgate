import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TransactionsComponent } from './transactions.component';
import { ListComponent } from './list/list.component';

const routes: Routes = [
  {
    path: '',
    component: TransactionsComponent,
    children: [
      // {
      //   path: 'add',
      //   component: SaveComponent,
      // },
      {
        path: 'list',
        component: ListComponent,
      },
      // {
      //   path: 'edit/:id',
      //   component: SaveComponent,
      // },
    ],
  },
];

@NgModule({
  imports: [
    MaterialModule,
    RouterModule.forChild(routes),
  ],
  exports: [
    RouterModule,
  ],
})
export class TransactionsRoutingModule {
}

export const routedComponents = [
  TransactionsComponent, 
  ListComponent,
  // SaveComponent
];


