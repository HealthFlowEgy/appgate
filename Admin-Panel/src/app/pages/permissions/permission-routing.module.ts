import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PermissionsComponent } from './permission.component';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';

const routes: Routes = [
  {
    path: '',
    component: PermissionsComponent,
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
export class PermissionsRoutingModule {
}

export const routedComponents = [
  PermissionsComponent, 
  ListComponent,
  SaveComponent
];


