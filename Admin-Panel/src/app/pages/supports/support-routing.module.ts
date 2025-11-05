import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListComponent } from './list/list.component';
import { SupportsComponent } from './suppport.component';

const routes: Routes = [
  {
    path: '',
    component: SupportsComponent,
    children: [
      {
        path: 'list',
        component: ListComponent,
      }
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
export class SupportsRoutingModule {
}

export const routedComponents = [
  SupportsComponent, 
  ListComponent
];


