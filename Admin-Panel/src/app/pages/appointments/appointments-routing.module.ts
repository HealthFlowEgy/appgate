import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppointmentsComponent } from './appointments.component';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';

const routes: Routes = [
  {
    path: '',
    component: AppointmentsComponent,
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
export class AppointmentsRoutingModule {
}

export const routedComponents = [
  AppointmentsComponent, 
  ListComponent,
  SaveComponent
];


