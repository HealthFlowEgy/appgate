import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SettingsComponent } from './settings.component';
import { SystemComponent } from './system/system.component';
import { SaveComponent } from './save/save.component';

const routes: Routes = [
  {
    path: '',
    component: SettingsComponent,
    children: [
      {
        path: 'system',
        component: SystemComponent,
      },
      {
        path: 'edit',
        component: SaveComponent,
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
export class SettingsRoutingModule {
}

export const routedComponents = [
  SettingsComponent,
  SystemComponent,
  SaveComponent
];


