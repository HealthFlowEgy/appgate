import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ServicesComponent } from './services.component';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';
import { ComplaintTypeListComponent } from './complainttypes/list.component';

const routes: Routes = [
  {
    path: '',
    component: ServicesComponent,
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
        path: 'complainttypes/list',
        component: ComplaintTypeListComponent,
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
export class ServicesRoutingModule {
}

export const routedComponents = [
  ServicesComponent, 
  ListComponent,
  SaveComponent,
  ComplaintTypeListComponent
];


