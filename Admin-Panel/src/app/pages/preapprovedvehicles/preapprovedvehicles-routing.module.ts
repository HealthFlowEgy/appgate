import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';
import { PreapprovedvehiclesComponent } from './preapprovedvehicles.component';

const routes: Routes = [
  {
    path: '',
    component: PreapprovedvehiclesComponent,
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
export class PreapprovedvehiclesRoutingModule {
}

export const routedComponents = [
  PreapprovedvehiclesComponent, 
  ListComponent,
  SaveComponent
];


