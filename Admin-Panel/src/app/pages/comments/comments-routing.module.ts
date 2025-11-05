import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CommentsComponent } from './comments.component';
import { ListComponent } from './list/list.component';

const routes: Routes = [
  {
    path: '',
    component: CommentsComponent,
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
    MaterialModule,
    RouterModule.forChild(routes),
  ],
  exports: [
    RouterModule,
  ],
})
export class CommentsRoutingModule {
}

export const routedComponents = [
  CommentsComponent, 
  ListComponent
];


