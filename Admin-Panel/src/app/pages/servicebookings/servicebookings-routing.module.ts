import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ServicebookingsComponent } from './servicebookings.component';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';

const routes: Routes = [
  {
    path: '',
    component: ServicebookingsComponent,
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
export class ServicebookingsRoutingModule {
}

export const routedComponents = [
  ServicebookingsComponent, 
  ListComponent,
  SaveComponent
];


