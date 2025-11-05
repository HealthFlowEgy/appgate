import {NgModule, ModuleWithProviders} from '@angular/core';
import {CommonModule} from '@angular/common';
import { AdminConfigClient } from './adminconfig-client.service';
import { ListDataSource } from './list-data-source';
import { UserClient } from './user-client.service';
import { CategoryClient } from './category-client.service';
import { PaymentmethodClient } from './paymentmethod-client.service';
import { SettingClient } from './setting-client.service';
import { FaqClient } from './faq-client.service';
import { SupportClient } from './support-client.service';
import { DashboardClient } from './dashboard-client.service';
import { WalletClient } from './wallet-client.service';
import { BannerClient } from './banner-client.service';
import { CouponClient } from './coupon-client.service';
import { AppointmentClient } from './appointment-client.service';
import { ProviderClient } from './provider-client.service';
import { PlanClient } from './plan-client.service';
import { CommentClient } from './comment-client.service';
import { MediaClient } from './media-client.service';
import { ProjectClient } from './project-client.service';
import { BuildingClient } from './building-client.service';
import { FlatClient } from './flat-client.service';
import { ComplaintClient } from './complaint-client.service';
import { AnnouncementClient } from './announcement-client.service';
import { ResidentClient } from './resident-client.service';
import { AmenityClient } from './amenity-client.service';
import { GuardClient } from './guard-client.service';
import { VisitorlogClient } from './visitorlog-client.service';
import { PaymentrequestClient } from './paymentrequest-client.service';
import { ServicebookingClient } from './servicebooking-client.service';
import { PermissionClient } from './permission-client.service';

const SERVICES = [
  ListDataSource,
  AdminConfigClient,
  UserClient,
  CategoryClient,
  PaymentmethodClient,
  SettingClient,
  FaqClient,
  SupportClient,
  DashboardClient,
  WalletClient,
  BannerClient,
  CouponClient,
  AppointmentClient,
  ProviderClient,
  PlanClient,
  CommentClient,
  MediaClient,
  ProjectClient,
  BuildingClient,
  FlatClient,
  ComplaintClient,
  AnnouncementClient,
  ResidentClient,
  AmenityClient,
  GuardClient,
  VisitorlogClient,
  PaymentrequestClient,
  ServicebookingClient,
  PermissionClient
];

@NgModule({
  imports: [
    CommonModule,
  ],
  providers: [
    ...SERVICES,
  ],
})
export class NetworkModule {
  static forRoot(): ModuleWithProviders<NetworkModule> {
    return <ModuleWithProviders<NetworkModule>>{
      ngModule: NetworkModule,
      providers: [
        ...SERVICES,
      ],
    };
  }
}
