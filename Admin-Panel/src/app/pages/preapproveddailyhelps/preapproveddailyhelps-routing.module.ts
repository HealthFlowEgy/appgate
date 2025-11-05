import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListComponent } from './list/list.component';
import { SaveComponent } from './save/save.component';
import { PreapproveddailyhelpsComponent } from './preapproveddailyhelps.component';

const routes: Routes = [
  {
    path: '',
    component: PreapproveddailyhelpsComponent,
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
export class PreapproveddailyhelpsRoutingModule {
}

export const routedComponents = [
  PreapproveddailyhelpsComponent, 
  ListComponent,
  SaveComponent
];


