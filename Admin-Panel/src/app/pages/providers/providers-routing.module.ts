import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ProvidersComponent } from './providers.component';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';

const routes: Routes = [
  {
    path: '',
    component: ProvidersComponent,
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
export class ProvidersRoutingModule {
}

export const routedComponents = [
  ProvidersComponent, 
  ListComponent,
  SaveComponent
];


