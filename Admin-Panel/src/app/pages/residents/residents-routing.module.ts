import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ResidentsComponent } from './residents.component';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';

const routes: Routes = [
  {
    path: '',
    component: ResidentsComponent,
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
    MaterialModule,
    RouterModule.forChild(routes),
  ],
  exports: [
    RouterModule,
  ],
})
export class ResidentsRoutingModule {
}

export const routedComponents = [
  ResidentsComponent, 
  ListComponent,
  SaveComponent
];


