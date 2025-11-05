import {NgModule, ModuleWithProviders} from '@angular/core';
import {CommonModule} from '@angular/common';
import {TranslationService} from './translation.service';
import { CoreService } from './core.service';
import { ToastService } from './toast.service';

const SERVICES = [
  CoreService,
  ToastService,
  TranslationService
];

@NgModule({
  imports: [
    CommonModule,
  ],
  providers: [
    ...SERVICES,
  ],
})
export class ServiceModule {
  static forRoot(): ModuleWithProviders<ServiceModule> {
    return <ModuleWithProviders<ServiceModule>>{
      ngModule: ServiceModule,
      providers: [
        ...SERVICES,
      ],
    };
  }
}
