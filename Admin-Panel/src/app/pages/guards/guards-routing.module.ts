import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { GuardsComponent } from './guards.component';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';

const routes: Routes = [
  {
    path: '',
    component: GuardsComponent,
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
export class GuardsRoutingModule {
}

export const routedComponents = [
  GuardsComponent, 
  ListComponent,
  SaveComponent
];


